/*
  rsl2mat - a MATLAB interface to RSL
  
  Copyright 2011
      Dan Sheldon 
      Oregon State University, Corvallis, OR
      sheldon@eecs.oregonstate.edu

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

/*********************
 * RSL 
 *********************/
#define USE_RSL_VARS
extern "C" {
  #include "rsl.h"
  #include "util.h"
}

/*********************
 * MEX 
 *********************/
#include "mex.h"

#ifdef LARGE_ARRAYS
#define INDEX mwIndex
#else
#define INDEX int
#endif

typedef struct
{
    int nsweeps;
    double max_elev;
    int cartesian;
    int dim;
    int ncappi;
    double *cappi_h;
    double range;
} Options;
    
mxArray *volumeToStruct(Radar *radar, Volume* v, Options opt);
mxArray *optToParams(Options opt);

// These are globals to facilitate cleanup on error
Radar *radar = NULL;
Carpi *carpi = NULL;

#define ERR(msg)                    \
{                                   \
   if(carpi) RSL_free_carpi(carpi); \
   carpi = NULL;                    \
   if(radar) RSL_free_radar(radar); \
   radar = NULL;                    \
   mexErrMsgTxt(msg);               \
}

/**********************************************************************
 * Usage: 
 *
 *    radar = rsl2mat(filename, callid, params)
 *
 *  See rsl2mat.m for details
 *
 **********************************************************************/

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

    /*-- Get arguments --------------------------------------------*/
    if (nrhs < 2) mexErrMsgTxt("First two arguments are required");
    
    const char *filename = (const char *) mxArrayToString(prhs[0]);
    if (filename == NULL) ERR("First argument must be a string");

    const char *callid = (const char *) mxArrayToString(prhs[1]);
    if (callid == NULL) ERR("Second argument must be a string");
    
    // Default options
    Options opt;
    opt.nsweeps = INT_MAX;
    opt.max_elev = 90.0;
    opt.cartesian = 0;
    opt.dim = 600;
    opt.range = 150.0;
    opt.ncappi = 0;
    opt.cappi_h = NULL;

    const mxArray *params = NULL;
    if (nrhs >= 3)
    {
	params = prhs[2];
	if (! mxIsStruct(params)) ERR("Third argument must be a struct");
	
	if (mxGetField(params, 0, "nsweeps"))
	{
	    double nsweeps = mxGetScalar(mxGetField(params, 0, "nsweeps"));
	    if (mxIsInf(nsweeps))
		opt.nsweeps = INT_MAX;
	    else
		opt.nsweeps = (int) nsweeps;
	}

	if (mxGetField(params, 0, "max_elev"))
	    opt.max_elev = mxGetScalar(mxGetField(params, 0, "max_elev"));

	if (mxGetField(params, 0, "cartesian"))
	    opt.cartesian = (int) mxGetScalar(mxGetField(params, 0, "cartesian"));
	
	if (mxGetField(params, 0, "dim"))
	    opt.dim = (int) mxGetScalar(mxGetField(params, 0, "dim"));
	
	if (mxGetField(params, 0, "range"))
	    opt.range = mxGetScalar(mxGetField(params, 0, "range"));
	
	if (mxGetField(params, 0, "cappi_h"))
	{
	    mxArray *cappi_h = mxGetField(params, 0, "cappi_h");
	    opt.ncappi = mxGetNumberOfElements(cappi_h);
	    if (opt.ncappi > 0)
	    {
		if (! mxIsDouble(cappi_h)) ERR("cappi height array must be of type double");
		opt.cappi_h = mxGetPr(cappi_h);
	    }
	}
    }
    
    //    mexPrintf("rsl2mat: filename=%s, callid=%s, nsweeps=%d, cartesian=%d, dim=%d, range=%.2f ncappi=%d\n",filename, callid, opt.nsweeps, opt.cartesian, opt.dim, opt.range, opt.ncappi);
    
    /*-- Ingest radar file ---------------------------------------*/

    // RSL_radar_verbose_on();
    // RSL_select_fields("all", NULL);
    // RSL_read_these_sweeps("all", NULL);

    // 
    // Warning: 
    //
    // The RSL_anyformat_to_radar function will not work here.
    // It causes a problem due to the fork()/exec()/exit() in
    // rsl_readflush(). One option is to comment out the call to
    // rsl_readflush() because all it is trying to do is avoid the
    // broken pipe warning which is suppressed by MATLAB anyway. 
    // 
    // Another option is to use _exit() instead of exit() in
    // rsl_readflush. Apparently the exit() doesn't play nicely with
    // the forked MATLAB process.
    // 
    //
    radar = RSL_wsr88d_to_radar((char *) filename, (char *) callid);

    if (radar == NULL) 
    {
	ERR("Failed to read radar file");
    }
    
    /*-- Populate MATLAB struct -----------------------------------*/

    const char *fields[] = { "station", // 0
			     "year",    // 1
			     "month",   // 2
			     "day",     // 3
			     "hour",    // 4
			     "minute",  // 5
			     "second",  // 6
			     "lat",     // 7
			     "lon",	// 8
			     "height",	// 9
			     "spulse",	// 10
			     "lpulse",	// 11
			     "vcp",	// 12
			     "constants", // 13
			     "params",	// 14
			     "dz",	// 15
			     "vr",	// 16
			     "sw",	// 17
			     "dr",	// 18
			     "ph",	// 19
			     "rh",	// 20
    };					// 21

    mxArray *radarStruct = mxCreateStructMatrix(1, 1, 21, fields);
    
#define SGN(x) (x > 0 ? 1 : -1)
#define ABS(x) (x > 0 ? x : -x)
#define TODECIMAL(d,m,s) ( d + m/60.0 + s/3600.0) 

    double lat = TODECIMAL(radar->h.latd, radar->h.latm, radar->h.lats);
    double lon = TODECIMAL(radar->h.lond, radar->h.lonm, radar->h.lons);

    mxSetField(radarStruct, 0, "station", mxCreateString((char *) radar->h.name));
    mxSetField(radarStruct, 0, "year",    mxCreateDoubleScalar(radar->h.year));
    mxSetField(radarStruct, 0, "month",   mxCreateDoubleScalar(radar->h.month));
    mxSetField(radarStruct, 0, "day",     mxCreateDoubleScalar(radar->h.day));
    mxSetField(radarStruct, 0, "hour",    mxCreateDoubleScalar(radar->h.hour));
    mxSetField(radarStruct, 0, "minute",  mxCreateDoubleScalar(radar->h.minute));
    mxSetField(radarStruct, 0, "second",  mxCreateDoubleScalar(radar->h.sec));
    mxSetField(radarStruct, 0, "lat",     mxCreateDoubleScalar(lat));
    mxSetField(radarStruct, 0, "lon",     mxCreateDoubleScalar(lon));
    mxSetField(radarStruct, 0, "height",  mxCreateDoubleScalar(radar->h.height));
    mxSetField(radarStruct, 0, "spulse",  mxCreateDoubleScalar(radar->h.spulse));
    mxSetField(radarStruct, 0, "lpulse",  mxCreateDoubleScalar(radar->h.lpulse));
    mxSetField(radarStruct, 0, "vcp",     mxCreateDoubleScalar(radar->h.vcp));

    const char *constFields[] = {"BADVAL", "RFVAL", "APFLAG", // 0-2
				 "NOTFOUND_H", "NOTFOUND_V", "NOECHO", // 3-5
				 "RSL_SPEED_OF_LIGHT", // 6
    };						       // 7
    mxArray *constants = mxCreateStructMatrix(1, 1, 7, constFields);
    mxSetField(constants, 0, "BADVAL", mxCreateDoubleScalar(BADVAL));
    mxSetField(constants, 0, "RFVAL", mxCreateDoubleScalar(RFVAL));
    mxSetField(constants, 0, "APFLAG", mxCreateDoubleScalar(APFLAG));
    mxSetField(constants, 0, "NOTFOUND_H", mxCreateDoubleScalar(NOTFOUND_H));
    mxSetField(constants, 0, "NOTFOUND_V", mxCreateDoubleScalar(NOTFOUND_V));
    mxSetField(constants, 0, "NOECHO", mxCreateDoubleScalar(NOECHO));
    mxSetField(constants, 0, "RSL_SPEED_OF_LIGHT", mxCreateDoubleScalar(RSL_SPEED_OF_LIGHT));
    mxSetField(radarStruct, 0, "constants", constants);

    mxSetField(radarStruct, 0, "params", optToParams(opt));

    int nvolumes = radar->h.nvolumes;

    if (nvolumes > DZ_INDEX && radar->v[DZ_INDEX])
	mxSetField(radarStruct, 0, "dz", volumeToStruct(radar, radar->v[DZ_INDEX], opt));
    else
        ERR("no reflectivity data");
    
    if (nvolumes > VR_INDEX && radar->v[VR_INDEX]) 
	mxSetField(radarStruct, 0, "vr", volumeToStruct(radar, radar->v[VR_INDEX], opt));
    else
        ERR("no velocity data");

    if (nvolumes > SW_INDEX && radar->v[SW_INDEX]) 
	mxSetField(radarStruct, 0, "sw", volumeToStruct(radar, radar->v[SW_INDEX], opt));
    else
        ERR("no spectrum width data");

    if (nvolumes > DR_INDEX && radar->v[DR_INDEX]) 
	mxSetField(radarStruct, 0, "dr", volumeToStruct(radar, radar->v[DR_INDEX], opt));

    if (nvolumes > PH_INDEX && radar->v[PH_INDEX]) 
	mxSetField(radarStruct, 0, "ph", volumeToStruct(radar, radar->v[PH_INDEX], opt));

    if (nvolumes > RH_INDEX && radar->v[RH_INDEX]) 
	mxSetField(radarStruct, 0, "rh", volumeToStruct(radar, radar->v[RH_INDEX], opt));

    
    /*-- Return value and cleanup ---------------------------------*/
    if (nlhs >= 1) plhs[0] = radarStruct;

    RSL_free_radar(radar);
    radar = NULL;
}

#define MAX(a,b) (a > b ? a : b)
#define MIN(a,b) (a < b ? a : b)


/*************************************************************
 *  optToParams: Populate a matlab struct with the parameters
 *************************************************************/
mxArray* optToParams(Options opt)
{
    const char *fields[] = {"nsweeps",	 // 0
			    "cartesian", // 1
			    "dim",	 // 2
			    "range",	 // 3
			    "cappi_h",	 // 4
    };					 // 5
    
    mxArray *params = mxCreateStructMatrix(1, 1, 5, fields);

    mxSetField(params, 0, "nsweeps", mxCreateDoubleScalar(opt.nsweeps));
    mxSetField(params, 0, "cartesian", mxCreateDoubleScalar(opt.cartesian));
    mxSetField(params, 0, "dim", mxCreateDoubleScalar(opt.dim));
    mxSetField(params, 0, "range", mxCreateDoubleScalar(opt.range));

    if (opt.ncappi > 0)
    {
	mxArray *cappi_h = mxCreateDoubleMatrix(opt.ncappi, 1, mxREAL);
	double *pr = mxGetPr(cappi_h);
	memcpy(pr, opt.cappi_h, opt.ncappi*sizeof(double));
	mxSetField(params, 0, "cappi_h", cappi_h);
    }

    return params;    
}


/*************************************************************
 *  volumeToStruct: Populate a matlab struct descrbing the volume
 *************************************************************/
mxArray* volumeToStruct(Radar *radar, Volume* vol, Options opt)
{
    const char *volFields[] = { "type",   // 0
				"sweeps", // 1
				"cappis",  // 2
    };					  // 3
    
    mxArray *volumeStruct = mxCreateStructMatrix(1, 1, 3, volFields);
    mxSetField(volumeStruct, 0, "type", mxCreateString(vol->h.type_str));
    
    // Count how many sweeps meet the criteria
    int n_output_sweeps = 0;
    for (int i = 0; i < vol->h.nsweeps; i++)
    {
	Sweep *sweep = vol->sweep[i];
	if (sweep &&
            sweep->h.nrays > 0 &&
            sweep->ray[0]->h.fix_angle <= opt.max_elev &&
            sweep->ray[0]->h.fix_angle > 0) 
	    n_output_sweeps++;
    }
    n_output_sweeps = MIN(n_output_sweeps, opt.nsweeps);

    const char *sweepFields[] = { "elev",	  // 0
				  "elev_num",	  // 1
				  "fix_angle",	  // 2
				  "beam_width",	  // 3
				  "vert_half_bw", // 4
				  "horz_half_bw", // 5
				  "nrays",	  // 6
				  "range_bin1",	  // 7
				  "gate_size",	  // 8
				  "vel_res",	  // 9
				  "sweep_rate",	  // 10
				  "prf",	  // 11
				  "azim_rate",	  // 12
				  "pulse_count",  // 13
				  "pulse_width",  // 14
				  "frequency",	  // 15
				  "wavelength",	  // 16
				  "nyq_vel",	  // 17
				  "nbins",	  // 18
				  "azim_v",       // 19
				  "elev_v",	  // 20
				  "data",	  // 21
    };						  // 22
    
    mxArray *sweepStructs = mxCreateStructMatrix(n_output_sweeps, 1, 22, sweepFields);
    mxSetField(volumeStruct, 0, "sweeps", sweepStructs);

    int i = 0;			// output sweep index
    for (int j = 0; j < vol->h.nsweeps && i < n_output_sweeps; j++)
    {
	Sweep *sweep = vol->sweep[j];
	
	if (sweep &&
            sweep->h.nrays > 0 &&
            sweep->ray[0]->h.fix_angle <= opt.max_elev &&
            sweep->ray[0]->h.fix_angle > 0) 
	{
	    mxSetField(sweepStructs, i, "elev",         mxCreateDoubleScalar(sweep->h.elev));
	    mxSetField(sweepStructs, i, "beam_width",   mxCreateDoubleScalar(sweep->h.beam_width));
	    mxSetField(sweepStructs, i, "vert_half_bw", mxCreateDoubleScalar(sweep->h.vert_half_bw));
	    mxSetField(sweepStructs, i, "horz_half_bw", mxCreateDoubleScalar(sweep->h.horz_half_bw));

	    int nrays = sweep->h.nrays;
	    mxSetField(sweepStructs, i, "nrays", mxCreateDoubleScalar(nrays));

	    // Set additional data based on information from first ray
	    if (nrays <= 0) ERR("Empty sweep!");
	    
	    Ray *r = sweep->ray[0];
	    mxSetField(sweepStructs, i, "elev_num",    mxCreateDoubleScalar(r->h.elev_num));
	    mxSetField(sweepStructs, i, "fix_angle",   mxCreateDoubleScalar(r->h.fix_angle));
	    mxSetField(sweepStructs, i, "range_bin1",  mxCreateDoubleScalar(r->h.range_bin1));
	    mxSetField(sweepStructs, i, "gate_size",   mxCreateDoubleScalar(r->h.gate_size));
	    mxSetField(sweepStructs, i, "vel_res",     mxCreateDoubleScalar(r->h.vel_res));
	    mxSetField(sweepStructs, i, "sweep_rate",  mxCreateDoubleScalar(r->h.sweep_rate));
	    mxSetField(sweepStructs, i, "prf",         mxCreateDoubleScalar(r->h.prf));
	    mxSetField(sweepStructs, i, "azim_rate",   mxCreateDoubleScalar(r->h.azim_rate));
	    mxSetField(sweepStructs, i, "pulse_count", mxCreateDoubleScalar(r->h.pulse_count));
	    mxSetField(sweepStructs, i, "pulse_width", mxCreateDoubleScalar(r->h.pulse_width));
	    mxSetField(sweepStructs, i, "frequency",   mxCreateDoubleScalar(r->h.frequency));
	    mxSetField(sweepStructs, i, "wavelength",  mxCreateDoubleScalar(r->h.wavelength));
	    mxSetField(sweepStructs, i, "nyq_vel",     mxCreateDoubleScalar(r->h.nyq_vel));

	    int nbins = r->h.nbins;
	    mxSetField(sweepStructs, i, "nbins", mxCreateDoubleScalar(nbins));

	    mxArray *data, *azim_v, *elev_v;	
	    if (opt.cartesian)
	    {
		if (opt.dim <= 0) ERR("Invalid dim parameter");
		if (opt.range <= 0) ERR("Invalid range parameter");	    

		data = mxCreateDoubleMatrix(opt.dim, opt.dim, mxREAL);
		double *pr = mxGetPr(data);
		if (!RSL_sweep_to_cart_double(sweep, opt.dim, opt.dim, opt.range, pr))
		{
		    mexErrMsgTxt("Failed to convert to cartesian coordinates");
		}
	    }
	    else
	    {
		azim_v = mxCreateDoubleMatrix(nrays, 1, mxREAL);
		elev_v = mxCreateDoubleMatrix(nrays, 1, mxREAL);
		data   = mxCreateDoubleMatrix(nbins, nrays, mxREAL);

		double *az = mxGetPr(azim_v);
		double *el = mxGetPr(elev_v);
		double *d  = mxGetPr(data);

		for (int j = 0; j < nrays; j++)
		{
		    Ray *ray = sweep->ray[j];
		    az[j] = ray->h.azimuth;
		    el[j] = ray->h.elev;
		    for (int i = 0; i < nbins; i++)
		    {
			d[i] = ray->h.f(ray->range[i]);
		    }
		    d += nbins;
		}

		mxSetField(sweepStructs, i, "azim_v", azim_v);
		mxSetField(sweepStructs, i, "elev_v", elev_v);

	    }

	    mxSetField(sweepStructs, i, "data", data);
	    
	    i++;		// increment output sweep index 
	}
    }

    /*--Make CAPPI: constant-altitue plan position indicator--------------*/
    if (opt.ncappi > 0)
    {	
	const char *cappiFields[] = {"elev", "data"};
	mxArray *cappiStructs = mxCreateStructMatrix(opt.ncappi, 1, 2, cappiFields);

	for (int n=0; n < opt.ncappi; n++)
	{
	    float dx = 2.0*opt.range/opt.dim;
	    float dy = 2.0*opt.range/opt.dim;
	    int radar_x = opt.dim/2;
	    int radar_y = opt.dim/2;

	    mxArray *data = mxCreateDoubleMatrix(opt.dim, opt.dim, mxREAL);
	    double  *pr = mxGetPr(data);

	    carpi = RSL_volume_to_carpi(vol,
					opt.cappi_h[n], 
					opt.range, 
					dx, dy, 
					opt.dim, opt.dim, 
					radar_x, radar_y,
					0, 0); // lat, long not used (?)
	
	    for (int i = 0; i < opt.dim; i++)
	    {
		int y = i;
		for (int j = 0; j < opt.dim; j++)
		{
		    int x = opt.dim - j - 1;
		    pr[j] = carpi->f(carpi->data[x][y]);
		}
		pr += opt.dim;
	    }
	    
	    RSL_free_carpi(carpi);
	    carpi = NULL;

	    mxSetField(cappiStructs, n, "elev", mxCreateDoubleScalar(opt.cappi_h[n]));
	    mxSetField(cappiStructs, n, "data", data);
	}
	mxSetField(volumeStruct, 0, "cappis", cappiStructs);
    }

    return volumeStruct;
}

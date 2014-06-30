function [ radar ] = alignSweepsToFixed( radar, azResolution, rangeResolution, rmax, method, interpolate, elevations )
%alignSweepsToFixed Align all reflectivity and radial velocity sweeps in a
%volume scan to a fixed grid
%
% [radar_aligned] = alignSweepsToFixed(radar, azResolution, rangeResolution, rmax, method, interpolate, elevations)
%
% radar                          : radar structure returned by rsl2mat 
% azResolution (optional)        : the angle increment in azimuths. 
%                                  e.g. 0.5 indicates a total of 720 measurements and so on. 
% rangeResolution (optional)     : the resolution in range from the radar in meters. 
%                                  e.g. 250 means a gate size of 250m.  Defaults to 250. 
% rmax (optional)                : the maximum range for the aligned reflectiviy and 
%                                  radial velocity sweeps in meters. 
%                                  e.g. 37500 means a maximum range of 37.5 km.  
% method (optional)              : the method of interpolation to be used. 
%                                  Possible values : ['linear', 'nearest', 'cubic', 'spline']
% interpolate                    : boolean flag for whether to do interpolation or not. 
%                                  e.g.  'true' means that the method will
%                                  interpolate along elevations.
% elevations (optional)          : the list of elevations for the aligned sweeps. 
%                                  e.g. [0.5 1.5 2.5 3.5 4.5] will consider
%                                  5 lowest sweeps and match them with the
%                                  data available about these elevations using the specified
%                                  interpolation method. Defaults to
%                                  [0.5 1.5 2.5 3.5 4.5] which are the
%                                  elevations for the most common VCP (32). 
% radar_aligned                  : the volume scan with all the reflectivity and radial velocity
%                                  sweeps sligned to the speicifed fixed polar grid. 
% 
% Note: 
% 1. The radial velocity sweeps in the radar object should be dealiased
% first. 
% 2. If you choose to do interpolation, be aware that it is a slow
% procedure. 

% Default values for all the optional parameters. 
if nargin < 7
    elevations = [0.5 1.5 2.5 3.5 4.5];
end

if nargin < 6
    interpolate = false;
end

if nargin < 5,
    method = 'nearest';
end

if nargin < 4,
    rmax =37500;
end

if nargin < 3,
    rangeResolution = 250;
end

if nargin < 2,
    azResolution = 0.5;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1. DZ is recorded for every sweep. 
%         Extract only one sweep per elevation angle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

radar.dz.sweeps = unique_elev_sweeps(radar, 'dz');
radar.vr.sweeps = unique_elev_sweeps(radar, 'vr');
radar.sw.sweeps = unique_elev_sweeps(radar, 'sw');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 2. Align all sweeps to fixed polar grid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Define the fixed polar grid
numRays = round(360 / azResolution);
numBins = round(rmax/rangeResolution);

numDzSweeps = size(radar.dz.sweeps,1);
numVrSweeps = size(radar.vr.sweeps,1);
numSwSweeps = size(radar.sw.sweeps,1);
numSweeps   = max([numDzSweeps, numVrSweeps, numSwSweeps]);

fields         = {'dz' , 'vr',  'sw'};
default_vals   = {nan  ,  nan,   nan};
sweepCount    = {numDzSweeps, numVrSweeps, numSwSweeps}; 

FLAG_START = 131067;

for fi = 1:length(fields)

    thefield = fields{fi};
    
    % Match all sweeps to the fixed grid above numBins X numRays
    for i=1:numSweeps,
        j = min ( i, sweepCount{fi} );                                         % different number of sweeps in VR and DZ
        sweep = radar.(thefield).sweeps(j);                                    % the current reflectivity sweep
        [az,radial] = get_az_range(sweep);                                     % obtain its azimuths and range

        data = sweep.data;
        data(data >= FLAG_START) = default_vals{fi};
        
        F = radarInterpolant(data, az, radial, method);               % Create the interpolating function
        
        % Construct the query points
        r   = rangeResolution:rangeResolution:rmax;
        phi = azResolution:azResolution:360;

        [PHI, R] = meshgrid(phi, r);                                                   
        data = F(R, PHI);                                                      % query data in NDGRID format instead of MESHGRID. 
                     
%        data(data == radar.constants.BADVAL) = default_vals{fi};               % Replace all BADVAL by -inf
        
        radar.(thefield).sweeps(j).data = data;                        % Re assign fields of the radar_aligned structure
        radar.(thefield).sweeps(j).nbins = numBins;  
        radar.(thefield).sweeps(j).nrays = numRays;
        radar.(thefield).sweeps(j).range_bin1 = rangeResolution; 
        radar.(thefield).sweeps(j).gate_size = rangeResolution; 
        radar.(thefield).sweeps(j).azim_v = (azResolution:azResolution:360)';
        
    end

end


if interpolate==true,
    
    % 1-D Interpolation along elevations
    
    %Collect all VR and DZ Sweeps
    DZ = radar.dz.sweeps;
    VR = radar.vr.sweeps;
    
    % interpolate sweeps to 'elevations'
    DZ_interp = interpolateSweeps(DZ,elevations,method);
    VR_interp = interpolateSweeps(VR,elevations,method);
    
    % assign them to radar_structure
    for i=1:size(elevations,2),
        
        j = min(i,size(DZ_interp,1));
        radar.dz.sweeps(j).elev = elevations(j);
        radar.dz.sweeps(j).data = reshape(DZ_interp(j).data,numBins,numRays);
        
        iVR = min(i,size(VR_interp,1));
        radar.vr.sweeps(iVR).elev = elevations(iVR);
        radar.vr.sweeps(iVR).data = reshape(VR_interp(iVR).data,numBins,numRays);                
    end
    
    
end

end
function [data,grd]=nj_tslice(ncRef,var,iTime, level)
% NJ_TSLICE - Get data and coordinates from a CF-compliant file at a specific time step and level
%
% Usage:
%   [data,grd]=nj_tslice(ncRef,var,[iTime], [level]);
% where,
%   ncRef - Reference to netcdf file. It can be either of two
%           a. local file name or a URL  or
%           b. An 'mDataset' matlab object, which is the reference to already
%              open netcdf file.
%              [ncRef=mDataset(uri)]
%   var - variable to slice
%   iTime - time step to extract data. Use 'inf' for last time step.
%   level - vertical level (if not supplied, volume data is retrieved.) Use
%   'inf' for last level.
% returns,          
%   data - data  - matlab array       
%          grd   - structure containing lon,lat,z,jdmat (Matlab datenum)         
% e.g.,
%   uri ='http://coast-enviro.er.usgs.gov/cgi-bin/nph-dods/models/adria/roms_sed/bora_feb.nc';% NetCDF/OpenDAP/NcML file
%   [data,grd]=nj_tslice(uri,'temp',2, 14) - Retrieve data from level 14 at time step 2
%   [data,grd]=nj_tslice(uri,'temp',2) - Retrieve 3D data at time step 2 
%   [data,grd]=nj_tslice(uri,'h') - Retrieve 2D non time dependent array 
%
%
% rsignel1@usgs.gov
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu)  (C) 2008
% Mississippi State University


if nargin < 2, help(mfilename), return, end

%initialize
%data (volume or subset)
data=[]; 
%structure containing lon,lat,z
grd.lat=[];
grd.lon=[];
grd.z=[];
grd.time=[];
isNcRef=0;

try 
    if (isa(ncRef, 'mDataset')) %check for mDataset Object
        nc = ncRef;
        isNcRef=1;
    else
        % open CF-compliant NetCDF File as a Common Data Model (CDM) "Grid Dataset"
        nc = mDataset(ncRef);         
    end
    
    geogrid = getGeoGridVar(nc, var); %get geo grid
        
    switch nargin
      case 2
        myLevel = 0;
        myTime = 0;
        % read the volume data (3D). All times.
        myData = getData(geogrid);
      case 3         
        myLevel = 0;
        myTime = iTime;
        if (isinf(myTime))
           myTime = maxIndex(geogrid);           
        end
        % read the volume data at given time index(3D)
        myData = getData(geogrid, myTime);
      case 4       
        myLevel = level;
        myTime = iTime;
        if ( (isinf(myTime)) || (isinf(myLevel)) )
           [tindex, zindex] = maxIndex(geogrid);           
        end
        if (isinf(myTime)); myTime = tindex; end;
        if (isinf(myLevel)); myLevel = zindex; end;  
        
         % read a Y-X 'horizontal slice' at the given time and specified vertical index (2D)
        myData = getData(geogrid, myTime, myLevel);
      otherwise, error('MATLAB:nj_tslice:Nargin',...
                        'Incorrect number of arguments'); 
    end

    switch nargout
          case 1
            data = myData;
          case 2
            data = myData;
            % get the grid coordinates object associated with the grid
            coordSys = getCoordSys(geogrid); 
            % get coordinate axes        
            grd.lat=coordSys.getLatAxis();
            grd.lon=coordSys.getLonAxis();         

            % vertical coordinates and times
            switch nargin
                case 2
                    grd.z = getVerticalAxis(coordSys);
                    grd.jdmat=getTimes(coordSys);  % get all times.
                case 3
                    grd.z = getVerticalAxis(coordSys, myTime);
                    grd.time=getTimes(coordSys, myTime); 
                case 4
                    grd.z = getVerticalAxis(coordSys, myTime, myLevel);
                    grd.time=getTimes(coordSys, myTime); 
            end 

          otherwise, 
              error('MATLAB:nj_tslice:Nargout',...
                            'Incorrect number of output arguments'); 
    end

    %cleanup only if we know mDataset object is for single use.
    if (~isNcRef)
        nc.close();
    end
catch 
    %gets the last error generated 
    err = lasterror();    
    disp(err.message); 
end


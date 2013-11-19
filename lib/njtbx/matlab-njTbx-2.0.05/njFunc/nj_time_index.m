function [start,stop]=nj_time_index(ncRef,var,start_time,stop_time)
% NJ_TIME_INDEX - Get indexes for CF-compliant time coordinate variable from matlab dates.
%
% Usage:
%   [start,stop]=nj_time_index(ncRef,var,start_time,[stop_time])
% where,
%         ncRef - Reference to netcdf file. It can be either of two
%           a. local file name or a URL  or
%           b. An 'mDataset' matlab object, which is the reference to already
%              open netcdf file.
%              [ncRef=mDataset(uri)]
%         var - variable whose time dimension to get indices from
%         start_time - start time  %matlab datenum 
%         stop_time - end time     % matlab datenum
% returns,           
%   start  - index for specified start_time. '-1' if no index found.
%   stop   - index for specified stop_time. '-1' if no index found.     
%
% e.g,
%   ncRef='http://coast-enviro.er.usgs.gov/cgi-bin/nph-dods/models/test/bora_feb.nc';% NetCDF/OpenDAP/NcML file
%   [start,stop]=nj_time_index(ncRef,'temp','11-Feb-2003 12:00:00','15-Feb-2003 23:00:00')  % start and stop date is UTC/GMT
%
%
%Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (c) 2008
%Mississippi State University.
%
%initialize
%start and stop index. '-1' if time not present.
start = -1;
stop = -1; 
isNcRef=0;

if nargin < 3, help(mfilename), return, end

try     
    if (isa(ncRef, 'mDataset')) %check for JDataset Object
        nc = ncRef;
        isNcRef=1;
    else
        % open CF-compliant NetCDF File as a Common Data Model (CDM) "Grid Dataset"
        nc = mDataset(ncRef);
    end

    % get the mGeoGridVar object
    geoGridVar = getGeoGridVar(nc,var);
    if (isa(geoGridVar, 'mGeoGridVar'))
        myCoordSys = getCoordSys(geoGridVar); % get mGridCoodinates object
        switch nargin
            case 3
                start=getTimeIndex(myCoordSys,start_time);
            case 4
                start=getTimeIndex(myCoordSys,start_time);
                stop=getTimeIndex(myCoordSys,stop_time);
            otherwise, 
                if (~isNcRef)
                    nc.close();
                end
                error('MATLAB:nj_time_index:Nargin',...
                    'Incorrect number of arguments');
        end
    else
        disp(sprintf('MATLAB:nj_time_index:Variable "%s" is not a gridded variable.', var));
        if (~isNcRef)
            nc.close();
        end
        return;
    end
catch
    %gets the last error generated 
    err = lasterror();    
    disp(err.message); 
end 
   


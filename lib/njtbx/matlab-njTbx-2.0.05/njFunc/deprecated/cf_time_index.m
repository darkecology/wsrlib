function [start,stop]=cf_time_index(uri,var,start_time,stop_time)
% CF_TIME_INDEX (DEPRECATED) - Get indexes for time coordinate variable.
%
% Usage:
%   [start,stop]=cf_time_index(uri,var,start_time,[stop_time])
%   DEPRECATED: Use '[start,stop]=nj_time_index(uri,var,start_time,[stop_time])' instead. 
%               'cf_time_index' will be removed in upcoming release of njToolbox.
% where,
%   uri - CF-compliant NetCDF, OpenDAP or NCML file
%         var - variable whose time dimension to get indices from
%         start_time - start time  %matlab datenum
%         stop_time - end time     % matlab datenum
% returns,           
%   start  - index for specified start_time. '-1' if no index found.
%   stop   - index for specified stop_time. '-1' if no index found.     
%
% e.g,
%   uri ='http://stellwagen.er.usgs.gov/cgi-bin/nph-dods/models/adria/roms_sed/bora_feb.nc';% NetCDF/OpenDAP/NcML file
%   [start,stop]=cf_time_index(uri,'temp','11-Feb-2003 12:00:00','15-Feb-2003 23:00:00')  % start and stop date is UTC/GMT
%
%
%Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (c) 2008
%Mississippi State University.
    
if nargin < 3, help(mfilename), return, end

disp('WARNING >>> njFunc/cf_time_index: Function CF_TIME_INDEX has been deprecated and will be removed in future release. Use NJ_TIME_INDEX instead.');
    
switch nargin
    case 3
        [start,stop]=nj_time_index(uri,var,start_time);
    case 4
        [start,stop]=nj_time_index(uri,var,start_time,stop_time);
    otherwise, error('MATLAB:cf_grid_varget:Nargin',...
            'Incorrect number of arguments');
end
end
   


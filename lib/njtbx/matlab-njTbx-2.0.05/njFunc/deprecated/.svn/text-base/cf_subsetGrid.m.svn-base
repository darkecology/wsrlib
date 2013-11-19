function [data,grd]=cf_subsetGrid(ncRef,var,lonLatRange,dn1,dn2)
% CF_SUBSETGRID (DEPRECATED): Subset grid based on lat-lon bounding box and time
%
% Usage:
%   [data, grd]=cf_subsetGrid(uri,var,[lonLatRange], dn1, dn2);
%   DEPRECATED: Use '[data, grd]=nj_subsetGrid(uri,var,[lonLatRange], dn1, dn2)' instead. 
%               'cf_subsetGrid' will be removed in upcoming release of njToolbox.
% where,
%   ncRef - Reference to netcdf file. It can be either of two
%           a. local file name or a URL  or
%           b. An 'mDataset' matlab object, which is the reference to already
%              open netcdf file.
%              [ncRef=mDataset(uri)]
%
%  var - variable to subset
%  lonLatRange - [minLon maxLon minLat maxLat]  % matlab 'axes' function      
%  dn1 - Matlab datenum, datestr or datevec  ex: [1990 4 5 0 0 0] or '5-Apr-1990 00:00'        
%  dn2 - Matlab datenum, datestr or datevec (optional)  
%
% Returns,
%   data - subset data  based on lonlat and time range
%   grd - structure containing lon,lat
%
%  e.g,
%   ncRef='http://www.gri.msstate.edu/rsearch_data/nopp/bora_feb.nc';
%   var = 'temp';
%   lonLatRange = [13.0 16.0 41.0 42.0];   [minlon maxlon minlat maxlat]
%   dn1 = '14-Feb-2003 12:00:00';
%   dn2 = [2003 2 16 14 0 0];
%   [data, grd]=cf_subsetGrid(ncRef,var,lonLatRange,dn1, dn2)     or
%   [data, grd]=cf_subsetGrid(ncRef,var,lonLatRange,dn1)          or
%   [data, grd]=cf_subsetGrid(ncRef,var,lonLatRange)              or
%   [data, grd]=cf_subsetGrid(ncRef,var)                          or
%
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu)  (C) 2008
% Mississippi State University%

if nargin < 2, help(mfilename), return, end   
    
disp('WARNING >>> njFunc/cf_subsetGrid: Function CF_SUBSETGRID has been deprecated and will be removed in future release. Use NJ_SUBSETGRID instead.');
        
switch nargin
    case 2
        [data,grd]=nj_subsetGrid(ncRef,var);
    case 3
        [data,grd]=nj_subsetGrid(ncRef,var,lonLatRange);
    case 4
        [data,grd]=nj_subsetGrid(ncRef,var,lonLatRange,dn1);
    case 5
        [data,grd]=nj_subsetGrid(ncRef,var,lonLatRange,dn1,dn2);

    otherwise, error('MATLAB:cf_subsetGrid:Nargin',...
            'Incorrect number of arguments');
end
    

end

    
 
 
    
   


function [data,grd]=cf_tslice(ncRef,var,iTime, level)
% CF_TSLICE (DEPRECATED)- Get data and coordinates from a CF-compliant file at a specific time step and level
%
% Usage:
%   [data,grd]=cf_tslice(ncRef,var,[iTime], [level]);
%   DEPRECATED: Use '[data,grd]=nj_tslice(ncRef,var,[iTime], [level])' instead. 
%               'cf_tslice' will be removed in upcoming release of njToolbox.
% where,
%   ncRef - Reference to netcdf file. It can be either of two
%           a. local file name or a URL  or
%           b. An 'mDataset' matlab object, which is the reference to already
%              open netcdf file.
%              [ncRef=mDataset(uri)]
%   var - variable to slice
%   iTime - time step to extract data  
%   level - vertical level (if not supplied, volume data is retrieved.)
% returns,          
%   data - data  - matlab array       
%          grd   - structure containing lon,lat,z,jdmat (Matlab datenum)         
% e.g.,
%   uri ='http://coast-enviro.er.usgs.gov/cgi-bin/nph-dods/models/adria/roms_sed/bora_feb.nc';% NetCDF/OpenDAP/NcML file
%   [data,grd]=cf_tslice(uri,'temp',2, 14) - Retrieve data from level 14 at time step 2
%   [data,grd]=cf_tslice(uri,'temp',2) - Retrieve 3D data at time step 2 
%   [data,grd]=cf_tslice(uri,'h') - Retrieve 2D non time dependent array 
%
%
% rsignel1@usgs.gov
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu)  (C) 2008
% Mississippi State University


if nargin < 2, help(mfilename), return, end

disp('WARNING >>> njFunc/cf_tslice: Function CF_TSLICE has been deprecated and will be removed in future release. Use NJ_TSLICE instead.')
       
switch nargin
    case 2
        [data,grd]=nj_tslice(ncRef,var);
    case 3
        [data,grd]=nj_tslice(ncRef,var,iTime);
    case 4
        [data,grd]=nj_tslice(ncRef,var,iTime, level);
    otherwise, error('MATLAB:cf_tslice:Nargin',...
            'Incorrect number of arguments');
end

end


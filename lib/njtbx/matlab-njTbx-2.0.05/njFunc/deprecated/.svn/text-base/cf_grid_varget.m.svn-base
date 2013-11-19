function [data, grid]=cf_grid_varget(ncRef,var,start, count, stride)
% CF_GRID_VARGET (DEPRECATED) - get variable data and associated grid coordinates from local NetCDF file, NetCDF URL or OpenDAP URL
%
% Usage:    
%   [data, grid]=cf_grid_varget(file,var,start,count,stride);
%   DEPRECATED: Use [data, grid]=nj_grid_varget(file,var,start,count,stride) instead. 
%               'cf_grid_varget' will be removed in upcoming release of njToolbox.
% where,
%   ncRef - Reference to netcdf file. It can be either of two
%           a. local file name or a URL  or
%           b. An 'mDataset' matlab object, which is the reference to already
%              open netcdf file.
%              [ncRef=mDataset(uri)]
%   var  =  variable to extract          
%           start = A 1-based array specifying the position in the file to begin reading or corner of a
%                   hyperslab e.g [1 2 1]. Specify 'inf' for last index.
%                   The values specified must not exceed the size of any
%                   dimension of the data set.
%           count = A 1-based array specifying the length of each dimension to read. e.g [6 10 inf]. 
%                   Specify 'inf' to get all the values from start index.
%           stride = A 1-based array specifying the interval between the
%                    values to read. e.g [1 2 2] 
%        
%     Any of these URI types will work:
%     Local NetCDF:  ncRef='bora_feb.nc';
%     Remote NetCDF: ncRef='http://coast-enviro.er.usgs.gov/models/test/bora_feb.nc';
%     OpenDAP:       ncRef='http://coast-enviro.er.usgs.gov/cgi-bin/nph-dods/models/test/bora_feb.nc';
%     Local NcML:    ncRef='bora_feb.ncml';
%     Remote NcML:   ncRef='http://coast-enviro.er.usgs.gov/models/test/bora_feb.ncml';
%
%   Any of these syntaxes will return the surface temperature values
%   from the first time step: Assuming Array shape is [8,20,60,160]        
%           
%     Using 'start' 'count' 'stride' arrays to specify indexing%
%     [data, grid]=cf_grid_varget(ncRef,'temp',[1 1 1 1],[1 1 30 inf],[1 1 2 2]); % get surface temp from first time step 
%          
%     The following will return the entire longitude variable
%     t=cf_grid_varget(ncRef,'lon_rho');  % get all the lon values
%
%
%
%Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (c) 2008
%Mississippi State University.

if nargin < 2, help(mfilename), return, end

disp('WARNING >>> njFunc/cf_grid_varget: Function CF_GRID_VARGET has been deprecated and will be removed in future release. Use NJ_GRID_VARGET instead.')

switch nargin
    case 2
        [data, grid]=nj_grid_varget(ncRef,var);
    case 4
        [data, grid]=nj_grid_varget(ncRef,var, start, count);
    case 5
        [data, grid]=nj_grid_varget(ncRef,var, start, count, stride);
    otherwise, error('MATLAB:cf_grid_varget:Nargin',...
            'Incorrect number of arguments');
end

end

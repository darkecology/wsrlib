function result=cf_info(ncRef)
%CF_INFO (DEPRECATED)- Get detail info about dataset.
% 
% Usage:
%   info=cf_info(ncRef); 
%   DEPRECATED: Use 'info=nj_info(ncRef)' instead. 
%               'cf_info' will be removed in upcoming release of njToolbox.
% where,
%   ncRef - Reference to netcdf file. It can be either of two
%           a. local file name or a URL (OpenDAP, ncml) or
%           b. An 'mDataset' matlab object, which is the reference to already
%              open netcdf file.
%              [ncRef=mDataset(uri)]
% returns,      
%   info - text info
%
% e.g.:
%  ncRef='http://coast-enviro.er.usgs.gov/cgi-bin/nph-dods/models/test/bora_feb.nc';
%  info=cf_info(ncRef);
%
%
%Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (c) 2008
%Mississippi State University.

result = [];
if nargin < 1, help(mfilename), return, end

disp('WARNING >>> njFunc/cf_info: Function CF_INFO has been deprecated and will be removed in future release. Use NJ_INFO instead.')

switch nargin
    case 1
        result=nj_info(ncRef);
    otherwise, error('MATLAB:cf_info:Nargin',...
            'Incorrect number of arguments');
end
    




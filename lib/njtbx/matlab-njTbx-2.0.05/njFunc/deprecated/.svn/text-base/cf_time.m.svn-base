function result=cf_time(ncRef,var,timeIndex)
% CF_TIME (DEPRECATED)- Get entire time vector for variable 'var' from any CF-compliant file
%         NOTE: Time coordinate variable should be CF-compliant.
%
% Usage:
%   result=cf_time(ncRef,var);   - all times
%   result=cf_time(ncRef,var,timeIndex); - time for particular timestep
%   DEPRECATED: Use result=nj_times(ncRef,var);   - all times
%               result=nj_times(ncRef,var,timeIndex); - time for particular timestep instead. 
%               'cf_time' will be removed in upcoming release of njToolbox.
% where,
%   ncRef - Reference to netcdf file. It can be either of two
%           a. local file name or a URL  or
%           b. An 'mDataset' matlab object, which is the reference to already
%              open netcdf file.
%              [ncRef=mDataset(uri)]
%   var - variable name
%   timeindex - time step
% Returns,
%   result - vector of times in DATENUM format
%
% e.g,
%  Gridded dataset:
%       uri='http://coast-enviro.er.usgs.gov/cgi-bin/nph-dods/models/test/bora_feb.nc';
%       var='temp';
%  Non-Gridded dataset: (But has CF-compliant time coordinate variable)
%       uri='http://www.gri.msstate.edu/rsearch_data/nopp/non-gridded/adcirc/adc.050913.fort.64.nc';
%       var='ubar';
%  
%
% Richard Signell (rsignell@usgs.gov)
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu)  (C) 2008
% Mississippi State University

if nargin < 2, help(mfilename), return, end

disp('WARNING >>> njFunc/cf_time: Function CF_TIME has been deprecated and will be removed in future release. Use NJ_TIMES instead.')

switch nargin
    case 2    %variable attributes
        result = nj_times(ncRef,var);  %all times
    case 3    % get specific time step
        result = nj_times(ncRef,var,timeIndex);
    otherwise, error('MATLAB:cf_time:Nargin',...
            'Incorrect number of arguments');
end
       
end




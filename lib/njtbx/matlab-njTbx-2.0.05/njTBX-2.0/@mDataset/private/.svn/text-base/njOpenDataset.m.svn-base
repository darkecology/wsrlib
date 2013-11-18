function result=njOpenDataset(ncURI)
% mDataset/njOpenDataset:  Opens a local NetCDF file, NetCDF URL or OpenDAP URL
% and returns a netcdf_java dataset object. 
%
% 
% Sachin Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

import msstate.cstm.data.JDataset


if nargin < 1 && nargout < 1
    disp('Check input and output arguments!')
    help njOpenDataset;
    return
end

% open a ncDataset 
ncData = JDataset(ncURI);

if nargout > 0 
    result = ncData;
end

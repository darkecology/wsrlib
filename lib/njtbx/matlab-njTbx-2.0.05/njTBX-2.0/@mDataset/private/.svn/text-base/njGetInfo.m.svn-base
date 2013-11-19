function [nGrid nDim nVar]=njGetInfo(NCid)
% njGetInfo: finds information about the netcdf data

%   Usage:    u=njGetInfo(NCid);
%   where:  NCid = msstate.cstm.data.JDataset object.
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

import msstate.cstm.data.JDataset


if nargin < 1 && nargout < 1
    disp('Check input and output arguments!')  % Require class object here to deal with different scenarios.
    help njDataInfo;
    return
end


% Get number of grids
nGrid = size(NCid.getGridDataset().getGrids());
%number of dimensions and variables
ncdataset = NCid.getJNetcdfDataset().getNetcdfDataset();
nDim = size(ncdataset.getDimensions());
nVar = size(ncdataset.getVariables());

end
    


function [ nGrid, nVar, nDim] = getDataInfo( mDatasetObj )
%private: mDataset/getDataInfo - Retrieves  general information
% about number of grids, number of variables and dimensions.
%
%   Method Usage:   
%       [ nGrid, nVar, nDim] = getDataInfo( mDatasetObj )
%   where,
%       mDatasetObj - mDataset object.
%   returns,
%       nGrids - Number of gridded variables within datasets
%       nVar - Number of total variables (gridded & non-gridded)
%       nDim - Number of dimensions
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
nGrid=[];
nVar=[];
nDim=[];

if (isa(mDatasetObj, 'mDataset')) %check for mDataset Object
    theStruct = struct(mDatasetObj);
    nGrid=theStruct.mynGrid; 
    nVar=theStruct.mynVar;
    nDim=theStruct.mynDim;   
end

end


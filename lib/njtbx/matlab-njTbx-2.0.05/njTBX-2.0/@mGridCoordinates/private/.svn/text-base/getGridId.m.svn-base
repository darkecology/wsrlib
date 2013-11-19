function [ theGridId ] = getGridId(mGridCoordinatesObj)
%private: mGridCoordinates/getGridId - Retrieves  the msstate.cstm.data.grid.JGeoGridDataset object .                                  
%
%   Method Usage:   
%        theGridId=getGridId(mGridCoordinatesObj);
%   where,
%     mGridCoordinatesObj - mGridCoordinates object.
%   returns,
%      theGridId  - java object of class 'msstate.cstm.data.grid.JGeoGridDataset'
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
theGridId=[];


if (isa(mGridCoordinatesObj, 'mGridCoordinates')) %check for mGridCoordinates Object
    theStruct = struct(mGridCoordinatesObj);
    theGridId=theStruct.myGridID; 
end

end

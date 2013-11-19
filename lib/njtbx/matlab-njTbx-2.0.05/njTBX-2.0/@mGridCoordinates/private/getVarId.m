function [ theVarId ] = getVarId(mGridCoordinatesObj)
%private: mGridCoordinates/getVarId - Retrieves  the msstate.cstm.data.JVariable object .                                  
%
%   Method Usage:   
%        theVarId=getVarId(mGridCoordinatesObj);
%   where,
%      mGridCoordinatesObj - mGridCoordinates object.
%   returns,
%      theVarId  - java object of class 'msstate.cstm.data.JVariable'
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
theVarId=[];


if (isa(mGridCoordinatesObj, 'mGridCoordinates')) %check for mGeoGridVar Object
    theStruct = struct(mGeoGridVarObj);
    theVarId =theStruct.myVarID; 
end

end

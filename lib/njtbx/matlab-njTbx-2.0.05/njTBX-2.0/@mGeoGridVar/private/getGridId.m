function [ theGridId ] = getGridId( mGeoGridVarObj)
%private: mGeoGridVar/getGridId - Retrieves  the msstate.cstm.data.grid.JGeoGridDataset object .                                  
%
%   Method Usage:   
%        theGridId=getGridId( mGeoGridVarObj);
%   where,
%      mGeoGridVarObj - mGeoGridVar object.
%   returns,
%      theGridId  - java object of class 'msstate.cstm.data.grid.JGeoGridDataset'
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
theGridId=[];


if (isa(mGeoGridVarObj, 'mGeoGridVar')) %check for mGeoGridVar Object
    theStruct = struct(mGeoGridVarObj);
    theGridId=theStruct.myGridID; 
end

end

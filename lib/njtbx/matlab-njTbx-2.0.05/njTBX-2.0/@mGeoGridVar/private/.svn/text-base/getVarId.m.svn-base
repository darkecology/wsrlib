function [ theVarId ] = getVarId( mGeoGridVarObj)
%private: mGeoGridVar/getVarId - Retrieves  the msstate.cstm.data.JVariable object .                                  
%
%   Method Usage:   
%        theVarId=getVarId( mGeoGridVarObj);
%   where,
%      mGeoGridVarObj - mGeoGridVar object.
%   returns,
%      theVarId  - java object of class 'msstate.cstm.data.JVariable'
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
theVarId=[];


if (isa(mGeoGridVarObj, 'mGeoGridVar')) %check for mGeoGridVar Object
    theStruct = struct(mGeoGridVarObj);
    theVarId =theStruct.myVarID; 
end

end

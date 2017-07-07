function [ theNCid ] = getNCid(mGeoGridVarObj)
%private: mGeoGridVar/getNCid - Retrieves  the msstate.cstm.data.JDataset object.                                  
%
%   Method Usage:   
%       theNCid=getNCid(mGeoGridVarObj);
%   where,
%       mGeoGridVarObj - mGeoGridVar object.
%   returns,
%       result - java object of class 'msstate.cstm.data.JDataset'
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
theNCid=[];


if (isa(mGeoGridVarObj, 'mGeoGridVar')) %check for mGeoGridVar Object
    theStruct = struct(mGeoGridVarObj);
    theNCid=theStruct.myNCid; 
end

end

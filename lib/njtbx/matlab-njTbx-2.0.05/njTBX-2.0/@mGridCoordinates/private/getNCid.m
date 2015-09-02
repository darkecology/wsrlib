function [ theNCid ] = getNCid(mGridCoordinatesObj)
%private: mGridCoordinates/getNCid - Retrieves  the msstate.cstm.data.JDataset object.                                  
%
%   Method Usage:   
%       theNCid=getNCid(mGridCoordinatesObj);
%   where,
%       mGridCoordinatesObj - mGridCoordinates object.
%   returns,
%       result - java object of class 'msstate.cstm.data.JDataset'
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
theNCid=[];


if (isa(mGridCoordinatesObj, 'mGridCoordinates')) %check for mGridCoordinates Object
    theStruct = struct(mGridCoordinatesObj);
    theNCid=theStruct.myNCid; 
end

end

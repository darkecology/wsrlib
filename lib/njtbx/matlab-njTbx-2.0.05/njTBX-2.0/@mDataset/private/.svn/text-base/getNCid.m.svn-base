function [ theNCid ] = getNCid( mDatasetObj)
%private: mDataset/getNCid - Retrieves  the msstate.cstm.data.JDataset object.                                  
%
%   Method Usage:   
%       theNCid=getNCid(mDatasetObj);
%   where,
%       mDatasetObj - mDataset object.
%   returns,
%       result - java object of class 'msstate.cstm.data.JDataset'
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
theNCid=[];


if (isa(mDatasetObj, 'mDataset')) %check for mDataset Object
    theStruct = struct(mDatasetObj);
    theNCid=theStruct.myNCid; 
end

end

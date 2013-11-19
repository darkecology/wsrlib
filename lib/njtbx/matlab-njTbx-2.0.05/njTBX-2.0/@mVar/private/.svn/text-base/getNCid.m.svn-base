function [ theNCid ] = getNCid(mVarObj)
%private: mVar/getNCid - Retrieves  the msstate.cstm.data.JDataset object.                                  
%
%   Method Usage:   
%       theNCid=getNCid(mVar);
%   where,
%       mVar - mVar object.
%   returns,
%       result - java object of class 'msstate.cstm.data.JDataset'
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
theNCid=[];


if (isa(mVarObj, 'mVar')) %check for mVar Object
    theStruct = struct(mVarObj);
    theNCid=theStruct.myNCid; 
end

end

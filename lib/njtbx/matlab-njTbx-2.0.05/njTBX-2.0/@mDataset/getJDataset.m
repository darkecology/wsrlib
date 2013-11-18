function result = getJDataset(mDatasetObj)
%mDataset/getJDataset - Retrieves  the msstate.cstm.data.JDataset object.
%                      A high level java dataset object. Can be used to directly access netcdf-java classes.                
%
%   Method Usage:   
%       result=getJDataset(mDatasetObj);
%   where,
%       mDatasetObj - mDataset object.
%   returns,
%       result - java object of class 'msstate.cstm.data.JDataset'
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
result=[];

myNCid = getNCid(mDatasetObj); 

if (isa(myNCid, 'msstate.cstm.data.JDataset')) %check for JDataset Object
    result=myNCid; 
end


end

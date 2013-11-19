function close(mDatasetObj)
% mDataset/close -- Close the data file associated with a 'mDataset' object.
% 
% Method Usage:
%   close(mDatasetObj)
% where,
%   mDatasetObj - mDataset object  
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end

myNCid = getNCid(mDatasetObj);

if (isa(myNCid, 'msstate.cstm.data.JDataset')) 
    myNCid.close();    
 end

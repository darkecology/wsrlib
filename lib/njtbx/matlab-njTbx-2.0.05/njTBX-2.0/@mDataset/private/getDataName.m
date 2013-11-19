function dataName = getDataName( mDatasetObj )
%private: mDataset/getDataName - Retrieves  filename with absolute path/url
%
%   Method Usage:   
%       dataName = getDataName( mDatasetObj )
%   where,
%       mDatasetObj - mDataset object.
%   returns,
%       dataName - dataset URL 
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
dataName=[];

if (isa(mDatasetObj, 'mDataset')) %check for mDataset Object
    theStruct = struct(mDatasetObj);
    dataName=theStruct.myName;       
end

end


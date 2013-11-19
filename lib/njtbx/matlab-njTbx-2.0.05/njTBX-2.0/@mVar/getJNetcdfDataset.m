function result = getJNetcdfDataset(mVarObj)
%mVar/getJNetcdfDataset - Retrieves  the msstate.cstm.data.JNetcdfDataset object.
%                      A high level java Netcdfdataset object. Can be used to directly access netcdf-java classes.                
%
%   Method Usage:   
%       result= getJNetcdfDataset(mVarObj);
%   where,
%       mVarObj - mVar object.
%   returns,
%       result - java object of class 'msstate.cstm.data.JNetcdfDataset'
%

% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
result=[];

myNCid = getNCid(mVarObj); 

if (isa(myNCid, 'msstate.cstm.data.JDataset')) %check for JDataset Object    
    result=myNCid.getJNetcdfDataset(); 
end


end

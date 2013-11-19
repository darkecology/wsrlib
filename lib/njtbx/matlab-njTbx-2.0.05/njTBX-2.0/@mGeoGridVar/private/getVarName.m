function varName = getVarName(mGeoGridVarObj)
%private: mGeoGridVarObj/getVarName - Retrieves  variable name
%
%   Method Usage:   
%       varName = getVarName(mGeoGridVarObj)
%   where,
%       mGeoGridVarObj - mGeoGridVar object.
%   returns,
%       varName - variable name 
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
varName=[];

if (isa(mGeoGridVarObj, 'mGeoGridVar')) %check for mGeoGridVar Object
    theStruct = struct(mGeoGridVarObj);
    varName=theStruct.varName;       
end

end


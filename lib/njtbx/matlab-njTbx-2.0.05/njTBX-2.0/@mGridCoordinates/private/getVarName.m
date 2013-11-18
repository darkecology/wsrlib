function varName = getVarName(mGridCoordinatesObj)
%private: mGridCoordinatesObj/getVarName - Retrieves  variable name
%
%   Method Usage:   
%       varName = getVarName(mGridCoordinatesObj)
%   where,
%       mGridCoordinatesObj - mGridCoordinates object.
%   returns,
%       varName - variable name 
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
varName=[];

if (isa(mGridCoordinatesObj, 'mGridCoordinates')) %check for mGeoGridVar Object
    theStruct = struct(mGridCoordinatesObj);
    varName=theStruct.varName;       
end

end


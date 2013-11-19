function result = getGeoGridVar(mDatasetObj,varName)
%mDataset/getGeoGridVar - Get variable into a GeoGrid if it has a Georeferencing coordinate system.
%                         Returns a mGeoGrid object.
% Method Usage:
%   result=getGeoGridVar(mDatasetObj,varName)
% where,
%   mDatasetObj - mDataset object 
%   varName - variable name, e.g. 'temp' (gridded variable only)
% returns,
%   result - matlab object of class 'mGeoGridVar'
%
% See also getVar
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 2, help(mfilename), return, end

if nargout > 0
    result=[];
end

switch nargin   
    case 2
        result=mGeoGridVar(varName, mDatasetObj);
    otherwise,
        warning('MATLAB:mDataset:getGeoGridVar', ...
        'Illegal Syntax');        
end


end

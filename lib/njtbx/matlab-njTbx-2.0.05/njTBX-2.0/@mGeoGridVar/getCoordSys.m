function result = getCoordSys(mGeoGridVarObj)
%mGeoGridVar/getCoordSys - Get the Grid Coordinate System associated with the referenced GeoGrid
%                       It returns a 'Grid Coordinates' object containing
%                       coordinate and time axes.
%
% Method Usage:
%       result=getCoordSys(mGeoGridVarObj)
% where,
%       mGeoGridVarObj - mGeoGridVar object
% returns,
%       result - matlab object of class 'mGridCoordinates'
% 
% See also mGridCoordinates 
%
%
%Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (c) 2008
%Mississippi State University.

result=[];
if nargin < 1, help(mfilename), return, end

switch nargin   
    case 1
        result=mGridCoordinates(mGeoGridVarObj);
    otherwise,
        error('MATLAB:mGeoGridVarObj:getCoordSys', ...
        'Incorrect number of arguments');        
end


end
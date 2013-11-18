function result = getShape(mGeoGridVarObj)
%mGeoGridVar/getShape - get grid variable shape
%  
% Method Usage:  
%       shape=getShape(mGeoGridVarObj) or
%       shape=mGeoGridVarObj.getShape;   
% where,  
%       mGeoGridVarObj- mGeoGridVar object. 
% returns,
%       shape - matlab array 
%
% See also mVar/getShape
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu)  (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
myGridId = getGridId(mGeoGridVarObj);
if (isa(myGridId.getGeoGrid, 'ucar.nc2.dt.grid.GeoGrid')) %check for GeoGrid Object
    result=double(mGeoGridVarObj.myShape);
else
    result=[];
end

end

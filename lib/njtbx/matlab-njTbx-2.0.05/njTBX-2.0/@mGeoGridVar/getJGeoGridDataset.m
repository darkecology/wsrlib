function result = getJGeoGridDataset(mGeoGridVarObj)
%mGeoGridVar/getJGeoGridDataset - Retrieves  the msstate.cstm.data.grid.JGeoGridDataset object.
%                      A high level java GeoGriddataset object. Can be used to directly access netcdf-java classes.                
%
%   Method Usage:   
%       result=getJGeoGridDataset(mGeoGridVarObj);
%   where,
%       mGeoGridVarObj - mGeoGridVar object.
%   returns,
%       result - java object of class 'msstate.cstm.data.grid.JGeoGridDataset'
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
result=[];

myGridId = getGridId(mGeoGridVarObj); 

if (isa(myGridId, 'msstate.cstm.data.grid.JGeoGridDataset')) %check for JGeoGridDataset Object
    result=myGridId; 
end


end

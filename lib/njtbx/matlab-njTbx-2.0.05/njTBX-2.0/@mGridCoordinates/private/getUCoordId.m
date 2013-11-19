function [ theUCoordId ] = getUCoordId(mGridCoordinatesObj)
%private: mGridCoordinates/getUCoordId - Retrieves  the ucar.nc2.dt.grid.GridCoordinateSystem object .                                  
%
%   Method Usage:   
%        theUCoordId =getUCoordId(mGridCoordinatesObj);
%   where,
%     mGridCoordinatesObj - mGridCoordinates object.
%   returns,
%      theUCoordId   - java object of class 'ucar.nc2.dt.grid.GridCoordinateSystem'
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
theUCoordId=[];


if (isa(mGridCoordinatesObj, 'mGridCoordinates')) %check for mGridCoordinates Object
    theStruct = struct(mGridCoordinatesObj);
    theUCoordId=theStruct.uCoordID; 
end

end

function [ theCoordId ] = getCoordId(mGridCoordinatesObj)
%private: mGridCoordinates/getCoordId - Retrieves  the msstate.cstm.data.grid.JGridCoordinateData object .                                  
%
%   Method Usage:   
%        theCoordId =getCoordId(mGridCoordinatesObj);
%   where,
%     mGridCoordinatesObj - mGridCoordinates object.
%   returns,
%      theCoordId   - java object of class 'msstate.cstm.data.grid.JGridCoordinateData'
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
theCoordId=[];


if (isa(mGridCoordinatesObj, 'mGridCoordinates')) %check for mGridCoordinates Object
    theStruct = struct(mGridCoordinatesObj);
    theCoordId=theStruct.myCoordID; 
end

end

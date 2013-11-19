function result = hasDateTime(mGridCoordinatesObj)
%private: mGridCoordinates/hasDateTime- Does data has date time or not.                                  
%
%   Method Usage:   
%        result =hasDateTime(mGridCoordinatesObj);
%   where,
%     mGridCoordinatesObj - mGridCoordinates object.
%   returns,
%     result   - '1' = has datetime, '0'=no datetime 
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
result=0;


if (isa(mGridCoordinatesObj, 'mGridCoordinates')) %check for mGridCoordinates Object
    theStruct = struct(mGridCoordinatesObj);
    result=theStruct.hasDateTime; 
end

end

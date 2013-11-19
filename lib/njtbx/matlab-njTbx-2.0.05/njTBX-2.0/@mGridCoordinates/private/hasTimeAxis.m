function result = hasTimeAxis(mGridCoordinatesObj)
%private: mGridCoordinates/hasTimeAxis- Does data has time axis or not.                                  
%
%   Method Usage:   
%        result =hasTimeAxis(mGridCoordinatesObj);
%   where,
%     mGridCoordinatesObj - mGridCoordinates object.
%   returns,
%     result   - '1' = has time axis, '0'=no time axis
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
result=0;


if (isa(mGridCoordinatesObj, 'mGridCoordinates')) %check for mGridCoordinates Object
    theStruct = struct(mGridCoordinatesObj);
    result=theStruct.hasTimeAxis; 
end

end

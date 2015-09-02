function result = hasVertAxis(mGridCoordinatesObj)
%private: mGridCoordinates/hasVertAxis- Does data has vertical axis or not.                                  
%
%   Method Usage:   
%        result =hasVertAxis(mGridCoordinatesObj);
%   where,
%     mGridCoordinatesObj - mGridCoordinates object.
%   returns,
%     result   - '1' = has vertical axis, '0'=no vertical axis
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
result=0;


if (isa(mGridCoordinatesObj, 'mGridCoordinates')) %check for mGridCoordinates Object
    theStruct = struct(mGridCoordinatesObj);
    result=theStruct.hasVertAxis; 
end

end

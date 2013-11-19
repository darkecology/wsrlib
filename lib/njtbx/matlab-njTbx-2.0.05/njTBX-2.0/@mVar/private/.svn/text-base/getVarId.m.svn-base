function theVarId = getVarId(mVarObj)
%private: mVarObj/getVarId - Retrieves  the matlab variable object.                                  
%
%   Method Usage:   
%       theVarId=getVarId( mVarObj);
%   where,
%       mVarObj- mVarObj object.
%   returns,
%       theVarId - matlab variable object.
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end
theVarId=[];

if (isa(mVarObj, 'mVar')) %check for mVar Object
    theStruct = struct(mVarObj);
    theVarId=theStruct.myVarID; 
end

end

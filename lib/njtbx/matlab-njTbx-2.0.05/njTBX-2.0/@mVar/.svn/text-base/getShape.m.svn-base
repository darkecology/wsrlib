function result = getShape(mVarObj)
%mVar/getShape - get variable shape
%   
% Method Usage:  
%       shape=getShape(mVarObj) or
%       shape=mVarObj.getShape;   
% where,  
%       mVarObj - mVar object. 
% returns,
%       shape - matlab array 
%
% See also mGeoGridVar/getShape
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu)  (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end

myVarId = getVarId(mVarObj);

if (isa(myVarId, 'msstate.cstm.data.JVariable')) %check for JVariable Object
    result=double(mVarObj.myShape);
else
    result=[];
end

end

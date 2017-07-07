function result = getVar(mDatasetObj, varName)
%mDataset/getVar - Retrieves a matlab variable object.
%                  Data variable can be gridded or non-gridded.
% Method Usage:
%       result=getVariable(mDatasetObj,varName)
%       Variable can also be retrieved using matlab's subscripted reference to objects. 
%       result=mDatasetObj{'varName'} 
%          
% where,
%       mDatasetObj - mDataset object 
%       varName - variable name, e.g. 'temp' (gridded or non-gridded)
% returns,
%       result - matlab object of class 'mVar'
%
% See also getGeoGridVar
%
%
%Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (c) 2008
%Mississippi State University.

if nargin < 2, help(mfilename), return, end

if nargout > 0
    result=[];
end

switch nargin   
    case 2
        result=mVar(mDatasetObj,varName);
    otherwise,
        warning('MATLAB:mDataset:getVariable', ...
        'Illegal Syntax');        
end

end

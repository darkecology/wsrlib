function result = isGridded(mVarObj)
%mVar/isGridded  - Is variable a grid variable ?
%   
% Method Usage:  
%       result=isGridded(mVarObj);
% where,  
%       mVarObj - mVar object.
% returns,
%        result -  1=gridded, 0=non-gridded
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu)  (C) 2008
% Mississippi State University

result = [];
if nargin < 1, help(mfilename), return, end

switch nargin
      case 1
          if(isa(mVarObj,'mVar')) 
            result = mVarObj.isGrid;
          else
             error('MATLAB:mVar:isGridded',...
                   'Invalid mVar Object, "%s".', class(mVarObj)) 
          end
        
        otherwise, 
            error('MATLAB:mVar:isGridded:Nargin',...
                        'Incorrect number of arguments'); 
end   





end

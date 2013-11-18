function result = subsref(mVarObj, theStruct)

% mVar/subsref -- Overloaded "{}", "()", and "." operators.
%  subsref(this, theStruct) processes subscripting references
%   of this, a "mVar" object.

% 
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 1, help(mfilename), return, end

result = [];

if (~isa(mVarObj, 'mVar'))    
    error('MATLAB:mVar:subsref',...
       'Invalid Object "%s".', class(mVarObj));                    
end

%check for empty index
if length(theStruct) < 1
	result = mVarObj;	
	return
end

s = theStruct;
theType = s(1).type;
theSubs = s(1).subs;
s(1) = [];

% the sub can be a cell array ..but we need the value.

if isa(theSubs, 'char')  
   mySub = theSubs;
end
myShape =  getShape(mVarObj);

switch theType
    % DOT reference
      case '.'
        switch mySub
            case 'isGridded'                
                result = isGridded(mVarObj);                
            case 'getAttributes'            
                result = getAttributes(mVarObj);            
            case 'getShape'            
                result = myShape;
            case 'getTimes'            
                result = getTimes(mVarObj);
            otherwise
                 result = getAttributes(mVarObj,theSubs);  %need a better logic here
                if isempty(result)
                    error(['??? Reference to non-existent field ' mySub '.']);
                end 
                
        end  
    %cell reference
      case '()'        
            if ~isempty(myShape)                 
                [start count stride] = parseIndices(theSubs, myShape); 
                result=getData(mVarObj,start,count,stride);                
            else                            
                disp('No dimensions associated with variable');
            end     
       case '{}'  
              %possiblity of use of '{}' on non-gridded data to access
              %grid.
              result=[];                                        
              disp('No grid associated with variable');
              
    otherwise,
        warning('MATLAB:subsref', ...
                         'Invalid index type, "%s".', theType)
end
end
   




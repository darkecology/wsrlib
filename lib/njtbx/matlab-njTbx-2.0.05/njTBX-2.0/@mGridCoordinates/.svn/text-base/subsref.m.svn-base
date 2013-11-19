function result = subsref(mGridCoordinatesObj, theStruct)

% mGridCoordinates/subsref -- Overloaded "{}", "()", and "." operators.
%  subsref(this, theStruct) processes subscripting references
%   of this, a "mGridCoordinates" object.

% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 2, help(mfilename), return, end

result = [];

if (~isa(mGridCoordinatesObj, 'mGridCoordinates'))    
    error('MATLAB:mGridCoordinates:subsref',...
       'Invalid Object "%s".', class(mGridCoordinatesObj));                    
end

%check for empty index
if length(theStruct) < 1
	result = mGridCoordinatesObj;	
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

    switch theType
        % DOT reference
          case '.'
            switch mySub            
                case 'getLatAxis'            
                    result = getLatAxis(mGridCoordinatesObj);            
                case 'getLonAxis'           
                    result = getLonAxis(mGridCoordinatesObj); 
                case 'getTimes'
                    result = getTimes(mGridCoordinatesObj);
                case 'getVerticalAxis'
                    result = getVerticalAxis(mGridCoordinatesObj);
                otherwise
                     error('Method "%s" not accessible with "dot" reference.', mySub);
            end  

        otherwise,
            warning('MATLAB:mGridCoordinates:subsref', ...
                             'Invalid index type, "%s".', theType)
    end
end
   




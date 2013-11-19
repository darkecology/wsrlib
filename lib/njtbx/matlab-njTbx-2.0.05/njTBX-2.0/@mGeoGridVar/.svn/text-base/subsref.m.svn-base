function result = subsref(mGeoGridVarObj, theStruct)

% mGeoGridVar/subsref -- Overloaded "{}", "()", and "." operators.
%  subsref(this, theStruct) processes subscripting references
%   of this, a "mGeoGridVar" object.

% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

if nargin < 2, help(mfilename), return, end

result = [];
if (~isa(mGeoGridVarObj, 'mGeoGridVar'))    
    error('MATLAB:mGeoGridVar:subsref',...
       'Invalid Object "%s".', class(mGeoGridVarObj));                    
end
%check for empty index
if length(theStruct) < 1
	result = mGeoGridVarObj;	
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
myShape =  getShape(mGeoGridVarObj);

    switch theType
        % DOT reference
          case '.'
            switch mySub            
                case 'getAttributes'            
                    result = getAttributes(mGeoGridVarObj);           
                case 'getShape'            
                    result = myShape;
                case 'getCoordSys'            
                    result = getCoordSys(mGeoGridVarObj); 
                case 'data'
                    result = getData(mGeoGridVarObj);
                case 'grid'
                    result = getGrid(mGeoGridVarObj);
                otherwise
                    result = getAttributes(mGeoGridVarObj,theSubs);  %need a better logic here
                    if isempty(result)
                        error(['??? Reference to non-existent field ' mySub '.']);
                    end                     
            end  
        %cell reference
          case '()'              
               if ~isempty(myShape)
                    result = createGridObj(theSubs, myShape);
                    structSize = length(s);
                    if ~isempty(result) && structSize > 0  % user either needs data or grid
                        result = subsref(result, s); %make mGeoGridVar/subsref call                        
                    end
               else
                    result = [];               
                    disp('No dimensions associated with variable');
               end
               
             case '{}'              
               if ~isempty(myShape)
                    gObj = createGridObj(theSubs, myShape);
                    result = getGrid(gObj);                   
                else
                    result = [];               
                    disp('No dimensions associated with variable');
               end    
              
          otherwise,
            warning('MATLAB:subsref', ...
                             'Invalid index type, "%s".', theType)
    end
    
     %create mGeoGridVar obj.
    function gVarObj=createGridObj(theSubs, myShape)
        [start count stride] = parseIndices(theSubs, myShape); 
        subGridObj=njSubsetGrid(mGeoGridVarObj,start,count,stride);        
        %create a substruct
        subGeoGridVarStruct.myNCid = getNCid(mGeoGridVarObj); 
        subGeoGridVarStruct.myGridID = subGridObj;  %subset JGeoGridDataset object
        subGeoGridVarStruct.myVarID = getVarId(mGeoGridVarObj);
        subGeoGridVarStruct.varName = getVarName(mGeoGridVarObj);
        subGeoGridVarStruct.myShape = double(transpose(subGridObj.getGeoGrid.getShape));

        gVarObj=class(subGeoGridVarStruct,'mGeoGridVar');  %create mGeoGridVar object    
    end
end
   




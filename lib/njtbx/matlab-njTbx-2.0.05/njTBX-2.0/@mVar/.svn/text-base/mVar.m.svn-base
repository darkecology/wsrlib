function result = mVar(mDatasetObj, varName)
%mVar class constructor -  creates a netcdf variable (non-gridded/gridded) object
%
%   mvar=mVar(mDatasetObj, varName) reads the variable and create a variable object.
%   where,
%       varName - variable name, e.g. 'temp' (gridded or non-gridded)
%       mDatasetObj - mDataset object
%   returns,
%       mvar: This will create 'mvar' object of class 'mVar'.
%          In order to know the methods available for data access under
%          class 'mVar', use matlab 'builtin' function
%          'methods(className).
%          i.e. methods(mvar)      
%
%    Methods for class mVar:          
%
%           a. getAttributes(mvar,attName) - get attribute(s) associated with the variable 
%              
%           b. getData(mvar, start, count, stride) - get data from variable           
%              data=mvar(i,j, ...) - get data  using matlab subscripting reference.
%           
%           c. getTimes(mvar, timeIndex) - Get time(s) in DATENUM format. 
%                    
%           d. getShape(mvar) - get variable shape           
%
%           e. isGridded(mvar) - Is variable a grid variable ? 
%              
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

    %arg check
    if nargin < 2 && nargout < 1
        disp('check input and output arguments!');
        help mVar;
        return;
    end

    if nargout > 0
        result = [];
    end

    %Init
    ncID = '';
    varID = '';
    var = '';
    shape =[];
    isGrid = 0;
   

    %create structure to store all the class variables
    theStruct = struct( ...
                            'myNCid', ncID, ...
                            'myVarID', varID, ...
                            'varName', var, ...
                            'myShape', shape, ...
                            'isGrid', isGrid ...                            
                       );
    try    
        switch nargin 
            case 2
                ncID = getJDataset(mDatasetObj);                
                theStruct.myNCid = ncID; 
                switch class(varName)
                    case 'char'
                       % figure out whether the variable is gridded or not
                       theStruct.varName = char(varName);
                       theStruct.isGrid = njGridVar(ncID, varName);
                       jVar = ncID.getJNetcdfDataset().getVariable(varName);
                       theStruct.myShape = transpose(jVar.getShape()); %get array shape
                    otherwise, error('MATLAB:mVar:Nargin',...
                                'varName: Input type char/string');
                end
            otherwise, error('MATLAB:mVar:Nargin',...
                                'Incorrect number of arguments');
        end
        
       if (isa(jVar, 'msstate.cstm.data.JVariable')) %check for JVariable Object
            theStruct.myVarID = jVar;            
            result=class(theStruct,'mVar');  %create mVar object
        else
            result=[];
            error('MATLAB:mVar',...
                    'Unable to create mVar Object');
       end             
        
    catch %gets the last error generated 
        err = lasterror();    
        disp(err.message);

    end 
    
    
end





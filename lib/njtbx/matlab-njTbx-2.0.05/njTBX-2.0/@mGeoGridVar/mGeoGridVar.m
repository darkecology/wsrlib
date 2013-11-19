function result = mGeoGridVar(varName, mDatasetObj)
%mGeoGridVar class constructor - creates a GeoGrid Variable object
%
% Usage:
%  gvar=mGeoGridVar(varName, mDatasetObj) reads the variable and create a
%  mGeoGridVar object.
%  where,            
%       varName: variable name, e.g. 'temp' (only gridded variable)
%       mDatasetObj- mDataset object
%  returns,
%       gvar - A 'gvar' object of class 'mGeoGridVar'.
%       In order to know the methods available for data access under
%       class 'mGeoGridVar', use matlab 'builtin' function
%       'methods(className).
%       i.e. methods(gvar)
%
%    Methods for class mGeoGridVar:          
%
%           a. getAttributes(gvar,attName) - get attribute(s) associated with the gridded variable 
%              
%           b. getData(gvar, timeIndex, vertLevelIndex) - get the 3D volume data for all times or particular time index. 
%              Specify 'level' to read a Y-X 'horizontal slice' at the given time  
%           
%           c. getGrid(gvar, timeIndex, vertLevel) - Get grid coordinate and time axes associated with the geogrid. 
%              i.e. lat, lon, time and z.
%                    
%           d. getShape(gvar) - get grid variable shape
%
%           e. getCoordSys(gvar) - Get the Grid Coordinate System associated with the referenced GeoGrid
%              It returns a 'Grid Coordinates' object containing coordinate and time axes.
%
%           f. subsetGeoGridVar(gvar, start, count, stride) - subset gridded variable based on start,count and stride. 
%              It returns a new subsampled mGeoGridVar object. 
%              result = gvar(i,j, ...) - subset using matlab subscripting reference.
%
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

% import netcdf-java 
import msstate.cstm.data.grid.JGeoGridDataset

    %arg check
    if nargin < 2 && nargout < 1
        disp('check input and output arguments!');
        help mGeoGridVar;
        return;
    end

    if nargout > 0
        result = [];
    end

    %Init
    ncID = '';
    gridID = '';
    varID = '';
    var = '';
    shape =[];
    
    %create structure to store all the class variables
    theStruct = struct( ...
                            'myNCid', ncID, ...
                            'myGridID', gridID, ...
                            'myVarID', varID, ...
                            'varName', var, ...
                            'myShape', shape ...                                                        
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
                        GeoGridData = JGeoGridDataset(ncID.getGridDataset(),varName);
                        theStruct.myGridID = GeoGridData;
                        theStruct.myVarID = ncID.getJNetcdfDataset().getVariable(varName);
                        myGeoGrid = GeoGridData.getGeoGrid();    % get geogrid                          
                       
                    otherwise, error('MATLAB:mGeoGridVar',...
                                'varName: Input type char/string');
                end
            otherwise, error('MATLAB:mGeoGridVar:Nargin',...
                                'Incorrect number of arguments');
        end        
       if (isa(myGeoGrid, 'ucar.nc2.dt.grid.GeoGrid')) %check for GeoGrid Object            
            theStruct.myShape = double(transpose(myGeoGrid.getShape()));
            result=class(theStruct,'mGeoGridVar');  %create mGeoGridVar object
        else
            result=[];
            error('MATLAB:mGeoGridVar',...
                    'Non-gridded variable. Unable to create mGeoGridVar Object');
       end             
        
    catch %gets the last error generated 
        err = lasterror();    
        disp(err.message);

    end 
    
    
end





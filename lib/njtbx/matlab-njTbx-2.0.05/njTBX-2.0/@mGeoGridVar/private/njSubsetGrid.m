function result=njSubsetGrid(mGeoGridVarObj,start,count,stride)
% njSubsetGrid: subset grid based on t,z,y,x
% result=njSubsetGrid(mGeoGridVarObj,start,count,stride);
%

% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

% import the NetCDF-Java methods

import msstate.cstm.data.grid.JGeoGridUtil

%initialize
result=[];
if nargin < 4 
    disp('Check input arguments!')
    help njSubsetGrid
    return
end

if (~isa(mGeoGridVarObj, 'mGeoGridVar'))    
    error('MATLAB:mGeoGridVar:njSubsetGrid',...
       'Invalid Object "%s".', class(mGeoGridVarObj));                    
end

try 
       % geoStruct = struct(mGeoGridVarObj); 
        %get original geo grid associate with variable
       origGeoGridData = getGridId(mGeoGridVarObj); 
        
        myShape = getShape(mGeoGridVarObj);
        % we need to clone the orginal JGeoGrid data object
        cloneGeoGridData = origGeoGridData.clone(); 
        GridUtil = JGeoGridUtil(cloneGeoGridData.getGeoGrid());
        
    switch nargin         
      case 4
        [start, count, stride] = parseINF(start,count,stride,myShape);
        %start and count should not exceed the variable dimensions
        if ( (start + count) <= (myShape+1) )
            if (~isempty(stride)) 
                if (length(stride) ~= length(myShape))                                         
                     error('MATLAB:mGeoGridVar:njSubsetGrid',...
                     '"stride" dimensions do not match variable dimensions.');
                end
            end                        
            subGrid = GridUtil.subsetGrid(start,count,stride);
        else                           
            error('MATLAB:mGeoGridVar:njSubsetGrid',...
                  '"count" dimensions exceeds variable dimensions.');
        end
        
        %set subset grid as new GeoGrid
        cloneGeoGridData.setGeoGrid(subGrid);
        
      otherwise, error('MATLAB:mGeoGridVar:njSubsetGrid:Nargin',...
                        'Incorrect number of arguments'); 
    end
    
     
    switch nargout
      case 1
       result = cloneGeoGridData;

      otherwise, error('MATLAB:mGeoGridVar:njSubsetGrid:Nargout',...
                        'Incorrect number of output arguments');
    end  
   
    
catch
    %gets the last error generated 
    err = lasterror();    
    disp(err.message); 
end

  
    
end

    
 
 
    
   


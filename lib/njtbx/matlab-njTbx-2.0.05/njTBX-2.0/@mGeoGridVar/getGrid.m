function result = getGrid(mGeoGridVarObj, timeIndex, vertLevel)
%mGeoGridVar/getGrid - Get grid coordinate and time axes
%                      associated with the geogrid. i.e. lat, lon, time and
%                      z. 
% Method Usage:
%       grid = getGrid(mGeoGridVarObj);
%       grid = getGrid(mGeoGridVarObj, timeIndex)      
%       grid = getGrid(mGeoGridVarObj, timeIndex, vertLevel)  
%
% Where,
%       mGeoGridVarObj - mGeoGridVar object 
%       timeIndex - time step for data extraction (1..n), where n=total
%       number of time steps in a dataset.
%       vertLevel - vertical level (1...m), where m=total number of vertical
%       level.
% returns,
%       grid -  Output grid is retrieved in a matlab structure of type,     
%               grid.lat - Latitutde values
%               grid.lon - Longitude values
%               grid.z   - Vertical Coordinate values
%               grid.time - Time values in matlab serial datenum format.
%
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu)  (C) 2008
% Mississippi State University

%init
result.lat = [];
result.lon = [];
result.z = [];
result.time = [];

if nargin < 1, help(mfilename), return, end
 
    try 
        if (isa(mGeoGridVarObj, 'mGeoGridVar'))
            coordSys = getCoordSys(mGeoGridVarObj);  % get the mCoordinates object
            if (isa(coordSys, 'mGridCoordinates'))
                %lat and lon 
                result.lat = coordSys.getLatAxis;
                result.lon = coordSys.getLonAxis;
                switch nargin 
                    case 1                
                        result.z=coordSys.getVerticalAxis;
                        result.time=coordSys.getTimes;
                    case 2         %specified timestep       
                        result.z=getVerticalAxis(coordSys, timeIndex);
                        result.time=getTimes(coordSys, timeIndex);
                    case 3     %specified timestep and level           
                        result.z=getVerticalAxis(coordSys, timeIndex, vertLevel);
                        result.time=getTimes(coordSys, timeIndex);
                    otherwise, error('MATLAB:mGeoGridVar:getGrid:Nargin',...
                                        'Incorrect number of arguments');
                end
            else
                 error('MATLAB:mGeoGridVar:getGrid',...
                                    'Unable to create mGridCoordinates object.');
            end
            
        else
            error('MATLAB:mGeoGridVar:getGrid',...
                       'Invalid Object "%s". Required "mGeoGridVar".', class(mGeoGridVarObj));
                    
        end
    catch %gets the last error generated 
        err = lasterror();    
        disp(err.message);
    end 

    

end

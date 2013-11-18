function result = getTimeIndex(mGridCoordinatesObj, matDate)
%mGridCoordinates/getTimeIndex - Get time Index from matlab date in DATENUM format
%
% Method Usage:      
%       dateTimes=getTimeIndex(mGridCoordinatesObj, matDate)
% where,  
%       mGridCoordinatesObj - mGridCoordinates object. 
%       matDate - date string in matlab datenum format "dd-mmm-yyyy HH:MM:SS" or datevec or datenum
% returns,
%       result - index for specified time/date. '-1' if no index found.
%

%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu)  (C) 2008
% Mississippi State University

result = [];
dateForm = 0;  % date form "dd-mmm-yyyy HH:MM:SS" 

if nargin < 2, help(mfilename), return, end
 
    try 
        if (isa(mGridCoordinatesObj, 'mGridCoordinates'))
            switch nargin                 
                case 2  
                    myDateString = datestr(matDate);  % convert to right format from datevec/datenum
                    if  ((isa(myDateString, 'char') && strcmp(datestr(myDateString,dateForm),myDateString)))
                        if ( hasTimeAxis(mGridCoordinatesObj) && hasDateTime(mGridCoordinatesObj) )
                            geogrid = getGridId(mGridCoordinatesObj); % msstate.cstm.data.grid.JGeoGridDataset object
                            myCoordSys = geogrid.getCoordinateSystem(); %ucar.nc2.dt.GridCoordinateSystem object
                            result = myCoordSys.findTimeIndexFromDate(njDate(myDateString)) + 1;
                        else
                            disp(sprintf('MATLAB:mGridCoordinates:getTimeIndex: No time axis found or time cannot be express as date (non-CF)'));                       
                            return;  
                            
                        end
                    else                      
                       disp(sprintf('MATLAB:mGridCoordinates:getTimeIndex: Invalid date parameter "%s". Matlab datenum format required.', matDate));                       
                       return;                
                    end

                otherwise, error('MATLAB:mGridCoordinates:getTimeIndex:Nargin',...
                                    'Incorrect number of arguments');
            end
        else
            error('MATLAB:mGridCoordinates:getTimeIndex',...
                                    'Invalid mGridCoordinates Object "%s".', class(mGridCoordinatesObj));
                    
        end
    catch %gets the last error generated 
        err = lasterror();    
        disp(err.message);
   end 


end

function result = getTimes(mGridCoordinatesObj, timeIndex)
%mGridCoordinates/getTimes - Get time(s) in DATENUM format
%
% Method Usage:  
%       dateTimes=getTimes(mGridCoordinatesObj) 
%       dateTimes=getTimes(mGridCoordinatesObj, timeIndex)
% where,  
%       mGridCoordinatesObj - mGridCoordinates object. 
%       timeIndex - time step.
% returns,
%       dateTimes - array of time values in matlab DATENUM format
%
% See also mVar/getTimes
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu)  (C) 2008
% Mississippi State University

result = [];
if nargin < 1, help(mfilename), return, end
 
    try 
        if (isa(mGridCoordinatesObj, 'mGridCoordinates'))
            switch nargin 
                case 1                
                    result=njGetTimes(getGridId(mGridCoordinatesObj));
                case 2                
                    if (isscalar(timeIndex) && isnumeric(timeIndex) && (timeIndex > 0) )
                        result=njGetTimes(getGridId(mGridCoordinatesObj), timeIndex);
                    else
                        error('MATLAB:mGridCoordinates:getTimes:Nargin',...
                                    'Invalid time index "%s". Need scalar and numeric value (>0).', char(timeIndex));
                    end

                otherwise, error('MATLAB:mGridCoordinates:getTimes:Nargin',...
                                    'Incorrect number of arguments');
            end
        else
            error('MATLAB:mGridCoordinates:getTimes',...
                                    'Invalid Object "%s".', class(mGridCoordinatesObj));
                    
        end
    catch %gets the last error generated 
        err = lasterror();    
        disp(err.message);
   end 


end

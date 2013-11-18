function result = getTimes(mVarObj, timeIndex)
%mVar/getTimes - Get time(s) in DATENUM format 
%
% Method Usage:  
%       dateTimes=getTimes(mVarObj) 
%       dateTimes=getTimes(mVarObj, timeIndex)
% where,  
%       mVarObj - mVar object. 
%       timeIndex - time step.
% returns,
%       dateTimes - array of time values in matlab DATENUM format
%
% 
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu)  (C) 2008
% Mississippi State University

result = [];
if nargin < 1, help(mfilename), return, end
 
    try 
        if (isa(mVarObj, 'mVar'))        
            ncID = getNCid(mVarObj);
            ncData = ncID.getJNetcdfDataset;
            
            switch nargin 
                case 1                
                    result=njGetTimes(ncData);
                case 2                
                    if (isscalar(timeIndex) && isnumeric(timeIndex) && (timeIndex > 0) )
                        result=njGetTimes(ncData, timeIndex);
                    else
                        error('MATLAB:mVar:getTimes:Nargin',...
                                    'Invalid time index "%s". Need scalar and numeric value (>0).', char(timeIndex));
                    end

                otherwise, error('MATLAB:mVar:getTimes:Nargin',...
                                    'Incorrect number of arguments');
            end
        else
            error('MATLAB:mVar:getTimes',...
                                    'Invalid Object "%s".', class(mVarObj));
                    
        end
    catch %gets the last error generated 
        err = lasterror();    
        disp(err.message);
   end 


end

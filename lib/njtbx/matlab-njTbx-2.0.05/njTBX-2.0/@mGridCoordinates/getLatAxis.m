function result = getLatAxis(mGridCoordinatesObj)
%mGridCoordinates/getLatAxis - Get the Latitute points (LatLon Projection) 
%   If GeoX/GeoY, then 1D lat/lon points are derived from X,Y values.
%
% Method Usage:  
%   lat=getLatAxis(mGridCoordinatesObj) or
%   lat=mGridCoordinatesObj.getLatAxis
% where,  
%   mGridCoordinatesObj - mGridCoordinates object. 
% returns,
%   lat - matlab array
%
% See also getLonAxis getVerticalAxis
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu)  (C) 2008
% Mississippi State University

result = [];
if nargin < 1, help(mfilename), return, end

 
    try    
        switch nargin 
            case 1 
                myCoordId = getCoordId(mGridCoordinatesObj);
                result=squeeze(myCoordId.getLatAxis());            
            otherwise, error('MATLAB:mGridCoordinates:getLatAxis:Nargin',...
                                'Incorrect number of arguments');
        end   
    catch %gets the last error generated 
        err = lasterror();    
        disp(err.message);
   end 


end

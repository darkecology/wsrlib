function result = getLonAxis(mGridCoordinatesObj)
%mGridCoordinates/getLonAxis - Get the Longitude points (LatLon Projection) 
%   If GeoX/GeoY, then 1D lat/lon points are derived from X,Y values.
%
% Method Usage:  
%   lon=getLonAxis(mGridCoordinatesObj) or
%   lon=mGridCoordinatesObj.getLonAxis
% where,  
%   mGridCoordinatesObj - mGridCoordinates object. 
% returns,
%   lon - matlab array
%
% See also getLatAxis getVerticalAxis
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
                result=squeeze(myCoordId.getLonAxis());            
            otherwise, error('MATLAB:mGridCoordinates:getLonAxis:Nargin',...
                                'Incorrect number of arguments');
        end   
    catch %gets the last error generated 
        err = lasterror();    
        disp(err.message);
   end 


end

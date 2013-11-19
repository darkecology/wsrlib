function result = getData(mGeoGridVarObj, timeIndex, vertLevelIndex)
%mGeoGridVar/getData - get the 3D volume data  
%                       for all times or particular time index. 
%                       Specify 'level' to read a Y-X 'horizontal slice' at the given time                  
% Method Usage:
%       data = getData(mGeoGridVarObj);
%       data = getData(mGeoGridVarObj, timeIndex)
%       data = getData(mGeoGridVarObj, timeIndex, vertLevelIndex) 
% Where,
%       mGeoGridVarObj - mGeoGridVar object
%       timeIndex - time step for data extraction (1..n), where n=total
%       number of time steps in a dataset.
%       vertLevelIndex - vertical level (1...m), where m=total number of vertical
%       level.
% returns,
%       data - matlab array
%
% See also mVar/getData
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University

%init
result = [];

if nargin < 1, help(mfilename), return, end

     try
        geoGridID = getGridId(mGeoGridVarObj);
        if (isa(geoGridID, 'msstate.cstm.data.grid.JGeoGridDataset'))
            switch nargin 
                case 1                
                   result = squeeze(geoGridID.readVarData());   
                case 2
                   if ( isscalar(timeIndex) && isnumeric(timeIndex) && (timeIndex > 0) )
                        result =  squeeze(geoGridID.readVarData(timeIndex-1)); 
                   else
                        error('MATLAB:mGeoGridVar:getData',...
                                'Invalid time index "%s", should be numeric (>0) and scalar.', char(timeIndex));
                   end
                case 3
                   if ( isscalar(vertLevelIndex) && isnumeric(vertLevelIndex) && (vertLevelIndex > 0) && isscalar(timeIndex) && isnumeric(timeIndex) && (timeIndex > 0))
                        result =  squeeze(geoGridID.readYXData(timeIndex-1,vertLevelIndex-1)); 
                   else
                        error('MATLAB:mGeoGridVar:getData',...
                                'Invalid time index or level. Need scalar and numeric value (>0).');
                   end

                otherwise, error('MATLAB:mGeoGridVar:getData:Nargin',...
                                    'Incorrect number of arguments');
            end
        else        
            error('MATLAB:mGeoGridVar:getData',...
                   'GeoGrid object does not exist.');
        end

        catch %gets the last error generated 
            err = lasterror();    
            disp(err.message);
     end   
 

end

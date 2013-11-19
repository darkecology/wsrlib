function [timeIndx, levelIndx]=maxIndex(mGeoGridVarObj)
%Utilties/maxIndex - Get max index for time and vertical dimension.
%
% [timeIndx, levelIndx] = maxIndex(mGeoGridVarObj, isTime, isLevel)
% where,
%           mGeoGridVarObj = mGeoGridVar object          
% returns,
%           timeIndx - max index for time
%           levelIndx - max index for level

% Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (C) 2008
% Mississippi State University
%
%init
timeIndx = 0;
levelIndx = 0;

    if nargin < 1, help(mfilename), return, end

    try 
       if (isa(mGeoGridVarObj, 'mGeoGridVar'))
           jgeogrid = getJGeoGridDataset(mGeoGridVarObj);  %mssate.cstm.data.grid.JGeoGridDataset
           ugeogrid = jgeogrid.getGeoGrid();  %ucar.nc2.dt.grid.GeoGrid
           timeIndx  = ugeogrid.getTimeDimension().getLength();
           levelIndx = ugeogrid.getZDimension().getLength();         
        else
            error('MATLAB:Utilities:maxIndex',...
                                    'Invalid variable object.');
       end
       
    catch %gets the last error generated 
        err = lasterror();    
        disp(err.message);
    end 
end

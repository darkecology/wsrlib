function jdmat=nj_times(netcdfDatasetObj,timeIndex)
%NJ_TIME -Get entire time vector for variable 'var' from any CF-compliant file
%
% Usage: 
%   jdmat=nj_time(netcdfDatasetObj,var,timeIndex);
% where,
%   netcdfDatasetObj - netcdf dataset object
%   (msstate.cstm.data.grid.JGeoGridDataset or msstate.cstm.data.JNetcdfDataset)
%   timeindex = time step
%
% returns,
%   jdmat = vector of times in DATENUM format
%
%
%
% Rich Signell  (rsignell@usgs.gov)
%Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (c) 2008
%Mississippi State University.

import msstate.cstm.data.JDataset
import msstate.cstm.data.grid.JGeoGridDataset
import msstate.cstm.data.JNetcdfDataset
import msstate.cstm.util.JTime

if nargin < 1     
    help nj_time
    return
end

if (class(netcdfDatasetObj))
    ncDataset = netcdfDatasetObj;
else
    disp ('The input netcdf dataset object does not exist');
    help nj_time
    return
end

%init
jdmat = [];

% get the coordinate system for this grid:

if ( isa(ncDataset, 'msstate.cstm.data.grid.JGeoGridDataset') )  % make sure it's gridded data
    GridCoordSys = ncDataset.getCoordinateSystem();
    if ( GridCoordSys.hasTimeAxis() && GridCoordSys.isDate() ) 
        JTimeDate     = GridCoordSys.getTimeDates();
    else    
        disp('No time axis associated with the grid');
        return
    end
else  % consider it as plain netcdf dataset and get the time axis.    
    JTimeDate = ncDataset.getTimeDates();
end


switch nargin
  case 1    
    numTimes=length(JTimeDate);
    t1=datenum(char(JTimeDate(1).toGMTString));
    % check if the time is uniform by calculating
    % dt from the first two points and then seeing if
    % the time series is n*dt long.  If so, don't loop
    % all the java.util.Dates, because this is slow.
    if numTimes>1,
       %preallocate memory for speed
       jdmat = zeros(1,numTimes);        
       t2=datenum(char(JTimeDate(2).toGMTString));
       tend=datenum(char(JTimeDate(end).toGMTString));
       dt=t2-t1;
       ttot=tend-t1;
       if abs(dt*(numTimes-1)-ttot)<eps
         jdmat=t1:dt:tend;
       else        
         jdmat = JTime.getSerialDateNum(JTimeDate);  %static method
       end
    else
       jdmat=t1;
    end
    
  case 2
    jdmat=datenum(char(JTimeDate(timeIndex).toGMTString));   
  
  otherwise, error('MATLAB:cf_time:Nargin',...
                    'Incorrect number of arguments');   
        
end

end



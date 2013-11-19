function result=njGetTimes(netcdfDatasetObj,timeIndex)
%njGetTimes Get entire time vector for variable 'var' from any CF-compliant
%file or just a single time specified by time index

% Usage: result=njGetTimes(netcdfDatasetObj,timeIndex);
% Inputs: netcdfDatasetObj = netcdf dataset object
%                       (msstate.cstm.data.grid.JGeoGridDataset or msstate.cstm.data.JNetcdfDataset)%
%         timeindex = time step
%
% Output: result = vector of times in DATENUM format
%

% Rich Signell  (rsignell@usgs.gov)
% skbhate@ngi.msstate.edu

%CSTM java classes
import msstate.cstm.util.JTime

if nargin < 1     
    help(mfilename)
    return
end

if (class(netcdfDatasetObj))
    ncDataset = netcdfDatasetObj;
else
    disp ('The input netcdf dataset object does not exist');
    help(mfilename)
    return
end

%init
result = [];

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

if (~isempty(JTimeDate)) 
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
           result = zeros(1,numTimes);        
           t2=datenum(char(JTimeDate(2).toGMTString));
           tend=datenum(char(JTimeDate(end).toGMTString));
           dt=t2-t1;
           ttot=tend-t1;
           if abs(dt*(numTimes-1)-ttot)<eps
             result=t1:dt:tend;
           else        
             result = JTime.getSerialDateNum(JTimeDate);  %static method
           end
        else
           result=t1;
        end

      case 2
        result=datenum(char(JTimeDate(timeIndex).toGMTString));   

      otherwise, error('MATLAB:njGetTimes:Nargin',...
                        'Incorrect number of arguments');   

    end
  
end

end



function [data,grd]=nj_subsetGrid(ncRef,var,lonLatRange,dn1,dn2)
% NJ_SUBSETGRID: Subset grid based on lat-lon bounding box and time
%
% Usage:
%   [data, grd]=nj_subsetGrid(uri,var,[lonLatRange], dn1, dn2);
% where,
%   ncRef - Reference to netcdf file. It can be either of two
%           a. local file name or a URL  or
%           b. An 'mDataset' matlab object, which is the reference to already
%              open netcdf file.
%              [ncRef=mDataset(uri)]
%
%  var - variable to subset
%  lonLatRange - [minLon maxLon minLat maxLat]  % matlab 'axes' function      
%  dn1 - Matlab datenum, datestr or datevec  ex: [1990 4 5 0 0 0] or '5-Apr-1990 00:00'        
%  dn2 - Matlab datenum, datestr or datevec (optional)  
%
% Returns,
%   data - subset data  based on lonlat and time range
%   grd - structure containing lon,lat and time
%
%  e.g,
%   ncRef='http://www.gri.msstate.edu/rsearch_data/nopp/bora_feb.nc';
%   var = 'temp';
%   lonLatRange = [13.0 16.0 41.0 42.0];   [minlon maxlon minlat maxlat]
%   dn1 = '14-Feb-2003 12:00:00';
%   dn2 = [2003 2 16 14 0 0];
%   [data, grd]=nj_subsetGrid(ncRef,var,lonLatRange,dn1, dn2)     or
%   [data, grd]=nj_subsetGrid(ncRef,var,lonLatRange,dn1)          or
%   [data, grd]=nj_subsetGrid(ncRef,var,lonLatRange)              or
%   [data, grd]=nj_subsetGrid(ncRef,var)                          or
%
%
%
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu)  (C) 2008
% Mississippi State University%

% import the NetCDF-Java methods 
import msstate.cstm.data.grid.JGeoGridUtil


if nargin < 2, help(mfilename), return, end 
    
%initialize
%data (volume or subset)
data=[]; 
%structure containing lon,lat
grd.lat=[];
grd.lon=[];
grd.time=[];
grd.z=[];
jdmat = [];
isNcRef=0;

try 
        if (isa(ncRef, 'mDataset')) %check for mDataset Object
            nc = ncRef;
            isNcRef=1;
        else
            % open CF-compliant NetCDF File as a Common Data Model (CDM) "Grid Dataset"
            nc = mDataset(ncRef);         
        end    
        % get the mGeoGridVar object
        geoGridVar = getGeoGridVar(nc,var);
        if (~isa(geoGridVar, 'mGeoGridVar'))
            disp(sprintf('MATLAB:nj_subseGrid:Variable "%s" is not a geogrid variable.', var));
            nc.close();
            return;
        end        
        GeoGridData = struct(geoGridVar).myGridID;       
        GridCoordSys = GeoGridData.getCoordinateSystem();
        %get original geo grid associate with variable
        origGrid = GeoGridData.getGeoGrid();
        GridUtil = JGeoGridUtil(origGrid);
        
    switch nargin
      case 2        
        % read the volume data (3D). All times.
        myData = squeeze(GeoGridData.readVarData());     
        
      case 3 
        tindex = int32([]);   
         %subset the orginal geoGrid based on lat-lon range. tindex = null;
        subGrid = GridUtil.subsetGrid(lonLatRange,[]);       
        %set subset grid as new GeoGrid
        GeoGridData.setGeoGrid(subGrid);
        %get the data associated with new subGrid.
        myData = squeeze(GeoGridData.readVarData());  
        
      case 4 
        doSubset(dn1);        
       case 5 
        doSubset(dn1,dn2);
        
      otherwise, error('MATLAB:nj_subsetGrid:Nargin',...
                        'Incorrect number of arguments'); 
    end
    
     
    switch nargout
      case 1
        data = myData;
      case 2
        data = myData;
        % get coordinate axes associated with subGrid
        GridCoordData = GeoGridData.getGridCoordinateData();       
        lat=squeeze(GridCoordData.getLatAxis());
        lon=squeeze(GridCoordData.getLonAxis());
        z=[];
        if (GridCoordData.hasVerticalAxis())
            z=squeeze(GridCoordData.getVerticalCoordinates());
            if (isempty(z))
                z=squeeze(GridCoordData.getVerticalAxis1D());
            end
        end   
        %get time dates
        if ( GridCoordSys.hasTimeAxis() && GridCoordSys.isDate() ) 
            jdmat = nj_times(GeoGridData);  % get the subset of time dates
        end
        % Stuff into grid structure       
         grd.lon=lon;
         grd.lat=lat;
         grd.z=z;
         grd.time = jdmat;
      otherwise, error('MATLAB:nj_subsetGrid:Nargout',...
                        'Incorrect number of output arguments');
    end
    
    %cleanup only if we know mDataset object is for single use.
    if (~isNcRef)
        nc.close();
    end
    
catch
    %gets the last error generated 
    err = lasterror();    
    disp(err.message); 
end

    %subset function based on time range.
    function doSubset(dn1,dn2)
        tindex = int32([]);        
        %subset the orginal geoGrid based on lat-lon and time range.       
        if ( GridCoordSys.hasTimeAxis() && GridCoordSys.isDate() ) 
            jdmat = nj_times(GeoGridData);  % get all the time dates
            switch nargin
                case 1
                    tindex = date_index(jdmat, dn1);
                case 2
                    tindex = date_index(jdmat, dn1,dn2);      
            end            
            if ~isempty(tindex)
                subGrid = GridUtil.subsetGrid(lonLatRange,tindex-1);
            else
                disp('No time range found.');
                subGrid = GridUtil.subsetGrid(lonLatRange);
            end
        else
            disp('No time axis associated with the dataset');
            subGrid = GridUtil.subsetGrid(lonLatRange);
        end        
        %set subset grid as new GeoGrid
        GeoGridData.setGeoGrid(subGrid);
        %get the data associated with new subGrid.
        myData = squeeze(GeoGridData.readVarData());       
       
    end
    
end

    
 
 
    
   


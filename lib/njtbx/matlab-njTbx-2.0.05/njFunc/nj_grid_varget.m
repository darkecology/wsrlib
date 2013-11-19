function [data, grid]=nj_grid_varget(ncRef,var,start, count, stride)
% NJ_GRID_VARGET - get variable data and associated grid coordinates from local NetCDF file, NetCDF URL or OpenDAP URL
%
% Usage:    
%   [data, grid]=nj_grid_varget(file,var,start,count,stride);
% where,
%   ncRef - Reference to netcdf file. It can be either of two
%           a. local file name or a URL  or
%           b. An 'mDataset' matlab object, which is the reference to already
%              open netcdf file.
%              [ncRef=mDataset(uri)]
%   var  =  variable to extract          
%           start = A 1-based array specifying the position in the file to begin reading or corner of a
%                   hyperslab e.g [1 2 1]. Specify 'inf' for last index.
%                   The values specified must not exceed the size of any
%                   dimension of the data set.
%           count = A 1-based array specifying the length of each dimension to read. e.g [6 10 inf]. 
%                   Specify 'inf' to get all the values from start index.
%           stride = A 1-based array specifying the interval between the
%                    values to read. e.g [1 2 2] 
%        
%     Any of these URI types will work:
%     Local NetCDF:  ncRef='bora_feb.nc';
%     Remote NetCDF: ncRef='http://coast-enviro.er.usgs.gov/models/test/bora_feb.nc';
%     OpenDAP:       ncRef='http://coast-enviro.er.usgs.gov/cgi-bin/nph-dods/models/test/bora_feb.nc';
%     Local NcML:    ncRef='bora_feb.ncml';
%     Remote NcML:   ncRef='http://coast-enviro.er.usgs.gov/models/test/bora_feb.ncml';
%
%   Any of these syntaxes will return the surface temperature values
%   from the first time step: Assuming Array shape is [8,20,60,160]        
%           
%     Using 'start' 'count' 'stride' arrays to specify indexing%
%     [data, grid]=nj_grid_varget(ncRef,'temp',[1 1 1 1],[1 1 30 inf],[1 1 2 2]); % get surface temp from first time step 
%          
%     The following will return the entire longitude variable
%     t=nj_grid_varget(ncRef,'lon_rho');  % get all the lon values
%
%
%
%Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (c) 2008
%Mississippi State University.

%initialize
data=[];
grid =[];
isNcRef=0;
if nargin < 2, help(mfilename), return, end

try 
   if (isa(ncRef, 'mDataset')) %check for mDataset Object
        nc = ncRef;
        isNcRef=1;
    else
        % open CF-compliant NetCDF File as a Common Data Model (CDM) "Grid Dataset"
        nc = mDataset(ncRef);         
   end
   tempVar = getVar(nc,var);
   if (tempVar.isGridded)  %make sure it's a geogrid
        % get the mGeoGridVar object
        geoGridVar = getGeoGridVar(nc,var);    
        myShape = geoGridVar.getShape();
        myArgin = nargin;

        if (myArgin == 4) 
            stride = ones(1, length(myShape));
            myArgin = myArgin + 1;
        end

        switch myArgin
            case 2

                data = getData(geoGridVar); % underlying data values
                grid = getGrid(geoGridVar); % get lat,lon,z and time

            case 5                                  
                subGeoGridVar = subsetGeoGridVar(geoGridVar,start,count,stride);
                if (isa(subGeoGridVar, 'mGeoGridVar'))
                    data = getData(subGeoGridVar); % underlying subsetted data values
                    grid = getGrid(subGeoGridVar); % get subsetted lat,lon,z and time
                else                
                     error('MATLAB:nj_grid_varget',...
                                        'Unable to subset geogrid variable.');
                end

            otherwise, error('MATLAB:nj_grid_varget:Nargin',...
                            'Incorrect number of arguments'); 
        end
   else
       disp(sprintf('MATLAB:nj_grid_varget:Variable "%s" is not a geogrid variable.', var));
       if (~isNcRef)
            nc.close();
       end
       return;
   end
    
       
      %cleanup only if we know mDataset object is for single use.
        if (~isNcRef)
            nc.close();
        end
       
    clear tempVar;
    
catch 
    %gets the last error generated 
    err = lasterror();    
    disp(err.message); 
end

    
end

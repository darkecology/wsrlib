function result=nj_time(ncRef,var,timeIndex)
% NJ_TIME - Get entire time vector for variable 'var' from any CF-compliant file
%         NOTE: Time coordinate variable should be CF-compliant.
%
% Usage:
%   result=nj_time(ncRef,var);   - all times
%   result=nj_time(ncRef,var,timeIndex); - time for particular timestep
% where,
%   ncRef - Reference to netcdf file. It can be either of two
%           a. local file name or a URL  or
%           b. An 'mDataset' matlab object, which is the reference to already
%              open netcdf file.
%              [ncRef=mDataset(uri)]
%   var - variable name
%   timeindex - time step
% Returns,
%   result - vector of times in DATENUM format
%
% e.g,
%  Gridded dataset:
%       uri='http://coast-enviro.er.usgs.gov/cgi-bin/nph-dods/models/test/bora_feb.nc';
%       var='temp';
%  Non-Gridded dataset: (But has CF-compliant time coordinate variable)
%       uri='http://www.gri.msstate.edu/rsearch_data/nopp/non-gridded/adcirc/adc.050913.fort.64.nc';
%       var='ubar';
%  
%
% Richard Signell (rsignell@usgs.gov)
% Sachin Kumar Bhate (skbhate@ngi.msstate.edu)  (C) 2008
% Mississippi State University

%initialize
result=[];
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
    
     if (isa(nc, 'mDataset'))
        ncVar = getVar(nc,var);
         if (ncVar.isGridded)
 	            gridVar = getGeoGridVar(nc,var);
 	            ncVar =gridVar.getCoordSys();
 	      end
        switch nargin              
          case 2    %variable attributes 
              result = getTimes(ncVar);  %all times                
          case 3    % get specific time step
              result = getTimes(ncVar,timeIndex); 
           otherwise, error('MATLAB:nj_time:Nargin',...
                            'Incorrect number of arguments'); 
        end
        %cleanup only if we know mDataset object is for single use.
        if (~isNcRef)
            nc.close();
        end
       
    else
        disp(sprintf('MATLAB:nj_time:Unable to create "mDataset" object'));
       return;
    end 
catch 
    %gets the last error generated 
    err = lasterror();    
    disp(err.message); 
end
end




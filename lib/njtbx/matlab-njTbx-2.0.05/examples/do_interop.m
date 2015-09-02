% DO_INTEROP: Model interoperability demo.
%
% Get a 3D temperature field from different CF-compliant models
% WHOI-ROMS, UMAINE-POM, UMASSB-ECOM, UMASSD-FVCOM, UNH-WRF & GOMOOS Time
% series
%
% Rich Signell (rsignell@usgs.gov)

% Just uncomment the "uri" and "var" for the model you want and comment the others.

tic
% WHOI-ROMS Model Output
%uri='http://science.whoi.edu/users/kestons/redtide_2005_hindcast/OUT/avg_gom_0014.nc';
%uri='http://coast-enviro.er.usgs.gov/models/whoi/redtide_2005_hindcast/avg_gom_0014.nc';
%var='temp';

% UMAINE-POM Model Output
% try both the following to see which is fastest for you (they access
% identical data:
%uri='http://coast-enviro.er.usgs.gov/thredds/dodsC/gom_interop/umaine/latest';
uri='http://rocky.umeoce.maine.edu:8080/thredds/dodsC/gom_interop/umaine/latest';
var='temp';

% UMASSB-ECOM Model Output
%uri='http://coast-enviro.er.usgs.gov/thredds/dodsC/gom_interop/umassb/latest';
%var='temp';

% UMASSD-FVCOM Model Output
%uri='http://fvcom.smast.umassd.edu/Data/netcdf_java.nc';
%uri='http://coast-enviro.er.usgs.gov/models/test/fvcom2.nc';
%var='temp';

% UNH-WRF meteo Model Output (vertical coords are in millibars)
%uri='http://coast-enviro.er.usgs.gov/thredds/dodsC/gom_interop/unh/2008_wrf';
%var='Temperature';

% GOMOOS Time series data
%uri='http://gyre.umeoce.maine.edu/data/gomoos/buoy/archive/A0119/realtime/A0119.sbe37.realtime.1m.nc'
%uri='http://gyre.umeoce.maine.edu/data/gomoos/buoy/archive/A0119/realtime/A0119.sbe37.realtime.20m.nc';
%var='temperature';

istep=1;
% Get Data and Geo-Grid at a particular time step
disp('accessing data...');
[t,t_grd] = nj_grid_varget(uri,var,[istep,1,1,1],[1,inf,inf,inf]);
% How long did it take to retrieve the data?
toc

% See what we got:
whos t
t_grd








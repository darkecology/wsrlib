% TEST_PLOT3D_FVCOM - Plot a 3d field from an FVCOM file at a particular time step
%
% Rich Signell (rsignell@usgs.gov)

%% Specify input variables

uri='http://fvcom.smast.umassd.edu/Data/netcdf_java.nc';
var_1='temp';
var_2='nv';

%% Call njTBX functions
% Read all the times 
% jdmat= nj_time(uri,var);
% itime=near(jdmat,datenum('30-Oct-2007 01:00')); % find the time step nearest this date

itime=1;  % get the 1st time step from this URI

% Read data and geo_grid for 3D field at time step ITIME
% This works for any CF compliant NetCDF file, structured, unstructured
  
[var,var_grd] = nj_grid_varget(uri,var_1,[itime,1,1,1],[1,inf,inf,inf]);

%Read connectivity array
% This is specific to unstructured grid, and FVCOM

nv=nj_varget(uri,var_2); 

%% Plot data
%Plot up the bottom layer temperature:

trisurf(nv.',var_grd.lon,var_grd.lat,var_grd.z(end,:),var(end,:));
view(43,46);
shading('interp');
colorbar
camlight headlight
lighting phong
set(gca,'DataAspectRatio',[1 0.74 500]); % lon/lat
titl=sprintf('FVCOM: Bottom %s at %s',var_1,datestr(var_grd.time));
title(titl);
figure(gcf);



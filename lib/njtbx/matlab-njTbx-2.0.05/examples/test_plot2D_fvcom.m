% TEST_PLOT2D_FVCOM - Plot 2d elevation field for fvcom data.
%
% Rich Signell (rsignell@usgs.gov)

%% Specify input variables

uri='http://fvcom.smast.umassd.edu/Data/netcdf_java.nc';
var_1='zeta';
var_2='nv';


%% Call njTBX functions

% read 1st time step of 2D elevation field
[zeta,zeta_grd] = nj_grid_varget(uri,var_1,[1,1,1],[1,inf,inf]);

% read connectivity array
nv=nj_varget(uri,var_2);

%% Plot data

trisurf(nv.',zeta_grd.lon,zeta_grd.lat,zeta);
caxis([-1 1]);view(2);
set(gca,'DataAspectRatio',[1 .74 1]);
title(['FVCOM zeta at: ' datestr(zeta_grd.time)]);
colorbar
figure(gcf);

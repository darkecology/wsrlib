% PLOT_ISOSURFACE - Read 3D field and plot isosurface.
%
% rsignell@usgs.gov

%% Specify input variables

uri='http://science.whoi.edu/users/kestons/redtide_2005_hindcast/OUT/avg_gom_0014.nc';
var='temp';

%specify time step & iso_value
timestep=1;
iso_value=8;

%% Call njTBX functions

[t,g]=nj_tslice(uri,var,timestep);

%% Plot data

iso_plot(t,g,iso_value);

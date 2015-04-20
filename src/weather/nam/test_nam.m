
file = 'test/nam_218_20100801_0000_000.grb2';

varname = 'U-component_of_wind';
%varname = 'U-component_of_wind_height_above_ground';
%varname = 'U-component_of_wind_height_above_ground';
%varname = 'Categorical_Rain';

[u_wind, grid] = nj_grid_varget(file, varname);

[X,Y] = nam_ll2xy(grid.lon, grid.lat);

[LON,LAT] = nam_xy2ll(X, Y);

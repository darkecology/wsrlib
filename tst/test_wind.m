


wind_file = sprintf('%s/data/NARR/data/2010/merged_AWIP32.2010080100.3D', getenv('HOME'));
%obj = mDataset(wind_file);
%var = getGeoGridVar(obj, 'u_wind');
%getAttributes(var)
%getShape(var)

[u_wind, grid] = nj_grid_varget(wind_file, 'u_wind');

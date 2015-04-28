
nwp = NAM();

file = nwp.sample_file();
%'namdata/nam_218_20100801_0000_000.grb2';

%varname = 'U-component_of_wind';
%varname = 'U-component_of_wind_height_above_ground';
%varname = 'U-component_of_wind_height_above_ground';
%varname = 'Categorical_Rain';

%[u_wind, grid] = nj_grid_varget(file, varname);
[u_wind, v_wind, grid] = nwp.read_wind(file);

[X1,Y1] = nwp.ll2xy(grid.lon, grid.lat);
[X2,Y2] = grid_points(nwp.grid());

fprintf('max X difference: %.4e\n', max(abs(X1(:) - X2(:))));
fprintf('max Y difference: %.4e\n', max(abs(Y1(:) - Y2(:))));

[LON,LAT] = nwp.xy2ll(X2, Y2);

fprintf('max lon difference: %.4e\n', max(abs(LON(:) - grid.lon(:))));
fprintf('max lat difference: %.4e\n', max(abs(LAT(:) - grid.lat(:))));

[i,j] = nwp.xy2ij(X2, Y2);

s = nwp.grid();

row = 1:s.nx;
if ~isequal(j, repmat(row, s.ny, 1))
    error('xy2ij failed');
end

% Every column of i should be the same
col = (1:s.ny)';
if ~isequal(i, repmat(col, 1, s.nx))
    error('xy2ij failed');
end

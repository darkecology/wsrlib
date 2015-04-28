% For further details on the NARR grid, see 
%  http://www.nco.ncep.noaa.gov/pmb/docs/on388/tableb.html#GRID221


wind_file = 'data/merged_AWIP32.2010010321.3D';

[~, ugrid] = nj_grid_varget(wind_file, 'u_wind');

[X, Y] = narr_ll2xy(ugrid.lon, ugrid.lat);

% Rows of X and cols of Y are identical to ~1e-14
%    Take average to get "official" x/y spacings

x = mean(X,1);
y = mean(Y,2);

[ny, nx] = size(X);

fprintf('s.nx = %d;\n', nx);
fprintf('s.ny = %d;\n', ny);
fprintf('s.x0 = %.15f;\n', x(1));
fprintf('s.y0 = %.15f;\n', y(1));
fprintf('s.dx = %.15f;\n', mean(diff(x)));
fprintf('s.dy = %.15f;\n', mean(diff(y)));

% subplot(1,2,1);
% imagesc(X);
% axis xy;
% xlabel('X');
% 
% subplot(1,2,2);
% imagesc(Y);
% axis xy;
% xlabel('Y');

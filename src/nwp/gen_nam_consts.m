% For further details on the NAM grid, see 
%  http://www.nco.ncep.noaa.gov/pmb/docs/on388/tableb.html#GRID218

%wind_file = 'test/nam_218_20100801_0000_000.grb2';

nam = NAM3D_212();
wind_file = nam.sample_file();

[uwind, ~, grid] = nam.read_wind(wind_file);

sz = size(uwind);

[X, Y] = nam.ll2xy(grid.lon, grid.lat);

% Rows of X and cols of Y are identical to ~1e-14
%    Take average to get "official" x/y spacings

x = mean(X,1);
y = mean(Y,2);

[ny, nx] = size(X);

fprintf('s.nx = %d;\n', nx);
fprintf('s.ny = %d;\n', ny);
fprintf('s.nz = %d;\n', sz(1));
fprintf('s.sz = %s;\n', mat2str(sz));
fprintf('s.x0 = %.15f;\n', x(1));
fprintf('s.y0 = %.15f;\n', y(1));
fprintf('s.dx = %.15f;\n', mean(diff(x)));
fprintf('s.dy = %.15f;\n', mean(diff(y)));

figure()
subplot(1,2,1);
imagesc(X);
axis xy;
xlabel('X');

subplot(1,2,2);
imagesc(Y);
axis xy;
xlabel('Y');

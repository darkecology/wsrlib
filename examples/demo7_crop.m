% Load scan
radar_file = 'data/KDOX20111001_110612_V04.gz';
station    = 'KDOX';
radar      = rsl2mat(radar_file, station);

% Roost location and radius
x0 = -6909;
y0 = 68397.5;
r  = 10560.28723;

% Convert first sweep to Cartesian
rmax         = 150000;  % 150km
dim          = 600;     % 600 pixel image
[dBZ, x, y] = sweep2cart(radar.dz.sweeps(1), rmax, dim);

% Create a grid object to help reference into image
lim = rmax * [-1, 1];
s = create_grid(lim, lim, dim, dim);

% Get pixel coordinates of roost center. NB: we must negate y0
% because the positive y direction is down in the grid coordinate system
[i, j] = xy2ij( x0, -y0, s); 
[di, dj] = dxy2dij(2*r, 2*r, s); % displacement of 2r

% Indices within 2r in either direction
I = i-di : i+di;
J = j-dj : j+dj; 

% Get the image patch
patch = dBZ(I, J);

% Diplay whole image and patch
figure(1)
clf();

dzlim = [-5, 30]; % color scaling

subplot(1,2,1);
imagesc(dBZ, dzlim);
colorbar();

subplot(1,2,2);
imagesc(patch, dzlim);
colorbar();
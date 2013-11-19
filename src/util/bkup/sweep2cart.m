function z = sweep2cart( sweep, rmax, dim )
%SWEEP2CART Convert a sweep to cartesian coordinates
% 
%  im = sweep2cart( data, az, range, rmax, dim )
%
% Inputs:
%   data  - m x n data matrix in polar coordinates (columns are rays)
%   az    - n-vector of the azimuths
%   range - m-vector of the ranges
%   rmax  - the max radius of the cartesian image
%   dim   - # of pixels of the cartesian image

[data, mask, az, range] = align_sweeps({sweep}, inf, 'ground');
data = data{1};
data(~mask) = nan;

% Generate an (x,y) grid 
x1 = linspace (-rmax, rmax, dim);
y1 = -x1;

% Map (x,y) coordinates to slant radius and azimuth
[x, y] = meshgrid(x1, y1);
[phi, s] = cart2pol(x, y);

% Azimuth is measured clockwise from north in degrees
phi = 90-rad2deg(phi); 
phi(phi > 360) = phi(phi > 360) - 360;
phi(phi < 0) = phi(phi < 0) + 360;

% Now get slant range of each pixel on this elevation
r = groundElev2slant(s, sweep.elev);

% Make radials wrap around for proper interpolation
az   = [az(end)-360;  az;  az(1)+360 ]; 
data = [data(:,end)   data data(:,1)   ];

% Create the interpolating function
F = griddedInterpolant({range, az}, data, 'linear');

% Interpolate
z = F(r, phi);

end


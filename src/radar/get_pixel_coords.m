function [ az, dist, z ] = get_pixel_coords( az, dist, z )
%GET_PIXEL_COORDS Get matrices of coordinates for each pixel
%
% [ az, dist, z ] = get_pixel_coords( az, dist, z )
% 
% Input:
%  az   - vector (length n) of azimuths
%  dist - vector (length m) of pixel great circle distances along a radial
%  z    - vector (length m) of pixel heights along a radial
%
% Output:
%  Each of (az, dist, z) will be expanded to an m x n matrix with
%  coordinate of each pixel.
%

if ~(isvector(az) && isvector(dist) && isvector(z))
    error('Inputs must be vector');
end

% Make sure they are column vectors
az = az(:);
dist = dist(:);
z = z(:);

m = numel(dist);
n = numel(az);

if ~numel(z) == m
    error('dist and z must be same length');
end

% Distance and height vary by row
dist = repmat(dist, 1, n);
z    = repmat(z,    1, n);

% Angle varies by column
az = repmat(az', m, 1);

end


function [Z, x, y, F] = mat2cart( data, az, range, dim, rmax, interp_type, trim_polar)
%MAT2CART Convert a sweep to cartesian coordinates
% 
%  [Z, x, y] = mat2cart( data, az, range, dim )
%
% Inputs:
%   data  - m x n data matrix in polar coordinates (columns are rays)
%   az    - vector or matrix of azimuths (*)
%   range - vector or matrix of ranges (*)
%   rmax  - maximum range (default: max(range))
%   dim   - # of pixels of the cartesian image
%   trim_polar - if true the trim polar to given rmax
%
% Outputs:
%   Z - cartesian data (i.e., image)
%   x - vector of x coordinates
%   y - vector of y coordinates
%
% (*) az and range can be in matrix or vector form
% 
%  Matrix form: 
%    - az and range are both m x n
%    - az(i,j) is the azimuth for data(i,j)
%    - range(i,j) is the range for data(i,j)
%    - all rows of az are identical
%    - all columns of range are identical
%
%  Vector form:
%    - az is n x 1; az(j) is the azimuth of data(i,j)
%    - range is m x 1; range(i) is the range of data(i,j)

if nargin < 4
    dim = 400;
end

if nargin < 5 || isinf(rmax) || isempty(rmax)
    rmax = max(range(:));
end

if nargin < 6
    interp_type = 'linear';
end

if nargin < 7
    trim_polar = true;
end

% Trim data beyond rmax
if trim_polar
    I = range < rmax;
    range = range(I);
    data = data(I,:);
end

F = radarInterpolant(data, az, range, interp_type);

% Generate an (x,y) grid
x = linspace (-rmax, rmax, dim);
y = -x;

% Map (x,y) coordinates to range and azimuth
[X, Y] = meshgrid(x, y);
[PHI, R] = cart2pol(X, Y);
PHI = pol2cmp(PHI);  % convert from radians to compass heading

% Interpolate
Z = F(R, PHI);

end

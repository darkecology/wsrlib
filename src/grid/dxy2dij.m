function [ di, dj ] = dxy2dij( dx, dy, s )
%DXY2DIJ Convert from x, y displacement values to i,j displacement values
%
%   [ di, dj ] = dxy2dij( dx, dy, s )
%
% Input:
%    dx, dy    Vectors or matrices of x, y displacement
%    s         Grid struct
%
% Output: 
%    di, dj    i, j displacements. Same dimensions as dx, dy.
%
% See also CREATE_GRID, NARR_GRID, XY2IJ

if nargin < 3
    error('Three arguments are required');
end

[di, dj] = xy2ij(s.x0 + dx, s.y0 + dy, s);

di = round(dy./s.dy);
dj = round(dx./s.dx);

end

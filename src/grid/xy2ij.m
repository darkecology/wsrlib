function [ i, j ] = xy2ij( x, y, s )
%XY2IJ Convert from x,y coordinates to i,j grid indices
%
%   [ i, j ] = xy2ij( x, y, s )
%
% Input:
%    x, y      Vectors or matrices of x,y coordinates
%    s         Grid struct
%
% Output: 
%    i, j      Grid indices: i is same size as y and j is same size as x
%
% See also CREATE_GRID, NARR_GRID

if nargin < 3
    error('Three arguments are required');
end

i = round((y - s.y0)./s.dy) + 1;
j = round((x - s.x0)./s.dx) + 1;

if any(i(:) < 1) || any(j(:) < 1) || any(i(:) > s.ny) || any(j(:) > s.nx)
    fprintf('Warning: some points fall outside grid\n');
end

% Fix points that fall outside of the grid
i(i < 1) = 1;
j(j < 1) = 1;

i(i > s.ny) = s.ny;
j(j > s.nx) = s.nx;

end

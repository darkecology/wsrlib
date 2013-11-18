function [X, Y] = grid_points(s)
% GRID_POINTS Generate all grid points
%   [X, Y] = grid_points(s)
% s is a structure describing the grid

x = s.x0 + s.dx*(0:(s.nx-1));
y = s.y0 + s.dy*(0:(s.ny-1));

[X, Y] = meshgrid(x, y);

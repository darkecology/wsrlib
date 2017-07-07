function [X, Y, x, y] = grid_points(s)
% GRID_POINTS Return all grid points
%
%   [X, Y] = grid_points(s)
%
% Input:
%  s      structure describing the grid
% Outputs:
%  X, Y   2d matrices giving X and Y locations of grid points
%
% See also CREATE_GRID

x = s.x0 + s.dx*(0:(s.nx-1));
y = s.y0 + s.dy*(0:(s.ny-1));

[X, Y] = meshgrid(x, y);

function [ x_edges, y_edges ] = grid_edges( s )
%GRID_EDGES Return grid cells edges
%
%  [ x_edges, y_edges ] = grid_edges( s )
% 
% Inputs:
%   s is a struct describing a grid
%

x_start = s.x0 - s.dx/2;
y_start = s.y0 - s.dy/2;

x_edges = x_start + s.dx*(0:s.nx);
y_edges = y_start + s.dy*(0:s.ny);

end

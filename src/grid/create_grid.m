function [ s ] = create_grid( xlim, ylim, nx, ny, cornertype )
%CREATE_GRID Return a structure defining a 2D spatial grid
%
%  [ s ] = create_grid( xlim, ylim, nx, ny )
%
% Inputs
%   p           2-element vector: min/max x coordinates
%   q           2-element vector: min/max y coordinates
%   nx          integer: number of grid points in the x direction
%   ny          integer: number of grid points in the y direction
%   cornertype  string: 'point' | 'edge' (default: 'point')
%
% NOTE:
%   The grid is conceptualized as an equally spaced set of *points*, 
%   not cells. By default, p and q specify the positions of the 
%   corner grid points. 
% 
%   The grid points can be used to define grid cells by identifying each
%   point with the center of a cell. Use GRID_EDGES to get the grid cell
%   edges
%
%   Set cornertype='edge' to define the grid spatial extent by the
%   *corners* of the bottom-left and top-right grid cells instead of 
%   the centers. 
%
% See also GRID_EDGES, GRID_POINTS, XY2IJ

if nargin < 5 || isempty(cornertype)
    cornertype = 'point';
end

s.nx = nx;
s.ny = ny;

x0 = xlim(1);
x1 = xlim(2);

y0 = ylim(1);
y1 = ylim(2);

switch cornertype
    case 'point'
        s.dx = (x1-x0)/(nx-1);
        s.dy = (y1-y0)/(ny-1);
        s.x0 = x0;
        s.y0 = y0;
    case 'edge'
        s.dx = (x1 - x0)/nx;
        s.dy = (x1 - x0)/ny;
        s.x0 = x0 + s.dx/2;
        s.y0 = x1 + s.dy/2;
    otherwise
        error('Unrecognized cornertype');
end

end

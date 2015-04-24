function [ i, j ] = narr_xy2ij( x, y )
%NARR_XY2IJ Convert from NARR x,y coordinates to i,j indices into NARR grid
%
% Find the closest grid point to given x,y point

s = narr_grid();
[i, j] = xy2ij(x, y, s);

end

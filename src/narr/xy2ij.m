function [ i, j ] = xy2ij( x, y, s )
%XY2IJ Convert from NARR x,y coordinates to i,j indices into NARR grid
%
% Find the closest grid point to given x,y point

if nargin < 3
    s = narr_consts();
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

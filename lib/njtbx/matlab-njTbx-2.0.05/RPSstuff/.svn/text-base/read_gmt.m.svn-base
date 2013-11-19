function [x,y,z]=read_gmt(grdfile)
% READ_GMT reads GMT grid file into Matlab arrays x,y,z
%   Usage: [x,y,z]=read_gmt(grdfile);
%    where 
%          x = east coordinate vector (eg. longitude)
%          y = north coordinate vector (eg. latitude)
%          z = matrix of gridded values (eg. bathy grid)
%
%   Example:
%           [x,y,z]=read_gmt('foo.grd');
%           contour(x,y,z)

% Rich Signell
% rsignell@usgs.gov
  
nc=netcdf(grdfile);
x_range=nc{'x_range'}(1:2);
y_range=nc{'y_range'}(1:2);
spacing=nc{'spacing'}(1:2);
dims=nc{'dimension'}(1:2);
nx=dims(1);
ny=dims(2);
xysize=nx*ny;
z=nc{'z'}(1:xysize);
close(nc);

z=reshape(z,nx,ny);
z=flipud(z.');
x=x_range(1)+[0:(nx-1)]*spacing(1);
y=y_range(1)+[0:(ny-1)]*spacing(2);


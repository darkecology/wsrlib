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
x_range=nc{'x_range'}(:);
y_range=nc{'y_range'}(:);
spacing=nc{'spacing'}(:);
nxny=nc{'dimension'}(:);
nx=nxny(1);
ny=nxny(2);
z=nc{'z'}(:);
z=reshape(z,nx,ny);
z=flipud(z.');
x=linspace(x_range(1),x_range(2),nx);
y=linspace(y_range(1),y_range(2),ny);
close(nc);

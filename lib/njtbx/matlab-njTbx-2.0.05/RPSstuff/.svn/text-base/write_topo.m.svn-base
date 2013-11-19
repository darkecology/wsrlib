function []=write_topo(cdf,z,x,y);
% WRITE_TOPO: Writes 2D topo/bathy data to NetCDF file
% Usage: write_topo(cdf,z,x,y);
%        cdf = name of netcdf file for output
%          x = x independent variable (lon, easting, etc.)
%          y = y independent variable (lat, northing, etc.
%          z = z dependent variable (topo grid, bathy grid)
% if contour(z,x,y) looks good, then use this routine
% to write out the data to netCDF
%
z=fliplr(z');
cdfid=mexcdf('create',cdf,'clobber');
nx=length(x);
ny=length(y);
% define dims
xdimid=mexcdf('dimdef',cdfid,'lon',nx);
ydimid=mexcdf('dimdef',cdfid,'lat',ny);
% define vars
xid=mexcdf('vardef',cdfid,'lon','float',1,xdimid);
yid=mexcdf('vardef',cdfid,'lat','float',1,ydimid);
zid=mexcdf('vardef',cdfid,'topo','float',2,[ydimid xdimid]);
% end of define mode
mexcdf('endef',cdfid);
% put variables
mexcdf('varput',cdfid,xid,0,nx,x);
mexcdf('varput',cdfid,yid,0,ny,y);
mexcdf('varput',cdfid,zid,[0 0],[ny nx],z);
% close file
mexcdf('close',cdfid);
 

function []=write_topo_cf_short(ncfile,z,lon,lat,scale_factor);
% WRITE_TOPO: Writes 2D topo/bathy data to CF compliant NetCDF file
% so we can visualized in tools like IDV
%u  Usage: write_topo_cf(ncfile,z,lon,lat);
%        ncfile = name of netcdf file for output
%         lon = longitude (west negative)
%         lat = latitude (north positive)
%         z = z dependent variable (topo grid, bathy grid)
% if pcolor(x,y,z) looks good (not flipped or rotated), then use this routine
% to write out the data to netCDF
%
nc=netcdf(ncfile,'clobber');

[ny,nx]=size(z);


% define variables

[m,n]=size(lon);

if(min(m,n)==1),
% lon,lat are 1D
% define dimensions
  nc('lon')=nx;
  nc('lat')=ny;
  nc{'topo'}=ncshort('lat','lon');
  nc{'lon'}=ncdouble('lon');
  nc{'lat'}=ncdouble('lat');
else
% lon,lat are 2D
  nc('x')=nx;
  nc('y')=ny;
  nc{'topo'}=ncshort('y','x');
  nc{'lon'}=ncdouble('y','x');
  nc{'lat'}=ncdouble('y','x');
  nc{'topo'}.coordinates='lon lat';
end
add_offset=0;
nc{'topo'}.scale_factor=ncfloat(scale_factor); 
nc{'topo'}.add_offset=ncfloat(add_offset); 
nc{'lon'}.units='degree_east';
nc{'lat'}.units='degree_north';
nc{'topo'}.units='meter';
nc.Conventions='CF-1.0';

% fill variables with data
nc{'lon'}(:)=lon;
nc{'lat'}(:)=lat;
nc{'topo'}(:)=z;

close(nc);

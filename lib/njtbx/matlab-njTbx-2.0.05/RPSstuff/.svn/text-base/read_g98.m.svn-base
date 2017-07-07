% created from http://www.ngdc.noaa.gov/mgg/gdas/gd_designagrid.html
% using a range of -119,-118,43,44 and int16 w/ 0.1 m resolution

% this script should work for any GRD98 grid if written in int16 and with
% 0.1 m resolution 

fid=fopen('rps_0001.g98');
% read the header stuff
head=fread(fid,32,'int32');
% read the rest
%z=fread(fid,inf,'inf16');  % for short int
z=fread(fid,inf,'int32');   % for regular int
fclose(fid);

lat_max=sign(head(4))*(abs(head(4))+head(5)/60+head(6)/3600);
dy=head(7)/3600;
ny=head(8);
lat_min=lat_max-(ny-1)*dy;
y=linspace(lat_min,lat_max,ny);

lon_min=sign(head(9))*(abs(head(9))+head(10)/60+head(11)/3600);
dx=head(12)/3600;
nx=head(13);
lon_max=lon_min+(nx-1)*dx;
x=linspace(lon_min,lon_max,nx);

z=reshape(z,nx,ny);
z=rot90(double(z)/10.);
contour(x,y,z,[0 -100]);
dasp(lat_min);
write_gmt(x,y,z,'vs_crm.grd');

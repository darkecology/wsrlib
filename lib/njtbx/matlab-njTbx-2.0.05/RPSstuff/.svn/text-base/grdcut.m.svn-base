function [x,y,z]=grdcut(grdfile, region)
% GRDCUT:  reads subregion of GMT grid file into Matlab arrays x,y,z
%
%   Usage: [x,y,z]=grdcut(grdfile, region);
%    where 
%          x = east coordinate vector (eg. longitude)
%          y = north coordinate vector (eg. latitude)
%          z = matrix of gridded values (eg. bathy grid)
%
%          grdfile = gmt filename.
%          region = [west east south north] 
%
%   Example:
%           [x,y,z]=grdcut('foo.grd');
%           contour(x,y,z)
%
% joevans@usgs.gov
  
if ( nargin ~= 2 )
    help grdcut;
    return;
end

%
% Error checking on the region vector.
if ( region(1) >= region(2) )
    fprintf ( 2, 'West longitude must be numerically smaller than east longitude.\n' );
    help grdcut;
    return;
end
if ( region(3) >= region(4) )
    fprintf ( 2, 'South longitude must be numerically smaller than north longitude.\n' );
    help grdcut;
    return;
end


cdfid=mexcdf('open',grdfile,'nowrite');

oldopts=mexcdf('setopts',0);

x_range=mexcdf('varget',cdfid,'x_range',0,2);
west_neg='false';
if(region(2)<x_range(1)),
  if((360-region(1))>=x_range(1)),
     region(1)=360+region(1);
     region(2)=360+region(2);
     west_neg='true ';
  end
end
y_range=mexcdf('varget',cdfid,'y_range',0,2);
spacing=mexcdf('varget',cdfid,'spacing',0,2);

west_longitude = region(1);
east_longitude = region(2);
south_latitude = region(3);
north_latitude = region(4);

dims=mexcdf('varget',cdfid,'dimension',0,2);

nx=dims(1);
ny=dims(2);

x=x_range(1)+[0:(nx-1)]*spacing(1);
y=y_range(1)+[0:(ny-1)]*spacing(2);


%
% Now restrict the x vector to the longitudes given in the
% region vector.
xinds = find ( (x>=west_longitude) & (x<=east_longitude) );
x = x(xinds);
yinds = find ( (y>=south_latitude) & (y<=north_latitude) );
y = y(yinds);

z = zeros(length(yinds),length(xinds));
n = length(yinds);
for i = 1:n
    z_row = mexcdf ( 'varget', cdfid, 'z', (ny - (yinds(i)-1))*nx, nx );
    z(i,:) = z_row(xinds)';
end
%z = flipud(z);

if(west_neg=='true '),
  x=x-360;
end 

mexcdf('close',cdfid);



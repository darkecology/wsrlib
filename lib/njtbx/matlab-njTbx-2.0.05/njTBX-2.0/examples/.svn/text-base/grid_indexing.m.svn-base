% Apply matlab subscripting reference on geogrid to retrieve data and grid
% in a gridData object.
ncRef = 'http://coast-enviro.er.usgs.gov/cgi-bin/nph-dods/models/test/bora_feb.nc';
var='u';
%get mDataset object
nc=mDataset(ncRef);
%get geogrid
geog=getGeoGridVar(nc,var);
%use array indexing to subset grid. 
%It returns a subsampled geogrid var object
subgeog=geog(3:5,7,10:15,2:end);  %shape[8 20 60 160]

%get the data and grid from the geogrid  object
data1=getData(subgeog); 
grd1=getGrid(subgeog);

% data and grid can also be accessed directly without creating a geogrid
% var

data2 = nc{var}(3:5,7,10:15,2:end).data;
grd2 = nc{var}(3:5,7,10:15,2:end).grid;

close(nc);
clear nc;



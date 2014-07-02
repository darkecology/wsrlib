function [ vel,lon, lat, height ] = narr_radial_vel( u_wind, v_wind, range, az, elev, lon0, lat0, height0 )
%NARR_RADIAL_VEL Get radialized wind velocity from NARR data
%
% [ vel,lon,lat ] = narr_radial_vel( u_wind, v_wind, range, az, elev, lon0, lat0, height0 )
%
% Inputs: 
%   u_wind, v_wind   3D wind components read from NARR file
%   range, az, elev  Pulse volume coordinates (see below)
%   lon0             Longitude of radar station
%   lat0             Latitude of radar station
%   height0          Height of radar station in meters
%
% Outputs:
%   vel              Radialized wind matrix
%   lon, lat         Pulse volume coordinate in lon,lat
%
% The three coordinate matrices (range, az, elev) should have the same size
% and will specify the size of the output. The matrices can be
% multidimensional. 
%
% The output value vel(i1,i2,...,ik) is the radial component of the NARR
% wind velocity at the 3D location specified in polar coordinates by 
%
%   range(i1,...,ik), az(i1,...,ik), elev(i1,...,ik)
%
% The coordinates of the corresponding pulse-volume in earth-referenced
% lon, lat, height coordinate system are:
%  
%  lon(i1,...,ik), lat(i1,...,ik), height(i1,...,ik)
%

% Convert from (beam range, elev angle) to (great circle distance, height)
[dist, height] = slant2ground(range, elev);
height = height + height0;

sz = size(az);

% Now compute (az, dist, z) for each pixel
%[az, dist, height] = get_pixel_coords(az, dist, height);

% Convert from (az, dist) relative to station to absolute (lat, lon) (aka "reckoning")
[lon, lat] = m_fdist(lon0, lat0, az(:), dist(:), 'sphere');
lon = lon-360;

% Convert to NARR x,y and then i,j coordinates
[x, y] = ll2xy(lon, lat);
[i, j] = xy2ij(x, y);
k = height2level(height);

% Now do the lookup
%   First do this using linear indices
ind = sub2ind(size(u_wind), k(:), i(:), j(:));
u = double(u_wind(ind));
v = double(v_wind(ind));

%   Then reshape into matrices
u = reshape(u, sz);
v = reshape(v, sz);

vel = radialize(az, elev, u, v);

end

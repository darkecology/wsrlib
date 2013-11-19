function [ vel,lon,lat ] = get_vel( u_wind, v_wind, range, az, elev, lon0, lat0, height0 )
%GET_VEL 
% Function which ill return the radialized wind velocity matrix from the
% u_wind and v_wind components and the radial velocity matrix for the
% current sweep. 
% Input: u_wind and v_wind which are are wind components read in from the
% NARR wind file
% vr is the radial velocity data and az is the matrix of azimuths
% range is the vector of all ranges covered in this sweep
% elev is the elevation of this sweep from vr_sweep.elev
% radar is the current radar object
% output: vel which is the radial velocity, lon and lat are the longitude
% and latitude matrices respectively

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

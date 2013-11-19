function [ az, range, elev ] = xyz2radar( x, y, z )
%XYZ2RADAR Convert (x, y, z) to (az, range, elev)

% Get azimuth and ground (great circle) distance
[az, s] = cart2pol(x, y);

% Azimuth is measured clockwise from north in degrees
az = 90-rad2deg(az); 
az(az > 360) = az(az > 360) - 360;
az(az < 0) = az(az < 0) + 360;

% Now get slant range of each pixel on this elevation
[range, elev] = ground2slant(s, z);

end


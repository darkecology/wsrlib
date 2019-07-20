function [ x, y, z ] = radar2xyz( range, az, elev )
%RADAR2XYZ Convert (range, az, elev) to (x, y, z)

[ground_range, z] = slant2ground(range, elev);
phi = cmp2pol(az);
[x, y] = pol2cart(phi, ground_range);

end


function [ s, h ] = slant2ground( r, thet )
%SLANT2GROUND Convert from slant range and elevation to ground range and height.
%
% [ s, h ] = slant2ground( thet, r )
%
% Input:
%   r    - range along radar path
%   thet - elevation angle in degrees
% Output:  
%   s    - range along ground (great circle distance)
%   h    - height above earth 
%
% Uses spherical earth with radius 6371.2 km
%
% From Doviak and Zrnic 1993 Eqs. (2.28b) and (2.28c)
% 
% See also
% https://bitbucket.org/deeplycloudy/lmatools/src/3ad332f9171e/coordinateSystems.py?at=default
%

earth_radius = 6371200; % from NARR GRIB file
multiplier = 4/3;

r_e = earth_radius * multiplier; % earth effective radius

thet = deg2rad(thet);

h = sqrt(r.^2 + r_e^2 + (2 * r_e * r .* sin(thet))) - r_e;
s = r_e * asin( r .* cos(thet) ./ ( r_e + h ) );

end

function [ r, thet ] = ground2slant( s, h )
%GROUND2SLANT Convert from slant range and elevation to ground range and height.
%
% [ r, thet ] = ground2slant( s, h )
%
% Input:
%   s    - range along ground (great circle distance)
%   h    - height above earth 
% Output:  
%   r    - range along radar path
%   thet - elevation angle in degrees
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

% Law of cosines of triangle ABC
%
%   A = center of earth
%   B = radar station
%   C = pulse volume
%  
% d(A,B) = r_e
% d(B,C) = r
% d(A,C) = r_e + h
% thet(AB,AC) = s/r_e
%

r  = sqrt(r_e^2 + (r_e+h).^2 - 2*(r_e+h).*r_e.*cos(s/r_e));
thet = acos((r_e + h) .* sin(s/r_e) ./ r);
thet = real(thet);
thet = rad2deg(thet);


end

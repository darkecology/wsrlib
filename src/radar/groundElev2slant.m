function [ r, h ] = groundElev2slant( s, thet )
%GROUNDELEV2SLANT Convert from slant range and elevation angle to ground range and height.
%
% [ r, h ] = groundElev2slant( s, thet )
%
% Input:
%   s    - range along ground (great circle distance)
%   thet - elevation angle in degrees
% Output:  
%   r    - range along radar path
%   h    - height above earth 
%
% Uses spherical earth with radius 6371.2 km
%
% Based on RSL_get_slantr_and_h
%
% See alo Doviak and Zrnic 1993 Eqs. (2.28b) and (2.28c)
% 

earth_radius = 6371200; % from NARR GRIB file
multiplier = 4/3;
r_e = earth_radius * multiplier; % earth effective radius

% Law of sines of triangle ABC
%
%   A = center of earth
%   B = radar station
%   C = pulse volume
%  
% gamma := angle(AB,AC) = s/r_e              
% alpha := angle(BA,BC) = 90 + thet          
% beta  := angle(CB,CA) = pi - alpha - gamma 
%
% Law of sines says:
%   r_e/sin(beta) = (r_e + h)/sin(alpha) = r/sin(gamma)
%
% We know r_e, so we can solve for (r_e + h) and r
%

gamma = s./r_e;
alpha = deg2rad(90+thet);
beta = pi() - alpha - gamma;

r = r_e * (sin(gamma)./sin(beta));
h = r_e * (sin(alpha)./sin(beta)) - r_e;

end

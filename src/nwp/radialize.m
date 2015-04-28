function [ vel ] = radialize( az, elev, u, v )
%RADIALIZE Radialize a velocity field
%
%  vel = radialize(az, u, v)
%
% Inputs (should be same size or scalars)
%   az     azimuth as a compass bearing (degrees clockwise from north)
%   elev   elevation angle in degrees
%   u      east-west wind component
%   v      north-south wind component 
%
% Output
%   vel    radial velocity
%

az = cmp2pol(az);
elev = deg2rad(elev);
vel = cos(az).*cos(elev).*u + sin(az).*cos(elev).*v;

end

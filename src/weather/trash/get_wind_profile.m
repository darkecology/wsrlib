function [u, v, speed, direction, elev] = get_wind_profile(weathermodel, u_wind, v_wind, lon, lat, min_elev, max_elev)
%NARR_WIND_PROFILE Get weather model vertical wind profile for specified location
%
%  [u, v, speed, direction, elev] = 
%     get_wind_profile( weathermodel, u_wind, v_wind, lon, lat, min_elev, max_elev )
%
% Inputs:
%   weathermodel        Weather model struct (for coordinate conversions)
%   u_wind, v_wind      3D wind matrices from weather model
%   lon, lat            location for profile
%   min_elev, max_elev  Starting and ending elevations 
%
% Outputs:
%   u            East-west wind component
%   v            North-south wind component
%   speed        Wind speed (m/s)
%   direction    Wind direction (degrees from north; direction blowing TO)
%   elev         Elevation in meters
% 
% Each output is an n x 1 vector where the ith entry corresponds to the ith
% pressure level, starting from the pressure level closest to min_elev
% and ending at the pressure level closest to max_elev. The values of the
% output vectors give the measurement at the 3D grid point at that 
% pressure level and closest to lat/lon in the horizontal plane.
% 

if nargin < 3
    error('First three arguments (weathermodel, u_wind and v_wind) are required');    
end

if nargin < 4
    error('Arguments lon and lat are required');
end

if nargin < 6
    min_elev = 0;
end

if nargin < 7
    max_elev = realmax();
end

% TODO: replace narr_... by calls to weather_model struct...
% get the coordinates for the radar station
[x, y] = weathermodel.ll2xy(lon, lat);
[i, j] = weathermodel.xy2ij(x, y);

%create height bins (translate heights to indices)
start_bin = weathermodel.height2level(min_elev);
end_bin   = weathermodel.height2level(max_elev);
levels    = (start_bin:end_bin)';

%compute the wind velocity at each bin
u = u_wind(levels, i, j);
v = v_wind(levels, i, j);

[theta, radius] = cart2pol(u, v);
direction = pol2cmp(theta);
speed = radius;
elev = weathermodel.level2height(levels);

end
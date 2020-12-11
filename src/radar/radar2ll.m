function [LON, LAT, Z] = radar2ll(radar_lon, radar_lat, R, PHI, ELEV)
% RADAR2LL Convert from radar coordinates to lat/lon coordinates
% 
% [LON, LAT, Z] = radar2ll(radar_lon, radar_lat, R, PHI, THET)
%
% Inputs:
%   radar_lon      Longitude of radar station
%   radar_lat      Latitude of radar station
%   R              Array of range values (NB: slant range, not ground)
%   PHI            Array of azimuth values
%   ELEV           Array of elevation angle values
%
% Outputs:
%   LON            Array of longitude values for each location / pixel
%   LAT            Array of latitude values for each location / pixel
%   Z              Array of height values for each location / pixel

if isscalar(radar_lon)
    radar_lon = repmat(radar_lon, size(R));
    radar_lat = repmat(radar_lat, size(R));
end

[R_ground, Z] = slant2ground(R, ELEV);
[LON, LAT] = m_fdist(radar_lon, radar_lat, PHI, R_ground);
LON = do_alias(LON, 180);

end

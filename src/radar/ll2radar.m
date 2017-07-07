function [R, PHI, THET] = ll2radar(radar_lon, radar_lat, LON, LAT, Z)
% LL2RADAR Convert from lat/lon coordinates to radar coordinates
% 
% [R, PHI, THET] = ll2radar(radar_lon, radar_lat, LON, LAT, Z)
%
% Inputs:
%   radar_lon      Longitude of radar station
%   radar_lat      Latitude of radar station
%   LON            Array of longitude values for each location / pixel
%   LAT            Array of latitude values for each location / pixel
%   Z              Array of height values for each location / pixel (optional)
%
% Outputs:
%   R              Array of range values
%   PHI            Array of azimuth values
%   ELEV           Array of elevation angle values (only set if Z is
%                  supplied)

[R, PHI] = m_idist(radar_lon, radar_lat, LON, LAT);
PHI(PHI > 360) = PHI(PHI > 360) - 360;
PHI(PHI < 0  ) = PHI(PHI < 0  ) + 360;

if nargin >= 5 && nargout >=3 
    [~, THET] = ground2slant(R, Z);
end

end

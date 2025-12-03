function station_info = nexrad_station_info()
%NEXRAD_STATION_INFO Get NEXRAD station information.
%
% station_info = nexrad_station_info()
%
% station_info is a struct array with these fields:
%
%     callsign
%     ncdcid
%     wban
%     name
%     country
%     st
%     county
%     lat
%     lon
%     elev
%     utc
%     stntype
%     tz
%
% The underlying data is downloaded from a NOAA source:
%   https://www.ncdc.noaa.gov/homr/file/nexrad-stations.txt
%
% Then it is processed to remove some stations with scant or transient
% data, and add one station (KJAN) that has data in the archive but
% was replaced in 2004. The script is here:
%
%   https://github.com/darkecology/cajun/tree/clutter/aws

filename = sprintf('%s/data/nexrad-stations.csv', wsrlib_root());
station_info = csv2struct(filename);
end


function stations = nexrad_stations()
%NEXRAD_STATIONS Return list of NEXRAD station ids
%
% stations = nexrad_stations()
%
% stations is a cell array with the station ids (e.g. 'KDOX')
station_info = nexrad_station_info();
stations = {station_info.callsign};
end


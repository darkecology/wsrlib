% RSL2MAT Ingest a radar file
%
%  radar = rsl2mat(filename, callid)
%  radar = rsl2mat(filename, callid, params)
% 
%    filename           radar file
%    callid             callsign, e.g., KDOX
%    params             optional struct to specify additional parameters
% 
%  Additional parameters:
%  
%    params.cartesian   if 1, return sweep in cartesian coordinates,
%                       otherwise return raw data (polar coordinates)
%                       (default: 0)
%  
%    params.nsweeps     max number of sweeps to return, starting with 
%                       lowest elevation angle (default: inf)
% 
%    paramx.max_elev    don't return sweeps with elevation angle exceeding
%                       this value (default: inf)
%
%    params.cappi_h     if this parameter is set to a value > 0.0, a 
%                       cappi (constant altitude plan position indicator)
%                       is create at the specified height (in km)
%                       (default 0)
%
%  If cartesian is selected the following parameters apply:
% 
%    params.range       maximum radius in km for cartesian data 
%                       (default: 150km)
%
%    params.dim         pixel dimension for cartesian data (n x n)
%                       (default: 600)
%  
%  The returned struct has the following metadata fields:
% 
%    radar.station    station call sign, e.g. KDOX
%    radar.year       e.g. 2010
%    radar.month      (1-12)
%    radar.day        (1-31)
%    radar.hour       (0-23)
%    radar.minute     (0-59)
%    radar.second     includes fractional part (0.0 - 59.999999)
%    radar.lat        decimal latitude of site
%    radar.lon        decimal longitude of site
%    radar.height     height of site in meters above sea level
%    radar.spulse     length of short pulse
%    radar.lpulse     length of long pulse
%    radar.vcp        volume coverage pattern
%    radar.constants  some constants
%    radar.params     copy of params struct
% 
%  It has the following data fields. Each is a struct of type
%  'volume'.
% 
%    radar.dz         reflectivity
%    radar.vr         radial velocity
%    radar.sw         spectrum width
%    radar.cappi      populated only if params.cappi_h > 0.0
%
%  A volume struct has the following fields
% 
%    volume.type      one of 'DZ', 'VR', or 'SW'
%    volume.sweeps    vector of sweeps
% 
%  A sweep struct has the following (and more) fields:
%  
%    sweep.elev            mean elevation angle for the sweep
%    sweep.beam_width       
%    sweep.vert_half_bw     
%    sweep.horz_half_bw
%    sweep.data            an array containing the data in either polar
%                          or cartesian coordinates, depending on params
%

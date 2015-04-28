function old_proj = nam_set_proj( )
%NAM_SET_PROJ Set m_map to use the NAM projection

% The details of the projection are given here:
%  http://www.nco.ncep.noaa.gov/pmb/docs/on388/tableb.html#GRID218
%
% In short, it is a Lambert conformal conic projection, with 
%  - Central latitude = -95
%  - Standard parallel 1 = Standard parallel 2 = 25.0
%
% The lat/lon limits set below do not matter so much to the projection,
% but are big enough to include the entire NAM grid

global MAP_PROJECTION MAP_VAR_LIST MAP_COORDS

old_proj.MAP_PROJECTION = MAP_PROJECTION;
old_proj.MAP_VAR_LIST = MAP_VAR_LIST;
old_proj.MAP_COORDS = MAP_COORDS;

m_proj('lambert', 'long', [-152.90 -49.30], 'lat', [12 62], 'clo', -95, 'par', [25.0 25.0]);

end


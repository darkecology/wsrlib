function old_proj = narr_set_proj( )
%NARR_SET_PROJ Set m_map to use the NARR projection

% The details of the projection are given here:
%  http://www.nco.ncep.noaa.gov/pmb/docs/on388/tableb.html#GRID221
%
% In short, it is a Lambert conformal conic projection, with 
%  - Central latitude = -107
%  - Standard parallel 1 = Standard parallel 2 = 50
%
% The lat/lon limits set below do not matter so much to the projection,
% but are big enough to include the entire NARR grid


global MAP_PROJECTION MAP_VAR_LIST MAP_COORDS

old_proj.MAP_PROJECTION = MAP_PROJECTION;
old_proj.MAP_VAR_LIST = MAP_VAR_LIST;
old_proj.MAP_COORDS = MAP_COORDS;

m_proj('lambert', 'long', [-234 20], 'lat', [0 100], 'clo', -107, 'par', [50 50]);

end


function [lon,lat]=merc2ll(x,y);
%LL2MERC Converts lon,lat to Mercator
% Usage: [lon,lat]=merc2ll(x,y);
% rsignell@usgs.gov
earth_radius=6371.e3
m_proj('mercator');
[lon,lat]=m_xy2ll(x/earth_radius,y/earth_radius);

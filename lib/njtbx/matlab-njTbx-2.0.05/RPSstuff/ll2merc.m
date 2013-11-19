function [x,y]=ll2merc(lon,lat);
earth_radius=6371.e3
m_proj('mercator');
[x,y]=m_ll2xy(lon,lat);
x=x*earth_radius;   % convert mercator to meters
y=y*earth_radius;   % convert mercator to meters

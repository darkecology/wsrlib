function [x,y]=ll2utm(lon,lat,zone);
% LL2UTM convert lat,lon to UTM
%   Usage: [x,y]=ll2utm(lon,lat,zone);
m_proj('UTM','ellipsoid','wgs84','zone',zone);
[x,y]=m_ll2xy(lon,lat,'clip','off');

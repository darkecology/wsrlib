function [ lon, lat ] = nam_xy2ll( x, y )
%NAM_XY2LL Convert from NAM x,y coordinates to lon,lat

old_proj = nam_set_proj();

[lon, lat] = m_xy2ll(x, y);
lon(lon < -180) = lon(lon < -180) + 360;

nam_reset_proj(old_proj);

end

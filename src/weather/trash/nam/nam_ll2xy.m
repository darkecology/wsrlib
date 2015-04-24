function [ x, y ] = nam_ll2xy( lon, lat )
%NAM_LL2XY Convert from lon, lat to NAM x,y coordinates

old_proj = nam_set_proj();

lon(lon > 0) = lon(lon > 0) - 360;
[x, y] = m_ll2xy(lon, lat);

nam_reset_proj(old_proj);

end

function [ x, y ] = narr_ll2xy( lon, lat )
%NARR_LL2XY Convert from lon, lat to NARR x,y coordinates

old_proj = narr_set_proj();

lon(lon > 0) = lon(lon > 0) - 360;
[x, y] = m_ll2xy(lon, lat);

narr_reset_proj(old_proj);

end

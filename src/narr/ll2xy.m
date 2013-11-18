function [ x, y ] = ll2xy( lon, lat )
% LL2XY Convert from lon, lat to NARR x,y coordinates

old_proj = set_narr_proj();

lon(lon > 0) = lon(lon > 0) - 360;
[x, y] = m_ll2xy(lon, lat);

reset_proj(old_proj);

end

function nam_reset_proj( proj )
%NAM_RESET_PROJ Reset map projection cached value

global MAP_PROJECTION MAP_VAR_LIST MAP_COORDS

MAP_PROJECTION = proj.MAP_PROJECTION;
MAP_VAR_LIST = proj.MAP_VAR_LIST;
MAP_COORDS = proj.MAP_COORDS;

end


function [ind, cmap, bg] = fix_nan(bgcolor, ind, cmap)
  
  bg   = isnan(ind);
  cmap = [bgcolor; cmap];
  ind = ind+1;
  ind(bg) = 1;			% map nan to first color

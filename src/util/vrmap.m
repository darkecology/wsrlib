function cmap = vrmap(n)
% VRMAP Basic colormap for radial velocity

  darkgreen = [ 0 .5  0];
  darkred   = [.5  0  0];  
  white     = [ 1  1  1];
  
  lightgreen = 0.75*darkgreen + 0.25*white;
  lightred   = 0.75*darkred   + 0.25*white;

  colors = [darkgreen
	    lightgreen
	    white
	    lightred
	    darkred];
  
  splits = [0
	    3/8
	    1/2
	    5/8
	    1];
  
  % perform linear interpolation between the above colors
  cmap = cmap_interpolate(colors, splits, n);

function opt = displayopts(n)
%
%  opt = displayopts()
%
%  Returns a struct with the default display options for radar data
%
%  opt.dzlim = [0, 30];
%  opt.vrlim = [-20, 20];
%  opt.swlim = [0, 10];
%  opt.dzthresh = 5;
%  opt.vrmap = vrmap(128)

  if nargin < 1
    n = 32;
  end
  
  % scaling
  opt.dzlim = [5, 30];
  opt.vrlim = [-20, 20];
  opt.swlim = [0, 10];
  
  % colormaps
  opt.dzmap = jet(n);
  opt.vrmap = vrmap(n);
  opt.swmap = jet(n);

  % color for NaN
  opt.dzbgcolor = [0 0 0];
  opt.vrbgcolor = [0 0 0];
  opt.swbgcolor = [0 0 0];
  
  % default values for real-valued images
  opt.dzdefault = 0;
  opt.vrdefault = 0;
  opt.swdefault = 0;
  
  % dz threshold used to mask vr and sw
  opt.dzthresh = 5;
    
  % units
  opt.dzunits = 'dBZ';
  opt.vrunits = 'm/s';
  opt.swunits = '(m/s)^2';
  
  % labels
  opt.dzlabel = 'Reflectivity';
  opt.vrlabel = 'Radial Velocity';
  opt.swlabel = 'Spectrum Width';

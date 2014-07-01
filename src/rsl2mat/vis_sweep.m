function vis_sweep(sweep, inopt)
%
% vis_sweep(sweep)
%

  opt = displayopts;
  
  if nargin >= 2
    opt = getopt(opt, inopt);
  end
  
  mask = ones(size(sweep.dz));
  mask(sweep.dz < opt.dzthresh) = nan;
  
  figure() 
  colormap(opt.dzmap)
  imagesc_nan(opt.dzbgcolor, sweep.dz, opt.dzlim);
  title(opt.dzlabel);
  h = colorbar();
  xlabel(h, opt.dzunits);
  
  figure() 
  colormap(opt.vrmap)
  imagesc_nan(opt.vrbgcolor, sweep.vr.*mask, opt.vrlim);
  title(opt.vrlabel);
  h = colorbar();
  xlabel(h, opt.vrunits);
  
  figure() 
  colormap(opt.swmap)
  imagesc_nan(opt.swbgcolor, sweep.sw.*mask, opt.swlim);
  title(opt.swlabel);
  h = colorbar();
  xlabel(h, opt.swunits);
  
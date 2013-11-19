function sweep = sweep2ind(sweep, inopt)
%
% sweep = sweep2im(sweep, opts)
% 

  opt = displayopts();
  if nargin >= 2
    opt = getopt(opt, inopt);
  end
  
  mask = (sweep.dz >= opt.dzthresh);
  
  sweep.dz = mat2ind(sweep.dz, opt.dzlim, opt.dzmap);
  sweep.dzmap = opt.dzmap;
  
  sweep.vr = mat2ind(sweep.vr.*mask, opt.vrlim, opt.vrmap);
  sweep.vrmap = opt.vrmap;
  
  sweep.sw = mat2ind(sweep.sw.*mask, opt.swlim, opt.swmap);
  sweep.swmap = opt.swmap;


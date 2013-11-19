function sweep = sweep2im(sweep, inopt)
%
% sweep = sweep2im(sweep, opts)
% 

  opt = displayopts();
  if nargin >= 2
    getopt(opt, inopt);
  end

  sweep.dz(isnan(sweep.dz)) = opt.dzlim(1);
  sweep.vr(isnan(sweep.vr)) = opt.vrdefault;
  sweep.sw(isnan(sweep.sw)) = opt.swdefault;
  
  mask = (sweep.dz >= opt.dzthresh);

  sweep.dz = mat2gray(sweep.dz, opt.dzlim);
  sweep.vr = mat2gray(sweep.vr.*mask, opt.vrlim);
  sweep.sw = mat2gray(sweep.sw.*mask, opt.swlim);

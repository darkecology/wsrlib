function imwrite_gif_nan(im, cmap, filename)
% IMWRITE_GIF_NAN Write indexed image as gif with nan --> transparent 

  cmap = [0 0 0;
	  cmap];
  im = im+1;
  
  if isinteger(im)
    firstidx = 0;
  else
    firstidx = 1;
  end
  
  im(isnan(im)) = firstidx;
  imwrite(im, cmap, filename, 'gif', 'TransparentColor', firstidx);

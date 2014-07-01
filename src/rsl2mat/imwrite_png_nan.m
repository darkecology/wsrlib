function imwrite_png_nan(im, cmap, filename)
  
  cmap = [0 0 0;
	  cmap];
  im = im+1;
  
  if isinteger(im)
    firstidx = 0;
  else
    firstidx = 1;
  end
  
  im(isnan(im)) = firstidx;
  imwrite(im, cmap, filename, 'png', 'TransparentColor', firstidx);


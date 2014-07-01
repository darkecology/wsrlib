function h = imagesc_nan(bgcolor, im, varargin)
% h = imagesc_nan(bgcolor, im, ...)
%
% Like imagesc, but renders all nan values in specified color.
%
%  - bgcolor: rgb values for background (nan) color
%  - im:      image to be rendered
%  - any remaining args are passed directly to imagesc 

  cmap = [bgcolor
	  colormap()];
  
  bg = isnan(im);
  im(bg) = -Inf;
  colormap(cmap);
  h = imagesc(im, varargin{:});

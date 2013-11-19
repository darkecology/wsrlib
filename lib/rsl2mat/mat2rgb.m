function [rgb, bg] = mat2rgb(A, lim, cmap, bgcolor)
%
% [rgb, bg] = mat2rgb(A, lim, cmap, bgcolor)
%
% Converts matrix to rgb image by scaling and then indexing into
% a specified colormap.
%
%  - A is the input matrix
%  - lim specifies the range for scaling (default is min/max of A)
%  - cmap is the colormap (default: jet(128))
%  - bgcolor specifies the color for NaN entries (default: black)
%
% The output argument rgb is the image, and bg is a logical matrix
% the same size as A that indicates which pixels were mapped to 
% the background (ie: isnan(A))

  if nargin < 2
    lim = [min(A(:)), max(A(:))];
  end
  
  if nargin < 3
    cmap = jet(128);
  end
  
  if nargin < 4
    bgcolor = [0 0 0];
  end

  ind = mat2ind(A, lim, cmap);
  [ind, cmap] = fix_nan(bgcolor, ind, cmap);  
  rgb = ind2rgb(ind, cmap);

  
  
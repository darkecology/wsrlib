function [ind, cmap, clim, ctick, edges] = mat2ind(img, lim, cmap, tick, bgmask, bgcolor)
% MAT2IND: convert from real-valued matrix to indexed image
%
% [ind, cmap, clim, ctick, edges] = mat2ind(img, lim, cmap, tick, bgmask, bgcolor)
%
% INPUTS
%
%  img      Numeric array
%
%  lim      Two-element vector specifying the range of values in img to be
%           mapped to colors. Anything below lim(1) is mappped to first
%           color in colormap. Anything above lim(2) is mapped to final
%           color. (Default: use min/max entries of img(:))
%
%  cmap     color map (Default: jet(128))
%
%  tick     (Optional) Set of tick labels in original units. These will be
%           mapped to color map indices for the purpose of labeling the
%           colorbar in a figure.
%
%  bgmask   Optional background mask(s). It is a cell array. Each entry is
%           a logical matrix of the same size as img that specifies pixels
%           to be colored a special color.
%
%  bgcolor  Background colors. Pixels that match bgmask{i} are colored
%           bgcolor{i}
%
% OUTPUTS
% 
%  ind      The indexed image. It is a double array whose values are 
%           integers between 1 and length(cmap)
%
%  cmap     Modified cmap (includes background colors)
%
%  clim     Gives numeric range of non-background colors. Use this to omit
%           background colors from a color bar.
%
%  ctick    The result of mapping the input argument tick to the indexed
%           color range.
%
%  edges    The numeric ranges of the color map
%

if nargin < 2
    lim = [min(img(:)), max(img(:))];
end

if nargin < 3
    cmap = jet(128);
end

if nargin < 4
    tick = linspace(lim(1), lim(2), 5);
end

if nargin < 5
    bgmask = {};
    bgcolor = {};
end

[ncolors,n] = size(cmap);

edges = linspace(lim(1), lim(2), ncolors+1);
[~,ind] = histc(img, edges);

% Preserve NaN values
ind(isnan(img)) = nan;

% Map values outside of limits to ends of colormap
ind(img < lim(1)) = 1;
ind(img >= lim(2)) = ncolors;

% Map values equal to upper limit to last bin
ind(ind == ncolors+1) = ncolors;

ctick = ncolors*(tick - lim(1))/(lim(2)-lim(1)) + 0.5;

clim = [0.5 ncolors+0.5];

for i=1:length(bgmask)
   ncolors = ncolors + 1;
   cmap = [cmap; bgcolor{i}];
   ind(bgmask{i}) = ncolors;   
end

function [ h ] = imagescnan( varargin )
%IMAGESCNAN Display a scaled image but treat NaN as transparent

if nargin < 3
    im = varargin{1};
else
    im = varargin{3};
end

h = imagesc(varargin{:});
set(h, 'alphadata', ~isnan(im));

end


function ims = preprocessScan(data, opts)
% PREPROCESSSCAN Preprocess rendered scan for segmentation
%
% ims = preprocessScan(data, opts)
      
rgb = cellfun(@(x) single(data.(x)(:,:,opts.sweep)), opts.mode, ...
            'UniformOutput', false);
rgb = arrayfun(@(x) replaceNan(rgb{x}, opts.nan_map(opts.mode{x})), ...
            1:numel(opts.mode), 'UniformOutput', false);

rgb = cat(3, rgb{:});

ims = resizeRadar(rgb, opts.crop, opts.imageSize, opts.coordinate);
if ~isempty(opts.rgbMean)
  ims = bsxfun(@minus, rgb, reshape(opts.rgbMean, 1, 1, size(rgb, 3))) ;
end
if ~isempty(opts.padto)
  temp = ims;
  ims = repmat(reshape(opts.rgbMean, ...
      [1,1,numel(opts.mode)*numel(opts.sweep)]), ...
      opts.padto(1), opts.padto(2), 1);

  [h1, w1, ~] = size(temp);

  ty = round((1:h1) - h1/2 + opts.padto(1)/2) ;
  tx = round((1:w1) - w1/2 + opts.padto(2)/2) ;

  ims(ty, tx, :) = temp;
end

end

function ims = resizeRadar(rgb, crop, imageSize, coordinate)  
  % crop the inputnet.meta.normalization.rgbMean
  if ~isempty(crop)
      h = size(rgb, 1);
      w = size(rgb, 2);
      cx = floor(max((w - crop(2)) / 2, 1));
      if strcmp(coordinate, 'polar')
          cy = 1;
      else
          cy = floor(max((h - crop(1)) / 2, 1));
      end
      rgb = rgb(cy:cy+crop(1)-1, cx:cx+crop(2)-1, :);
  end
  

  % scale & flip
  h = size(rgb,1) ;
  w = size(rgb,2) ;
  
  sz = imageSize(1:2) ;
  
  sy = round(((1:sz(1)) - sz(1)/2) + h/2) ;
  sx = round(((1:sz(2)) - sz(2)/2) + w/2) ;
  
  okx = find(1 <= sx & sx <= w) ;
  oky = find(1 <= sy & sy <= h) ;
  
  ims = zeros(sz(1), sz(2), size(rgb, 3), 'single');
  
  ims(oky,okx,:) = rgb(sy(oky),sx(okx),:) ;
end


function A = replaceNan(A, nanvalue)
    A(isnan(A)) = nanvalue;
end
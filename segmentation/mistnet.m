function [ PREDS, PROBS, classes, y, x, elevs ] = mistnet( radar, varargin )
% SEGMENT_SCAN Run segmentation net to segment the scan
%
% [ PREDS, x, y, probs, labels ] = segment_scan( radar, net, ... )
%
% Required inputs:
%    radar            The radar struct (from rsl2mat)
%
% Outputs:
%    PREDS            3D array with predicted pixel labels (n x n x 5)
%    PROBS            4D array with class probabilities (n x n x 5 x #classes)
%    classes          struct mapping class names to ids
%    x                vector of x coordinates (n x 1)
%    y                vector of y coordinates (n x 1)
%    elevs            vector of elevation angles (5 x 1)
%
% Optional named inputs:
%
%    net_path         Path to model file (default is mistnet model
%                     distributed with wsrlib). The net is loaded only on
%                     the first call to mistnet() and then saved in memory.
%                     Loading the net takes a couple seconds.
%
%    net              A DagNN object. If set, this object will be used 
%                     instead of loading the net from file.
%
%    gpu_device       Set to use GPU (default: []) (gpu code untested)
%
%    rain_thresh      Classify as rain if pixel rain probability exceeds 
%                     this value (default: 0.5)
%
%    avg_rain_thresh  Classify as rain if average probability over all
%                     elevations at same spatial location as pixel 
%                     exceeds this value (default: 0.45)
%
%    avg_rain_thresh  Same as above, but max over elevations (default: 1.0)
%
%    dilate_radius    Build a fringe of this many pixels around pixels 
%                     classified as rain to also classify as rain
%                     (default: 8)
%
%    dilate_thresh    The rain probability of the fringe pixel must be at
%                     least this high to be classified as rain 
%                     (default: 0.20)
%
%    ydirection       'xy' | 'ij'. This specifies whether the y coordinates 
%                     of pixels are decreasing ('ij') or increasing ('xy') 
%                     along the first dimension of the array. The default
%                     is 'xy', which makes the output compatible with
%                     griddedInterpolant.
%
% Note: GPU code untested

DEFAULT_NET_PATH = sprintf('%s/cnn/mistnet.mat', cajun_root());

p = inputParser;

addRequired(p, 'radar',    @isstruct);

addParameter(p, 'gpu_device',          []            );
addParameter(p, 'rain_thresh',       0.50,  @isscalar);
addParameter(p, 'avg_rain_thresh',   0.45,  @isscalar);
addParameter(p, 'max_rain_thresh',   1.00,  @isscalar);
addParameter(p, 'dilate_thresh',     0.20,  @isscalar);
addParameter(p, 'dilate_radius',        8,  @isscalar);
addParameter(p, 'ydirection',        'xy',  @(x) any(validatestring(x,{'ij','xy'})));

addParameter(p, 'net_path',   DEFAULT_NET_PATH,  @isstring);
addParameter(p, 'net',                      [],  @(x) isempty(x) || isa(x, 'dagnn.DagNN'));

parse(p, radar, varargin{:});

params = p.Results;

% LOAD NET
persistent saved_net;
persistent saved_net_path;

if ~isempty(params.net)
    % Use the network that was passed in
    net = params.net;
else 
    % Use network from file
    if params.net_path
        net_path = params.net_path;
    else
        net_path = sprintf('%s/cnn/mistnet.mat', cajun_root());
    end
    
    % Check if net is already loaded into memory
    if ~isempty(saved_net) && strcmp(saved_net_path, net_path)
        net = saved_net;
    else
        net = load_net(net_path, params.gpu_device);
        saved_net = net;
        saved_net_path = net_path;
    end
end

% extract class labels from net
classes = struct();
for i = 1:numel(net.meta.classes)
    classes.(net.meta.classes{i}) = i;
end
%remove in future when clutter gets predicted
classes.clutter = 4;

% Rendering parameters
elevs = 0.5:4.5; 
grid_params = {
    'coords', net.meta.bopts.coordinate, ...
    'dim', net.meta.bopts.imageSize(1),...
    'r_max', 150000,...
    'elevs', elevs, ...
    'ydirection', 'ij'};  % NOTE: model was trained with 'ij' direction, so 
                          % use this even though the default in WSRLIB is
                          % 'xy'

% Render the scan for prediction
[data, y, x] = radar2mat(radar, 'fields', net.meta.bopts.mode, grid_params{:});

% Get the dz data for ground-truth background
if ismember('dz', fieldnames(data))
    dz = data.dz;
else
    dz = radar2mat(radar, 'fields', {'dz'}, grid_params{:});
    dz = dz.dz;
end
bg = isnan(dz);               
                     
% Preprocess (add padding, etc.)
IMG_padded = preprocess(data, net.meta.bopts);

% Move the input to gpu
if ~isempty(params.gpu_device)
    IMG_padded = gpuArray(IMG_padded);
end

% Do forward passing to get the prediction
net.mode = 'test';
net.eval({'input', IMG_padded});

% Get class probabilities
PROBS = arrayfun(@(layer) net.getVar(strcat('prob_', int2str(layer))).value, ...
                    net.meta.bopts.output_sweep, ...
                    'UniformOutput', false);

PROBS = cat(4, PROBS{:});

% Get class with highest probability that is not background
bg_ind = find(strcmp(net.meta.classes, 'background'));
probs_no_background = PROBS;
probs_no_background(:,:,bg_ind,:) = 0; %#ok<FNDSB>    

[~, PREDS] = max(probs_no_background, [], 3);
PREDS = squeeze(PREDS);

% remove the padding
ty = floor((1:size(PREDS,1)) - net.meta.bopts.padto(1)/2 + net.meta.bopts.imageSize(1)/2);
tx = floor((1:size(PREDS,2)) - net.meta.bopts.padto(2)/2 + net.meta.bopts.imageSize(2)/2);
ty = ty > 0 & ty <= net.meta.bopts.imageSize(1);
tx = tx > 0 & tx <= net.meta.bopts.imageSize(2);

PREDS = PREDS(ty, tx, :);
PROBS = PROBS(ty, tx, :, :);

% Postprocess (use original probabilities including background for this)
[PROBS, PREDS] = postprocess(PROBS, PREDS, net.meta.classes, params);

% Now set all ground truth background pixels
PREDS(bg) = find(strcmp(net.meta.classes, 'background'));

switch params.ydirection
    case 'xy'
        % Flip order of y dimension so y coordinates are increasing
        % (output is compatible with griddedInterpolant)
        y = flip(y);
        PREDS = flip(PREDS, 1);
        PROBS = flip(PROBS, 1);
    case 'ij'
        % do nothing
    otherwise
        % should not get here
        error('Unrecognized y direction');
end
end

function [probs, SEG_MASK] = postprocess(probs, SEG_MASK, classes, params)

    rain_ind = find(strcmp(classes, 'rain'));
    rain_prob = squeeze(probs(:,:,rain_ind,:));
    
    avg_rain_prob = sum(rain_prob,3)/size(rain_prob,3);
    max_rain_prob = max(rain_prob,[], 3);
    
%     rain_thresh = 0.5;
%     avg_rain_thresh = 0.45;
%     max_rain_thresh = 1.0;
% 
%     dilate_thresh = 0.2;
%     dilate_radius = 8;
    
%     vis = false;
%     if vis
%         figure();
%         clf();
%         
%         subplot(1,3,1);
%         imagesc(avg_rain_prob, [0, 1]);
%         colorbar();
%         
%         subplot(1,3,2);
%         imagesc(max_rain_prob, [0, 1]);
%         colorbar();
%         
%         subplot(1,3,3);
%         imagesc(avg_rain_prob > 0.3 | max_rain_prob > 0.7);
%         colorbar();    
%     end
    
    avg_rain_prob = repmat(avg_rain_prob, [1, 1, 5]);
    max_rain_prob = repmat(max_rain_prob, [1, 1, 5]);
    is_rain = rain_prob > params.rain_thresh | ...
        avg_rain_prob > params.avg_rain_thresh | ...
        max_rain_prob > params.max_rain_thresh;
    
    dilated = imdilate(is_rain, circle_nbhd(params.dilate_radius));
    is_rain = is_rain | (dilated & rain_prob > params.dilate_thresh);

    SEG_MASK(is_rain) = rain_ind;
end

function [ nbhd ] = circle_nbhd( radius )
%CIRCLE_NBHD Generate a circle neighborhood operator for image operations
%
% nbhd  = circle_nbhd( radius )
%

[Y,X] = meshgrid(-radius:radius, -radius:radius);
D = sqrt(Y.^2 + X.^2);
nbhd = D <= radius;

end

function ims = preprocess(data, opts)
% PREPROCESS Preprocess rendered scan for segmentation
%
% Convert to single, replace NaNs by default values, and pad
%
% This function has options (for resizing, etc.) that are not used in the
% current MistNet but were used in previous experiments with different
% architectures. It could be edited for simplicity (at the cost of some
% generality).

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



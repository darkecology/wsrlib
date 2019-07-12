function [ SEG_MASK, x, y, probs, labels ] = segment_scan( radar, net, RMAX, SEG_GPU_DEVICE, SEG_IMG_SIZE, elevs )
% SEGMENT_SCAN Run segmentation net to segment the scan
%
% [ SEG_MASK, x, y, probs, labels ] = segment_scan( radar, net, RMAX, SEG_GPU_DEVICE, SEG_IMG_SIZE, elevs )
%
% Inputs:
%    radar
%    net
%    RMAX
%    SEG_GPU_DEVICE
%    SEG_IMG_SIZE
%    elevs
%
% Outputs:
%    SEG_MASK
%    x
%    y
%    probs
%    labels
%
% Note: GPU code untested

% extract class labels from net?
labels = struct();
classes = net.meta.classes;
for i = 1:numel(classes)
    labels.(classes{i}) = i;
end
%remove in future when clutter gets predicted
labels.clutter = 4;

% Get the dz data for ground-truth background
dz = radar2mat(radar, ...
               'fields', {'dz'}, ...
               'elevs', elevs, ...
               'coords', 'cartesian', ...
               'dim', net.meta.bopts.imageSize(1));
dz = dz.dz;
bg = isnan(dz);

% Render the scan for prediction
[data, y, x] = radar2mat(radar, ...
                         'fields', net.meta.bopts.mode, ...
                         'coords', net.meta.bopts.coordinate, ...
                         'elevs', elevs, ...
                         'dim',    net.meta.bopts.imageSize(1));

IMG_padded = preprocessScan(data, net.meta.bopts);

% Move the input to gpu
if ~isempty(SEG_GPU_DEVICE)
    IMG_padded = gpuArray(IMG_padded);
end

% Do forward passing to get the prediction
net.mode = 'test';
net.eval({'input', IMG_padded});

% Get class probabilities
probs = arrayfun(@(layer) net.getVar(strcat('prob_', int2str(layer))).value, ...
                    net.meta.bopts.output_sweep, ...
                    'UniformOutput', false);

probs = cat(4, probs{:});

% Get class with highest probability that is not background
bg_ind = find(strcmp(net.meta.classes, 'background'));
probs_no_background = probs;
probs_no_background(:,:,bg_ind,:) = 0; %#ok<FNDSB>    

[~, SEG_MASK] = max(probs_no_background, [], 3);
SEG_MASK = squeeze(SEG_MASK);

% remove the padding
ty = floor((1:size(SEG_MASK,1)) - net.meta.bopts.padto(1)/2 + net.meta.bopts.imageSize(1)/2);
tx = floor((1:size(SEG_MASK,2)) - net.meta.bopts.padto(2)/2 + net.meta.bopts.imageSize(2)/2);
ty = ty > 0 & ty <= net.meta.bopts.imageSize(1);
tx = tx > 0 & tx <= net.meta.bopts.imageSize(2);

SEG_MASK = SEG_MASK(ty, tx, :);
probs = probs(ty, tx, :, :);

% Postprocess (use original probabilities including background for this)
[probs, SEG_MASK] = postprocess(probs, SEG_MASK, net.meta.classes);

% Now set all ground truth background pixels
SEG_MASK(bg) = find(strcmp(net.meta.classes, 'background'));

end

function [probs, SEG_MASK] = postprocess(probs, SEG_MASK, classes)

    rain_ind = find(strcmp(classes, 'rain'));
    rain_prob = squeeze(probs(:,:,rain_ind,:));
    
    
    avg_rain_prob = sum(rain_prob,3)/size(rain_prob,3);
    max_rain_prob = max(rain_prob,[], 3);
    
    rain_thresh = 0.5;
    avg_rain_thresh = 0.45;
    max_rain_thresh = 1.0;

    dilate_thresh = 0.2;
    dilate_radius = 8;
    
    vis = false;
    if vis
        figure();
        clf();
        
        subplot(1,3,1);
        imagesc(avg_rain_prob, [0, 1]);
        colorbar();
        
        subplot(1,3,2);
        imagesc(max_rain_prob, [0, 1]);
        colorbar();
        
        subplot(1,3,3);
        imagesc(avg_rain_prob > 0.3 | max_rain_prob > 0.7);
        colorbar();    
    end
    
    avg_rain_prob = repmat(avg_rain_prob, [1, 1, 5]);
    max_rain_prob = repmat(max_rain_prob, [1, 1, 5]);
    is_rain = rain_prob > rain_thresh | avg_rain_prob > avg_rain_thresh | max_rain_prob > max_rain_thresh;
    
    dilated = imdilate(is_rain, circle_nbhd(dilate_radius));
    is_rain = is_rain | (dilated & rain_prob > dilate_thresh);

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

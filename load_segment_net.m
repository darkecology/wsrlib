function [ net ] = load_segment_net( seg_file, SEG_GPU_DEVICE )
%LOAG_SEG_NET Load segmentation net
%   net = load_seg_net( seg_file, SEG_GPU_DEVICE )
%
% Inputs:
%    seg_file        Location of .mat file
%    SEG_GPU_DEVICE  ID of GPU device, or [] if none

if nargin < 2
    SEG_GPU_DEVICE = [];
end

if ~isempty(SEG_GPU_DEVICE)
    gpuDevice(SEG_GPU_DEVICE)
end

% Load the segmenter
net = dagnn.DagNN.loadobj(seg_file); %#ok<NODEF>
for i=1:numel(net.vars)
    net.vars(i).precious = 0;
end
idx = net.getVarIndex('prediction');
if isinteger(idx) && idx >= 0
    net.vars(idx).precious = 1;
end

if ~isempty(SEG_GPU_DEVICE)
    net.move('gpu')
else
    net.move('cpu')
end



end


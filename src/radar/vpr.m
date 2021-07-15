function [ avg_z, cnt ] = vpr( dz, height, height_step, height_max)
%VPR Vertical profile of reflectivity
%
%  [avg_z, cnt] = vpr( dz, height, height_step, height_max)
%
% Compute vertical profile of reflectivity assigning sample volumes to bins
% based on their height and computing average of all non-nan reflectivity
% values (on linear scale) within bin.

if nargin < 3
    height_step = 100;
end

if nargin < 4
    height_max = 6000;
end

% Exclude NaN values here
inds = ~isnan(dz);
dz = dz(inds);
height = height(inds);

edges = (0:height_step:height_max)';

[cnt, bin] = histc(height, edges);
cnt = cnt(1:end-1);

nbins = length(edges)-1;

avg_z = nan(nbins, 1);

for i=1:nbins
    if cnt(i) == 0
        continue;
    end    
    bin_dz = dz(bin == i);
    bin_z  = idb(bin_dz);
    avg_z(i) = mean(bin_z);
end

end

function [ avg_z_trimmed, avg_z_med, cnt ] = vpr( dz, height, zstep, zmax, dz_max, trim_amt)
%VPR Vertical profile of reflectivity
%
% [ avg_z_trimmed, avg_z_med, cnt ] = vpr( dz, height, zstep, zmax, dz_max, trim_amt)
%


if nargin < 3
    zstep = 100;
end

if nargin < 4
    zmax = 6000;
end

if nargin < 5
    dz_max = 35;
end

if nargin < 6
    trim_amt = [0.25 0.25];
end

% Exclude NaN values here
inds = ~isnan(dz);
dz = dz(inds);
height = height(inds);

edges = (0:zstep:zmax)';

[cnt, bin] = histc(height, edges);
cnt = cnt(1:end-1);

nbins = length(edges)-1;

avg_z_trimmed = nan(nbins, 1);
avg_z_med = nan(nbins, 1);

for i=1:nbins
    
    if cnt(i) == 0
        continue;
    end
    
    bin_dz = dz(bin == i );
    bin_z  = idb(bin_dz);    

    n = numel(bin_dz);
    
    % AVERAGE Z
    %   1. Trim some fraction of values on left/right tails
    %   2. Average remaining Z values
    % (Following Buler and Diehl 2009)
    rnk = rank_order(bin_z);
    
    keep = rnk/n >= trim_amt(1) & ...
        rnk/n <= 1 - trim_amt(2) & ...
        bin_dz < dz_max;
    
    avg_z_trimmed(i) = mean(bin_z(keep));
    
    % "MEDIAN" Z
    %   1. Compute median a of nonzero Z values
    %   2. Approximate average as
    %       
    %      n1 * a / n
    %     
    %      where n1 is the number of nonzeros and n is the
    %      total number of pulse volumes.
    %
    %      (This is the same as assuming that all nonzero
    %       values are equal to the median of the nonzeros)
    %
    nz = bin_z > 0;
    num_nonzeros = nnz(nz);
    
    avg_z_med(i) = (num_nonzeros * median(bin_z(nz))) / n;
end

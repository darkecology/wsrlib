function [ thet_mean ] = circ_mean( thet, wt )
%CIRC_MEAN Compute mean direction

if nargin < 2
    wt = ones(size(thet));
end

u = cos(thet);
v = sin(thet);

u_mean = sum(wt.*u)/sum(wt);
v_mean = sum(wt.*v)/sum(wt);

thet_mean = cart2pol(u_mean, v_mean);

end


function [ y ] = rank_order( x )
%RANK_ORDER Compute rank order of entries in a vector
%
%  y = rank_order( x )
%
% y(i) = k --> x(i) is the kth largest item
%
% Ties are broken arbitrarily

n = length(x);
[~,perm] = sort(x);
y = zeros(n, 1);
y(perm) = (1:n)';

end


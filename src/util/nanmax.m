function [ y, I ] = nanmax( X, dim )
%NANMEAN Return mean of non-NaN elements

if nargin < 2
    dim = 1;
end

[y, I] = nanmin(-X, dim);
y = -y;

end


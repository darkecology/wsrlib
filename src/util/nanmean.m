function [ y ] = nanmean( X, dim )
%NANMEAN Return mean of non-NaN elements

if nargin < 2
    dim = 1;
end

valid = ~isnan(X);
X(~valid) = 0;

if isvector(X)
    y = sum(X)./sum(valid);
else
    y = sum(X, dim)./sum(valid, dim);
end

end


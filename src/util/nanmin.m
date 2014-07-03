function [ y, I ] = nanmin( X, dim )
%NANMIN Min of non-NaN elements

if nargin < 2
    dim = 1;
end

valid = ~isnan(X);

X(~valid) = inf;

if isvector(X)
    [y, I] = min(X);
else
    [y, I] = min(X, [], dim);
end

end


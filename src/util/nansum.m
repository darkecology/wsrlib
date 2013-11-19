function [ y ] = nansum( X, varargin )
%NANSUM Return sum of non-NaN elements

X(isnan(X)) = 0;
y = sum(X, varargin{:});

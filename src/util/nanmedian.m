function [ med ] = nanmedian( X )
%NANMEDIAN Compute median of non-NaN elements

med = median(X(~isnan(X)));

end
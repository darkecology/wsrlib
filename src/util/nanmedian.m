function [ med ] = nanmedian( varargin )
%NANMEDIAN Compute median of non-NaN elements

med = median(varargin{:}, 'omitnan');

end
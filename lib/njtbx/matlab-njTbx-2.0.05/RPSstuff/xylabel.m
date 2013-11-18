function theResult = xylabel(x, y, theLabels, theFormat, varargin)

% xylabel -- Label xy points with matrix values.
% xylabel(x, y, theLabels, theFormat, ...) labels the xy
%   points with the corresponding values in theLabels,
%   either an array of "double" or a cell-array of strings.
%   TheFormat (default = 4) is an integer or string that
%   is suitable for the "num2str" function.  Additional
%   arguments can be name/value pairs that are passed
%   to the "text" function. The "text" handles are returned.
 
% Copyright (C) 1997 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 13-Apr-1998 10:06:21.

if nargin < 1, help(mfilename), return, end
if nargin < 4, theFormat = 4; end

if isa(theLabels, 'double')
        labs = cell(size(theLabels));
        for k = 1:prod(size(labs))
                labs{k} = num2str(theLabels(k), theFormat);
        end
        theLabels = labs;
end

result = text(x, y, theLabels, varargin{:});

if nargout > 0
        theResult = result;
end

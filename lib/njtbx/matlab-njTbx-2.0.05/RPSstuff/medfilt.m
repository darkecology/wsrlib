function theResult = medfilt(theData, theFilterLength, theChunkLength)
% Medfilt -- Median-filtering.
%  medfilt(theData, theFilterLength, theChunkLength) applies
%   a centered median-filter of theFilterLength (default = 5)
%   to the columns of theData.  The computations are segmented
%   by the ChunkLength (default is the full height of the data).
%   Zero-slope end-conditions on the original data are assumed.
%   (Note: a row-vector will be filtered as a row.)
 
% Copyright (C) 1997 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 14-May-1998 11:37:36.

if nargin < 1, theData = 'demo'; end

if isequal(theData, 'demo')
        help(mfilename)
        theData = fix(20 .* rand(8, 2))
        theFilterLength = 3
        theChunkLength = 5
        result = medfilt(theData, theFilterLength, theChunkLength)
        return
end

oldSize = size(theData);
m = oldSize(1);
n = prod(oldSize) ./ m;
theData = reshape(theData, [m n]);
if m == 1 & length(oldSize) == 2
        theData = reshape(theData, [n m]);
end

[m, n] = size(theData);

if nargin < 2, theFilterLength = 5; end
if nargin < 3, theChunkLength = m; end

result = zeros(size(theData));

if rem(theFilterLength, 2) == 0
        theFilterLength = theFilterLength + 1;
end

f = fix(theFilterLength./2);

k = 0;
while k < m
        kmin = k+1;
        kmax = min(k+theChunkLength, m);
        imin = max(1, kmin-f);
        imax = min(kmax+f, m);
        d = theData(imin:imax, :);
        r = mdfilt(d, theFilterLength);
        imax = imax - imin + 1;
        imin = 1;
        if kmax < m, imax = imax - f; end
        if kmin > 1, imin = imin + f; end
        result(kmin:kmax, :) = r(imin:imax, :);
        k = kmax;
end

result = reshape(result, oldSize);

if nargout > 0
        theResult = result;
else
        assignin('caller', 'ans', result)
        ans = result
end

% -------------------- mdfilt -------------------- %

function theResult = mdfilt(theData, theFilterLength)

% mdfilt -- Median filter.
%  mdfilt(theData, theFilterLength) applies a centered
%   median-filter of theFilterLength (odd-number) to the
%   columns of theData, assuming zero-slope ends.  The
%   default filter-length is 5.  The result is the same
%   size as the data.  (Note: a row-vector is filtered
%   as a row.)
%  medfilt('demo') demonstrates itself.
 
% Copyright (C) 1997 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 11-May-1998 16:59:16.
% Revised    12-May-1998 23:58:38.

if nargin < 1, theData = 'demo'; end

if isequal(theData, 'demo')
        help(mfilename)
        m = 6; n = 2;
        theData = fix(rand(m, n).*20)
        theFilterLength = 3
        theFilteredData = mdfilt(theData, theFilterLength)
        return
end

if nargin < 2, theFilterLength = 5; end

% Use odd-length filter.

if rem(theFilterLength, 2) == 0
        theFilterLength = theFilterLength + 1;
end

% Re-arrange for efficiency.

oldSize = size(theData);
m = oldSize(1); n = prod(oldSize)./m;
if m == 1 & length(oldSize) == 2
        theData = theData.';
        [m, n] = size(theData);
end
theData = reshape(theData, [m n]);
theData = theData.';   % Transpose to row-wise.
[m, n] = size(theData);

result = zeros(size(theData));

% Create index-array.

f = fix(theFilterLength./2);
ind = [ones(1, f) (1:n) ones(1, f).*n];
indices = zeros(theFilterLength, n);
k = 1:n;
for i = 1:theFilterLength
        indices(i, :) = ind(k);
        k = k + 1;
end

% Filter each row.

x = zeros(theFilterLength, n);
for i = 1:m
        x(:) = theData(i, indices);
        result(i, :) = median(x);
end

% Undo transpose and reshape.

result = reshape(result.', oldSize);

% Output.

if nargout > 0
        theResult = result;
else
        assignin('caller', 'ans', result)
        ans = result
end

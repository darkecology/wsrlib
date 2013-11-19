function [xi, yi] = interp1gap(x, y)

% interp1gap -- Fill gaps with NaNs.
%  [xi, yi] = interp1gap(x, y) returns interpolates
%   of y(x), such that obvious gaps in x, an otherwise
%   equally-spaced, monotonically-increasing sequence,
%   are filled with linear interpolates, whereas the
%   corresponding gaps in y are filled with NaNs.
 
% Copyright (C) 1997 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 16-Mar-1998 16:22:32.

if nargin < 2
    help interp1gap
    xx = [1 2 5 7]
    yy = [10 20 30 40]
    [xxi, yyi] = interp1gap(xx, yy)
    return
end

d = diff(x);
if any(d <= 0)
    error(' ## Requires monotonically-increasing x.')
end
dmin = min(d);
dmax = max(d);

% Return if no gaps.

if max(d) <= 1.5 .* min(d)
    xi = x; yi = y;
    return
end
    
threshold = 0.5 .* dmin ./ dmax;

xi =[min(x):dmin:max(x)+.5*dmin];

i=1:length(x);
j = interp1(x, i, xi);

k = find(abs(j-round(j)) > threshold);

yi =  interp1(x, y, xi);
yi(k) = NaN;

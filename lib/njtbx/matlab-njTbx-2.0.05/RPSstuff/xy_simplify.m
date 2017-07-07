function [xout, yout] = xy_simplify(x, y, nmax, tolerance)
% XY_SIMPLIFY -- Simplify (reduce the number of points) of a polyline
%  [xout, yout] = xy_simplify(x, y, nmax, tolerance) simplifies the (x, y)
%   polyline, returning nmax points if (nmax > 0) or those
%   points that are more significant than the given tolerance.
%   The ls_sort() routine is used, in which deviation, not
%   curvature, is the key principle.  NaNs are ignored.
%  xy_simplify(...) returns [xout yout] in a single array.
%  xy_simplify(nPoints) demonstrates itself with nPoints
%   (random); default = 24.
 
% Copyright (C) 1997 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 06-Jul-1998 06:40:26.
% Updated    21-Sep-1998 17:13:27.

% Reference: Douglas, D.H. and T.K. Peucker, Algorithms for
%  the reduction of the number of points required to represent
%  a digitized line of (sic?) its caricature, Can. Cartogr.,
%  10, 112-122, 1973.  We have adopted a similar scheme for
%  selecting "significant" points.  Unlike the D-P algorithm,
%  we sort all the points first, then isolate those that satisfy
%  our criteria for tolerance or total number of points retained.

if nargin < 1, help(mfilename), x = 'demo'; end

if isequal(x, 'demo'), x = 24; end

if ischar(x), x = eval(x); end

if length(x) == 1
        n = x;
        x = 1:n;
        y = cumsum(rand(size(x))-0.5);
        y(ceil(n/2)) = NaN;
        if (1), x(n) = x(1); y(n) = y(1); end
        nmax = fix((n+2) ./ 3);
        tolerance = 0;
        tic
        [xx, yy] = xy_simplify(x, y, nmax, tolerance);
        toc
        plot(xx, yy, '-*', x, y, 'o')
        xlabel('x'), ylabel('y')
        title('xy\_simplify')
        set(gcf, 'Name', 'xy_simplify')
        figure(gcf)
        return
end

if nargin < 3, nmax = 0; end
if nargin < 4
        if nmax == 0, nmax = length(lon); end
        tolerance = 0;
end

if nmax == 0, nmax = length(x); end

if nmax > 0 & nmax <= 1
        nmax = round(nmax*length(x));
end

% Save NaNs.

xx = x(:);
yy = y(:);

i = find(isfinite(xx) & isfinite(yy));
j = find(~isfinite(xx) | ~isfinite(yy));
if any(i), xx = xx(i); yy = yy(i); end

% Sort.

[ind, dev] = ls_sort(xx, yy);

% Restore NaNs: We need to decide how important
%  the NaNs are -- most or least?  If least,
%  then we do not need to include them.

ind = i(ind);
ind = [ind; j(:)];
dev = [dev; NaN*j];

if nmax > 0
        nmax = max(3, min(nmax, length(x)));
        ind = ind(1:nmax);
        dev = dev(1:nmax);
else
        f = find(dev >= tolerance);
        if any(f)
                ind = ind(f);
                dev = dev(f);
        end
end

[ind, s] = sort(ind);
dev = dev(s);

xx = x(ind);
yy = y(ind);

if nargout == 1
        xout = [xx yy];
elseif nargout > 1
        xout = xx;
        yout = yy;
end

function [theIndices, theDeviations] = ls_sort(x, y)

% ls_sort -- Sort (x, y) data for line-simplification.
%  [theIndices, theDeviations] = ls_sort(x, y) returns
%   indices and deviations of the given (x, y) data,
%   in order of decreasing importance for
%   line-simplification.
 
% Copyright (C) 1997 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 02-Jul-1998 09:36:15.

if nargin < 1, help(mfilename), x = 'demo'; end

if isequal(x, 'demo'), x = 24; end

if ischar(x), x = eval(x); end

if length(x) == 1
        n = x;
        x = 1:n;
        y = cumsum(rand(size(x))-0.5);
        tic
        [i, d] = ls_sort(x, y);
        toc
        reduce = 3;   % Reduction-factor.
        k = fix((n+reduce-1)./reduce);
        ii = i(1:k);
        dd = d(1:k);
        xx = x(ii);
        yy = y(ii);
        [ii, s] = sort(ii);
        dd = dd(s);
        xx = xx(s);
        yy = yy(s);
        subplot(2, 1, 1)
        plot(x, y, 'bo', xx, yy, 'g-')
        title('Data and Subset')
        xlabel('x'), ylabel('y')
        subplot(2, 1, 2)
        plot(i, d, '.', xx, dd, 'o')
        title('Deviation')
        xlabel('x'), ylabel('y')
        set(gcf, 'name', 'ls_sort demo')
        figure(gcf)
        return
end

ind = zeros(size(x));
dev = zeros(size(x));

nstack = ceil(1 + 2*log(length(x))/log(2));
stack = zeros(nstack, 2);
nstack = 1;
stack(nstack, :) = [1 length(x)];

ind(1) = 1;
ind(2) = length(x);
k = 2;

% Call ls_pivot() repeatedly and stack the
%  longer interval before the shorter.

while nstack > 0
        a = stack(nstack, 1);
        b = stack(nstack, 2);
        nstack = nstack - 1;
        if b-a > 1
                [p, d] = ls_pivot(x([a:b]), y([a:b]));
                if any(p)
                        p = a+p-1;
                        k = k+1;
                        ind(k) = p;
                        dev(k) = d;
                        if b-p >= p-a
                                if b-p > 1
                                        nstack = nstack + 1;
                                        stack(nstack, :) = [p b];
                                end
                        end
                        if p-a > 1
                                nstack = nstack + 1;
                                stack(nstack, :) = [a p];
                        end
                        if b-p < p-a
                                if b-p > 1
                                        nstack = nstack + 1;
                                        stack(nstack, :) = [p b];
                                end
                        end
                end
        end
end

% Sort in descending order of importance.

dev(1:2) = max(dev);
[ignore, s] = sort(-dev);
ind = ind(s);
dev = dev(s);

% Output.

if nargout > 0
        theIndices = ind;
        theDeviations = dev;
else
        ind, dev
end

function [thePivot, theDeviation] = ls_pivot(x, y)

% ls_pivot -- Line-simplification pivot.
%  ls_pivot(x, y) returns the index of the (x, y)
%   point that deviates most from the straight-line
%   connection between the first and last of the
%   given points.
 
% Copyright (C) 1997 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 02-Jul-1998 08:32:40.

if nargin < 1, help(mfilename), x = 'demo'; end

if isequal(x, 'demo'), x = 10; end

if ischar(x), x = eval(x); end

if length(x) == 1
        n = x;
        x = 1:n;
        y = cumsum(rand(size(x))-0.5);
        tic
        [piv, dev] = ls_pivot(x, y);
        toc
        plot(x, y, 'b-', x([1 n]), y([1 n]), 'g-', x(piv), y(piv), '*')
        title(['ls\_pivot(' int2str(n) ')'])
        xlabel('x'), ylabel('y')
        figure(gcf)
        return
end

if nargin < 2, y = x; x = 1:length(y); end

thePivot = 0;
theDeviation = -inf;

n = length(x);
if n < 3, return, end

% Translate to origin.

x = x(:) - x(1);
y = y(:) - y(1);

% Rotate onto x-axis about origin, then
%  select the furthest point in y.
%  If end-points are the same, we instead pick
%  the point most distant from point #1.

if any([x(1) y(1)] ~= [x(n) y(n)])
        r = norm([x(n) y(n)]);
        c = x(n) ./ r;
        s = y(n) ./ r;
        z = [x y] * [c -s; s c];
else
        z = x + sqrt(-1)*y;
        z = [z z];
end

% Find the pivot.

temp = abs(z(2:n-1, 2));
f = find(temp == max(temp));
piv = f(1) + 1;
dev = abs(z(piv));

% Output.

if nargout > 0
        thePivot = piv;
        theDeviation = dev;
else
        piv, dev
end

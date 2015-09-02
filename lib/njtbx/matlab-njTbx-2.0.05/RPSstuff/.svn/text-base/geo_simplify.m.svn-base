function [olon, olat] = geo_simplify(lon, lat, frac, nmin)

% geo_simplify -- NaN-aware driver for geo_simp.
%  [olon, olat] = geo_simplify(lon, lat, frac, nmin) calls
%   geo_simp independently for each of the NaN-separated
%   segments of the (lon, lat) data.  The concatenated results
%   are returned as (olon, olat).  The proportion to be kept
%   in the result is given by frac (default = 0.5), a decimal
%   fraction between 0 and 1.  Nmin (default = 4) specifies
%   the smallest segment of the result that will be retained.
%  [out] = ... returns the result as one array of [olon olat].
%  geo_simplify(N) demonstrates itself for N points (default = 24),
%   containing a NaN in the middle.  The result preserves about
%   one-third of the original points.
 
% Copyright (C) 1999 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 08-Feb-1999 15:57:00.
% Updated    09-Feb-1999 10:44:56.
% Updated    11-Feb-1999 14:12:56.

if nargin < 1, help(mfilename), lon = 'demo'; end

if isequal(lon, 'demo'), lon = 24; end

if ischar(lon), lon = eval(lon); end

if length(lon) == 1
        n = lon;
        lon = (1:n).';
        lat = cumsum(rand(size(lon))-0.5) .* 10;
        lat(ceil(n/2)) = NaN;
        frac = 1/3;
        nmin = 1;
        tic
        [lon1, lat1] = geo_simplify(lon, lat, frac);
        toc
        plot(lon1, lat1, '-*', lon, lat, 'o')
        xlabel('lon (degrees)'), ylabel('lat (degrees)')
        title('geo\_simplify')
        axis equal
        set(gcf, 'Name', 'geo_simplify')
        figure(gcf)
        return
end

if nargin < 3, frac = 0.5; end
if nargin < 4, nmin = 4; end

f = find(~isfinite(lon) | ~isfinite(lat));
f = [0; f; length(lon)+1];

lon1 = [];
lat1 = [];
for k = 2:length(f)
        i = f(k-1)+1;
        j = f(k)-1;
        count = j - i + 1;
        if count >= nmin
                [lo, la] = geo_simp(lon(i:j), lat(i:j), frac);
                if length(lo) >= nmin
                        lon1 = [lon1; lo; NaN];
                        lat1 = [lat1; la; NaN];
                end
        end
end

if nargout == 1
        olon = [lon1 lat1];
elseif nargout > 1
        olon = lon1;
        olat = lat1;
else
        disp([lon1 lat1]);
end

function [olon, olat] = geo_simp(lon, lat, nmax, tolerance)

% geo_simp -- Simplify a (lon, lat) contour.
%  [olon, olat] = geo_simp(lon, lat, nmax, tolerance)
%   simplifies the (lon, lat) contour, returning nmax points
%   if (nmax > 0), or those points that are more significant
%   than the given tolerance.  The gs_sort() routine is used,
%   in which the deviation, not the curvature, is the key
%   principle.  NaNs are ignored.  Nmax may be specified as
%   a decimal fraction (0...1), or as an integer > 1.
%  [out] = geo_simplity(...) returns [olon olat] in one array.
%  geo_simplify(nPoints) demonstrates itself with nPoints
%   (random); default = 24.
 
% Copyright (C) 1997 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 06-Jul-1998 06:40:26.
% Revised    04-Sep-1998 15:29:19.

% Reference: Douglas, D.H. and T.K. Peucker, Algorithms for
%  the reduction of the number of points required to represent
%  a digitized line of (sic?) its caricature, Can. Cartogr.,
%  10, 112-122, 1973.  We have adopted a similar scheme for
%  selecting "significant" points.  Unlike the D-P algorithm,
%  we sort all the points first, then isolate those that satisfy
%  our criteria for tolerance or total number of points retained.

if nargin < 1, help(mfilename), lon = 'demo'; end

if isequal(lon, 'demo'), lon = 24; end

if ischar(lon), lon = eval(lon); end

if length(lon) == 1
        n = lon;
        lon = 1:n;
        lat = cumsum(rand(size(lon))-0.5) .* 10;
        lat(ceil(n/2)) = NaN;
        nmax = fix((n+2) ./ 3);
        tolerance = 0;
        tic
        [lon1, lat1] = geo_simp(lon, lat, nmax, tolerance);
        toc
        plot(lon1, lat1, '-*', lon, lat, 'o')
        xlabel('lon (degrees)'), ylabel('lat (degrees)')
        title('geo\_simp')
        axis equal
        set(gcf, 'Name', 'geo_simp')
        figure(gcf)
        return
end

if nargin < 3, nmax = length(lon); end
if nargin < 4
        tolerance = 0;
        if nmax == 0, nmax = length(lon); end
end

if nmax > 0 & nmax <= 1
        nmax = round(nmax*length(lon));
end

RCF = 180 ./ pi;
x = cos(lat/RCF).*cos(lon/RCF);
y = cos(lat/RCF).*sin(lon/RCF);
z = sin(lat/RCF);

% Save NaNs.

xx = x(:);
yy = y(:);
zz = z(:);

i = find(isfinite(xx) & isfinite(yy) & isfinite(zz));
j = find(~isfinite(xx) | ~isfinite(yy) | ~isfinite(zz));
if any(i), xx = xx(i); yy = yy(i); zz = zz(i); end

% Sort.

[ind, dev] = gs_sort(xx, yy, zz);

% Restore NaNs.

ind = i(ind);
ind = [ind; j(:)];
dev = [dev; NaN*j];

% Deviation angle: always < 90 degrees.

dev = asin(dev) .* 180 ./ pi;

% Trim by count or tolerance.

if nmax > 0
        if nmax <= 1, nmax = round(nmax .* length(lon)); end
        nmax = max(3, min(nmax, length(lon)));
        ind = ind(1:nmax);
        dev = dev(1:nmax);
else
        f = find(dev >= tolerance);
        if any(f)
                ind = ind(f);
                dev = dev(f);
        end
end

% Unsort.

[ind, s] = sort(ind);
dev = dev(s);

lon1 = lon(ind);
lat1 = lat(ind);

if nargout == 1
        olon = [lon1 lat1];
elseif nargout > 1
        olon = lon1;
        olat = lat1;
end

function [theIndices, theDeviations] = gs_sort(x, y, z)

% gs_sort -- Sort (x, y, z) data for line-simplification.
%  [theIndices, theDeviations] = gs_sort(x, y, z) returns
%   indices and deviations of the given (x, y, z) data,
%   in order of decreasing importance.  The (x, y, z)
%   data are geographic, expressed as direction-cosines.
%   The deviations are the sines of the angles of
%   deviation.
 
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
        a = cumsum(rand(n, 3)-0.5);
        for i = 1:n
                a(i, :) = a(i, :) ./ norm(a(i, :));
        end
        x = a(:, 1); y = a(:, 2); z = a(:, 3);
        tic
        [i, d] = gs_sort(x, y, z);
        toc
        reduce = 3;   % Reduction-factor.
        k = fix((n+reduce-1)./reduce);
        ii = i(1:k);
        dd = d(1:k);
        xx = x(ii);
        yy = y(ii);
        zz = z(ii);
        [ii, s] = sort(ii);
        dd = dd(s);
        xx = xx(s);
        yy = yy(s);
        zz = zz(s);
        subplot(2, 1, 1)
        plot3(x, y, z, 'b+', xx, yy, zz, 'go-')
        title('Data and Subset')
        xlabel('x'), ylabel('y'), zlabel('z')
        view(2)
        subplot(2, 1, 2)
        plot(i, d, '.', xx, dd, 'o')
        title('Deviation')
        xlabel('x'), ylabel('y'), zlabel('z')
        view(2)
        set(gcf, 'Name', 'gs_sort demo')
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
nout = 2;

% Call gs_pivot() repeatedly and stack the
%  longer interval before the shorter.

while nstack > 0
        a = stack(nstack, 1);
        b = stack(nstack, 2);
        nstack = nstack - 1;
        if b-a > 1
                [p, d] = gs_pivot(x([a:b]), y([a:b]), z([a:b]));
                if any(p)
                        p = a+p-1;
                        nout = nout+1;
                        ind(nout) = p;
                        dev(nout) = d;
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

function [thePivot, theDeviation] = gs_pivot(x, y, z)

% gs_pivot -- Geographic line-simplification pivot.
%  [thePivot, theDeviation] = gs_pivot(x, y, z) returns
%   the index of the (x, y, z) point that deviates most
%   from the great-circle path between the first and last
%   of the geographic points, given as direction-cosines.
%   Only finite points are allowed.  The deviation is
%   returned as the sine of the deviation-angle.
 
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
        a = cumsum(rand(n, 3)-0.5);
        for i = 1:n
                a(i, :) = a(i, :) ./ norm(a(i, :));
        end
        x = a(:, 1); y = a(:, 2); z = a(:, 3);
        tic
        [piv, dev] = gs_pivot(x, y, z)
        toc
        plot3(x, y, z, 'b-', ...
                        x([1 n]), y([1 n]), z([1, n]), 'g-', ...
                        x(piv), y(piv), z(piv), 'r*')
        title(['gs\_pivot(' int2str(n) ')'])
        xlabel('x'), ylabel('y'), zlabel('z')
        set(gca, 'Box', 'on')
        figure(gcf)
        return
end

thePivot = 0;
theDeviation = -inf;

n = length(x);
if n < 3, return, end

% Pole of the spanning great-circle.
%  WARNING: no such pole will exist if the two
%  end-points are the same.  In that case, use
%  point farthest from the ends.

if any([x(1) y(1) z(1)] ~= [x(n) y(n) z(n)])
        c(1) = y(1)*z(n)-y(n)*z(1);
        c(2) = z(1)*x(n)-z(n)*x(1);
        c(3) = x(1)*y(n)-x(n)*y(1);
        c = c.' ./ norm(c);
        d = [x y z] * c;
else
        c = [x(1) y(1) z(1)].';
        d = [x y z] * c;
        d = sqrt(1 - d.*d);
end

% Find the pivot and deviation.

temp = abs(d(2:n-1));
f = find(temp == max(temp));

piv = f(1) + 1;
dev = abs(d(piv));

% Output.

if nargout > 0
        thePivot = piv;
        theDeviation = dev;
else
        piv, dev
end

function [olon, olat] = geo_simp(lon, lat, nmax, tolerance, nmin)

% geo_simp -- NaN-aware driver for geo_simplify.
%  [olon, olat] = geo_simp(lon, lat, nmax, tolerance, nmin)
%   geo_simplify independently for each of the NaN-separated
%   segments of the (lon, lat) data.  The concatenated results
%   are returned as (olon, olat).  Nmax may be given as a
%   decimal fraction between 0 and 1, or as an integer > 1.
%   Nmin (default = 4) is given similarly, and simplified
%   segments with fewer points are ignored.
%  [out] = ... returns the result as one array of [olon olat].
 
% Copyright (C) 1999 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 08-Feb-1999 15:57:00.
% Updated    09-Feb-1999 10:44:56.

if nargin < 2, help(mfilename); return, end
if nargin < 3, nmax = length(lon); end
if nargin < 4
        tolerance = 0;
        if nmax == 0, nmax = length(lon); end
end
if nargin < 5, nmin = 4; end

if nmin > 0 & nmin < 1
        nmin = round(nmin .* length(lon));
end

f = find(~isfinite(lon) | ~isfinite(lat));
f = [0; f; length(lon)+1];

lon1 = [];
lat1 = [];
for k = 2:length(f)
        i = f(k-1)+1;
        j = f(k)-1;
        if j > i+1
                [lo, la] = geo_simplify(lon(i:j), lat(i:j), nmax, tolerance);
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

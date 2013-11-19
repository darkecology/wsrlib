function theResult = crossings(z1, z2, varargin)

% crossings -- Index where a polyline crosses a line.
%  crossings(N) demonstrates itself with N polyline
%   points, where N defaults to 10.
%  crossings(z1, z2) returns decimal-indices in polyline
%   z1 where line-segment z2 (both complex) crosses it.
%   Zero represents segments that do not cross.
%  crossings(x1, y1, x2, y2) is an alternative syntax.
 
% Copyright (C) 2000 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 12-Jul-2000 09:05:48.
% Updated    13-Jul-2000 14:14:56.

if nargin < 1, help(mfilename), z1 = 'demo'; end

if isequal(z1, 'demo'), z1 = 10; end
if ischar(z1), z1 = eval(z1); end

if length(z1) == 1
	n = z1;
	z1 = sort(rand(1, n)) + sqrt(-1)*rand(1, n);
	z2 = rand(1, 2) + sqrt(-1)*rand(1, 2);
	hold off
	plot(real(z1), imag(z1), 'g', ...
			real(z2), imag(z2), 'r')
	tic
	result = feval(mfilename, z1, z2);
	disp([' ## Elapsed time: ' int2str(round(toc)) ' s'])
	if any(result)
		zi = interp1(1:length(z1), z1, result(result ~= 0));
		hold on
		plot(real(zi), imag(zi), 'bo')
	end
	hold off
	title([mfilename ' ' int2str(n)])
	figure(gcf)
	try, zoomsafe, catch, end
	return
end

if nargin > 3
	z1 = z1 + sqrt(-1)*z2;
	z2 = varargin{1} + sqrt(-1)*varargin{2};
end

if length(z2) > 2
	temp = z1; z1 = z2; z2 = temp;
end

% *** The following note not yet correct. ***
% NOTE: This routine can be vectorized by using
%  "tensor_sol" to compute all the crossings (roots) at
%   once.  The problem to be solved is A = [x1 1; x2 1]
%   and b = [y1; y2], where each of the entries extends
%   into the third dimension, one element per line segment.
%   Call "tensor_sol(A, b, 2, 1)".

z1 = z1(:);
z2 = z2(:);

result = zeros(length(z1)-1, 1);

for i = 1:length(z1)-1
	z0 = z1(i);
	zd = diff(z1(i:i+1));
	z = (z2 - z0) / zd;
	if any(imag(z) >= 0) & any(imag(z) <= 0)
		p = polyfit(real(z), imag(z), 1);
		root = -p(2) / p(1);
		if root >= 0 & root <= 1
			result(i) = root + i;
		end
	end
end

if nargout > 0
	theResult = result;
else
	disp(result)
end

function xnew=gmin(x)
% GMIN  Similar to MIN, but for "good" points (finite points).
%
% DESCRIPTION:  For vectors, GMIN(X) is the smallest element of the
%       finite points in X.  If there are no finite points, the value
%       of NaN is returned.   For matrices, GMIN(X) is a vector 
%       containing the minimum element of the finite values
%       from each column. 
%
% Rich Signell (rsignell@usgs.gov)

[imax,jmax]=size(x);

for j=1:jmax
       good=find(isfinite(x(:,j)));
       if length(good)>0
          xnew(j)=min(x(good,j));
       else
          xnew(j)=NaN;
       end
end

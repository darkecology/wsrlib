function xnew=gmax(x)
% GMAX  Similar to MAX, but for "good" points (finite points).
%
% DESCRIPTION:  For vectors, GMAX(X) is the largest element of the
%       finite points in X.  If there are no finite points, the value
%       of NaN is returned.   For matrices, GMAX(X) is a vector 
%       containing the maximum element of the finite values
%       from each column. 
%
% Rich Signell (rsignell@usgs.gov)

[imax,jmax]=size(x);

for j=1:jmax
       good=find(isfinite(x(:,j)));
       if length(good)>0
          xnew(j)=max(x(good,j));
       else
          xnew(j)=NaN;
       end
end

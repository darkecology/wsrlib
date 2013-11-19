function xnew=gsum(x)
% GSUM: just like sum, except that it skips over bad points
%function xnew=gsum(x)

[imax,jmax]=size(x);

for j=1:jmax
       good=find(isfinite(x(:,j)));
       if length(good)>0
          xnew(j)=sum(x(good,j));
       else
          xnew(j)=NaN;
       end
end

function xnew=gmean(x)
% GMEAN  just like mean, except that it skips over bad points
%  Usage:  xnew=gmean(x);
%             x can be a vector or matrix
[imax,jmax]=size(x);
if(imax==1),
  imax=jmax;
  jmax=1;
  x=x.';
end
for j=1:jmax
       good=find(isfinite(x(:,j)));
       if length(good)>0
          xnew(j)=mean(x(good,j));
       else
          xnew(j)=NaN;
       end
end

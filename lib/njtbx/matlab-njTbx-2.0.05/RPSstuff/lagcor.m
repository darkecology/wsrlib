function cor=lagcor(a,b,n);
% LAGCOR: finds lagged correlations between two series
%  Usage: cor=lagcor(a,b,n);
%              a and b are two column vectors
%              n is range of lags
%              cor is correlation as fn of lag
cor=[];
for i=0:n
[d1 d2]=shift(a,b,i);
ind=find(~isnan(d1+d2));
corrcoef([d1(ind) d2(ind)]);
   if length(ans)>1
       cor(i+1)=ans(1,2);
   end
end

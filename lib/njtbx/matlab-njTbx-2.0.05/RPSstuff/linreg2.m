function [m,rsq]=linreg2(x,y,plt);
% LINREG2 finds and plots linear regression forced through 0
% Usage: [m,r]=linreg2(x,y,[iplot]);
% where m=slope, rsq=correlation coefficient squared
% regress y on x, add IPLOT=1 for a plot
%
% Rich Signell rsignell@usgs.gov
x=x(:);y=y(:);
igood=find(finite(x+y));
x=x(igood);y=y(igood);
A=[x];
B=y;
ans=A\B;
m=ans(1);
y2=m*x;
c=corrcoef(y(:),y2(:));
r=c(2,1);
rsq=r.*r;
if(nargin==3),
    xi=linspace(min(x),max(x),100);
    yi=m*xi;
    plot(xi,yi,'b',x,y,'ro');
    title(['m=' num2str(m) '  r**2=' num2str(rsq)])
end

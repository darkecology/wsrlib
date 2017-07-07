function [m,b,rsq]=linreg(x,y,iplot)
%LINREG finds and plots linear regression NOT forced through 0
% Usage: [m,b,rsq]=linreg(x,y,[iplot]);
% m = slope
% b = y intercept
% rsq = r squared correlation coefficient
% regress y on x, add IPLOT=1 for a plotfunction [m,b,rsq]=linreg(x,y)
% Note: If you want a linear regression forced through 0, use LINREG2
%
%y=mx+b
%rsq=regression coefficient squared
%
% Rich Signell rsignell@usgs.gov
denan([x(:),y(:)]);
x=ans(:,1);
y=ans(:,2);
a(1,1)=length(y);
a(2,1)=sum(x);
a(1,2)=a(2,1);
a(2,2)=sum(x.*x);
bb(1)=sum(y);
bb(2)=sum(x.*y);
c=a\bb';
m=c(2);
b=c(1);
bbsq=bb(1)*bb(1)/a(1,1);
rsq=(b*bb(1)+m*bb(2)-bbsq )/(sum(y.*y)-bbsq);
r=sqrt(rsq);
ynew=m*x+b;
if exist('iplot'),
    plot(x,y,'x',x,ynew)
    title(['m=' num2str(m) '  b=' num2str(b) '  r**2=' num2str(rsq)])
end

function [y,xn]=interp_r(xa,ya,x)
% INTERP_R:  A no-loop 1D interpolation routine for time series data
%  xa = Original time base (e.g. decimal Julian day)
%  ya = Matrix of original time series data (each time series should in a column)
%  x = Evenly sampled time base on which you want to interpolate the data.
%      You can specify x=n for n evenly spaced points if you prefer.

% Rich Signell (rsignell@usgs.gov)
if length(x)==1
    n=x;
%                      generate x array
    dx=(xa(length(xa))-xa(1))/(n-1);
    x=xa(1):dx:xa(length(xa));
    xn=x;
else
    n=length(x);
    dx=(x(n)-x(1))/(n-1);
end
x=x(:);
xa=xa(:);

%%%
[mm,nn]=size(ya);
if(mm==1),ya=ya.';,end
[mm,nn]=size(ya);
y=ones(length(x),nn);
%%%
ind=ceil((xa-x(1))/dx)+1;
a=find(ind<1);
if length(a)>0 
         ind(a)=[];
end
ibelow=zeros(size(x'));
ibelow(ind)=1+length(a):length(xa);
ind=find(ibelow~=0);
%if(~isempty(ind)),
 ibelow(ind)=[ibelow(ind(1)) diff(ibelow(ind))];
 ibelow=cumsum(ibelow(1:n));
%end
a=find(ibelow<1);
if length(a)>0
         ibelow(a)=ones(size(a));
end
%..........................................   now upper side
ind=floor((xa-x(1))/dx)+1;
a=find(ind<1);
if length(a)>0 
         ind(a)=[];
end
iabove=zeros(size(x'));
%ind=ind(length(ind):-1:1);
iabove(ind)=1+length(a):length(xa);
ind=find(iabove~=0);
iabove(ind)=[iabove(ind(1)) diff(iabove(ind))];
a=length(x):-1:1;
iabove(a)=cumsum(iabove(a));
iabove=iabove(1)+1-iabove(1:length(x));
a=find(iabove>length(xa));
if length(a)>0
         iabove(a)=ones(size(a))*length(xa);
end
a=find(iabove-ibelow~=0);
for ii=1:nn,
  y(:,ii)=ya(iabove,ii);
  if length(a)>0
    fac=(x(a)-xa(ibelow(a)))./(xa(iabove(a))-xa(ibelow(a)));
    y(a,ii)=ya(ibelow(a),ii).*(1-fac)+ya(iabove(a),ii).*fac;
  end
  ioutside=find(x<min(xa) | x>max(xa));
  if(length(ioutside)>0),
    y(ioutside,ii)=NaN*ones(size(ioutside)); 
  end
end

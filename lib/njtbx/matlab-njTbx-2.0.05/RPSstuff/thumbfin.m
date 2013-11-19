function uout=thumbfin(u,umin,umax,goplot)
%FUNCTION THUMBFIN  rejects data outside a user-specified range.
%                   "Thumb-finger filter"
%
%  function uout=thumbfin(u,umin,umax,[goplot])
%           u = data vector
%           umin= rejects data below this value
%           umax= rejects data above this value
%           goplot = optional 4th argument which plots the data, and
%                    flags the bad points.
g=find(~isnan(u));
bad=find( (u(g)<umin)|(u(g)>umax) );
uout=u;
if length(bad)>0
       uout(g(bad))=ones(1,length(bad))*NaN;
end
if (nargin>3)&(length(bad)>0)
      plot(g,u(g),g(bad),u(g(bad)),'x')
end

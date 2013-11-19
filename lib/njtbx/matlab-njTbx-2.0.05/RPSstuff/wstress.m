function [taux,tauy,u10,v10]=wstress(u,v,z0)
% WSTRESS  computes wind stress using the Large and Pond (JPO, 1981) formulation.
%
%  USAGE: [taux,tauy,u10,v10]=wstress(u,v,z0)
%
%       u,v = eastward, northward components of wind in m/s
%       z0  = height of wind sensor in m (assumed to be 10 m if not supplied)
%     
%       taux,tauy = eastward, northward wind stress components (dynes/cm2)
%       u10,v10   = equivalent wind velocity components at 10 m.
%

% Rich Signell  rsignell@usgs.gov
%
% Version 1.1 2005-04-15
% Bug fixed:  Line 49 was changed from : t=(rho*cd.*d1*1.e4)./(1+a1.*sqrt(cd));
%                                   to : t=(rho*cd.*d1*1.e4)
%             The effect of this bug was to yield slightly incorrect wind stresses for 
%             anemometer heights different from 10 m. For example, a 10 m wind at 5 m 
%             height yielded 1.806 dyn/cm2 instead of 1.699 dyn/cm2 (6.3% too high), while a 
%             10 m wind at 30 m height yielded 1.154 dyn/cm2 instead of 1.261 dyn/cm2 (8.5% too low)
%             Only the wind stresses were affected.  The output 10m winds were correct.
%             Thanks to Charlie Stock for finding this bug.

if(nargin==2),
 z0=10.;
end;
%
nans=ones(length(u),1)*nan;
u10=nans; 
v10=nans;
taux=nans;
tauy=nans;
%
% identify times of zero wind.  These indices will be set to zero stress.
izeros=find((abs(u)+abs(v))==0);
igood=find(finite(u)& ((abs(u)+abs(v))>0));

u=u(igood);
v=v(igood);
u=u(:);
v=v(:);
w=u+i*v;
v0=abs(w);
k=.41;
rho=1.25e-3;
a1=1/k*log(z0/10.);
d1=1.e35*ones(size(u));
c=zeros(size(u));
cd=ones(size(u))*1.205e-3;
while (max(abs(c-d1))>.01),
  c=d1;
  cd=ones(size(u))*1.205e-3;
  ind=find(c>11);
  if(~isempty(ind))
   cd(ind)=(0.49 + 0.065*c(ind))*1.e-3;
  end
  d1=v0./(1+a1.*sqrt(cd));
end
%t=(rho*cd.*d1*1.e4)./(1+a1.*sqrt(cd));  % wrong
t=(rho*cd.*d1*1.e4);                     % fix for version 1.1 
w10=(d1./v0).*w;
u10(igood)=real(w10);
v10(igood)=imag(w10);
taux(igood)=t.*u10(igood);
tauy(igood)=t.*v10(igood);
% set zero wind periods to zero stress (and U10,V10)
u10(izeros)=zeros(size(izeros));
v10(izeros)=zeros(size(izeros));
taux(izeros)=zeros(size(izeros));
tauy(izeros)=zeros(size(izeros));

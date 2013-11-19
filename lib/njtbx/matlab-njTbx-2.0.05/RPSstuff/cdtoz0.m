function z0=CDtoZ0(Cd,zr)
% CDtoZ0  Calculates Z0 as a function of CD and ZR.
%
% Usage: Z0=CDTOZO(CD,ZR)
%
%      INPUTS:
%             CD = array of drag coefficients
%             ZR = height above bottom at which drag coefficient is specified
%               NOTE: ZR can be a single value or an array the same size as CD
%      OUTPUT:
%             Z0 = roughness length in the same units as ZR
if(length(zr)==1),
   zr=zr*ones(size(Cd));
end
kappa=0.4;
z0=NaN*ones(size(Cd));
igood=find(Cd~=0);
z0(igood)=zr(igood)./(exp(kappa*ones(size(igood))./sqrt(Cd(igood))));

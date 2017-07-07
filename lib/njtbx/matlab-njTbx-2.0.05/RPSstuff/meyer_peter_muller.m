function [s,theta,s_no_mu,mu,C]=meyer_peter_muller(V,H,z0,d50,d90,rho_sed,rho_water);
% MPM: Meyer Peter Muller bedload transport with ripple efficiency
% (as implemented in Delft 3D Flow Manual Formula 11.84)
% Usage: [s,theta,s_no_mu,mu,C]=mpm(V,H,z0,d50,d90,rho_sed,rho_water);
%     Outputs:  s = bedload transport (kg/m/s)
%               theta = Shields parameter (nondimensional)
%               s_no_mu = bedload without ripple factor (kg/m/s)
%               mu = ripple factor
%               C = Chezy coefficient
%     Inputs:   V = flow velocity (m/s)
%               H = water depth (m)
%               d50 = median sediment diameter (m)
%               d90 = 90% percentile sediment diameter (m)
%               rho_sed = sediment density (kg/m3)
%               rho_water = water density (kg/m3)
if nargin==0,
% migrating trench case
V=0.51;  % flow speed (m/s)
H=0.4;   % water depth (m)
z0=0.000833; % bottom roughness (m)
d50=160e-6; %  median sand size (m) 
d90=d50;    %  d_90 (m)
rho_sed=2650;  % sediment density (kg/m3)
rho_water=1000;  %water density (kg/m3)
end

g=9.81;   % gravity (kg-m/s2)
alpha=1;  % calibration coefficient
zeta=1;   % hiding factor for sediment fraction considered

del_rho=(rho_sed-rho_water)/rho_water;
k_s=30*z0;
C=18*log10(12*H/k_s);   % Chezy coefficient 
C_g=18*log10(12*H/d90);  % Chezy coefficient related to grains
mu=min((C/C_g)^1.5,1.0);  % ripple/efficiency factor
theta=(V./C).^2/(del_rho*d50);   % Shields parameter
theta_c=0.047;   % critical Shields parameter

% Bedload without the ripple/efficiency factor (ROMS 3.1):
s_no_mu=rho_sed*8*alpha*d50*sqrt(del_rho*g*d50)*(theta-zeta*theta_c).^(3/2);

% Full MPM formula with ripple/efficiency factor:
s=rho_sed*8*alpha*d50*sqrt(del_rho*g*d50)*(mu*theta-zeta*theta_c).^(3/2);

function [C,n]=z0toCn(z0,H);
% Z0TOCN:  Convert roughness height z0 to Chezy "C" and Manning's "n"
%          which is a function of the water depth
% Usage: [C,n]=z0toCn(z0,H);
%   Inputs: 
%      z0 = roughness height (meters)
%       H = water depth (meters) (can be vector)
%   Outputs: 
%       C = Chezy "C" (non-dimensional)
%       n = Manning's "n" (non-dimensional)
%  
% Example: [C,n]=z0toCn(0.003,2:200);
%                 finds vectors C and n corresponding to a z0=0.003 and
%                 a range of water depths from 2:200 meters

k_s=30*z0; 
C=18*log10(12*H/k_s); 
n=(H.^(1/6))./C; 
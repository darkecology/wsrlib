function J = avhrr(m)
% avhrr - AHVRR colormap used by NOAA Coastwatch
% AVHRR(M) returns an M-by-3 matrix containing a "AVHRR" colormap.
%   AVHRR, by itself, is the same length as the current figure's
%   colormap. If no figure exists, MATLAB creates one.
if nargin < 1
   m = size(get(gcf,'colormap'),1);
end

x=(0:(m-1))/(m-1);
xr=[0 .2 .4 .5 .6 .8 1.0];
rr=[.5 1.0 1.0 .5 .5 0 .5];
r=interp1(xr,rr,x);
xg=[0 .4 .6 1.0];
gg=[0 1 1 0];
g=interp1(xg,gg,x);
xb=[0 .2 .4 .5 .6 .8 1.0];
bb=[0 0 .5 .5 1.0 1.0 .5];
b=interp1(xb,bb,x);

J = flipud([r(:) g(:) b(:)]);

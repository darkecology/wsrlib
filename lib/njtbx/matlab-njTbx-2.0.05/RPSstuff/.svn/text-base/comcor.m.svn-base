function [amp,theta,trans]=comcor(w1,w2);

% COMCOR  Complex correlation between two vector time series.
%
% [amp,theta,trans]=COMCOR(w1,w2) computes the complex vector correlation
% coefficient following Kundu (1976), JPO, 6, 238-242. 
%
%  Input: w1,w2  = complex column vectors representing currents or winds,
%                  etc, where w1=u1+i*v1, w2=u2+i*v2.
%
%  Output: amp   = amplitude of  correlation.
%          theta = rotation angle in degrees, where a positive angle
%                  indicates that series 1 is rotated positively 
%                  (counterclockwise) from series 2.
%          trans = transfer function.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0: 12/4/96 Rich Signell (rsignell@usgs.gov)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%columnize
w1=w1(:);
w2=w2(:);

% work on only the common good points
ii=find((isfinite(w1+w2)));

% if no common good points, return NaNs
if(length(ii)<1),amp=NaN;theta=NaN;trans=NaN;return;end

c=cov([w1(ii) w2(ii)]);
d=diag(c);
x=c./sqrt(d*d');
amp=abs(x(2,1));
theta=angle(x(2,1))*180/pi;
trans=abs(c(1,2)/c(1,1));


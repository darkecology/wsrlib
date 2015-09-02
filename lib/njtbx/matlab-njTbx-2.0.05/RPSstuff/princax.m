function [theta,maj,min,wr]=princax(w)
% PRINCAX Principal axis, rotation angle, principal ellipse
%
%   [theta,maj,min,wr]=princax(w) 
%
%   Input:  w   = complex vector time series (u+i*v)
%
%   Output: theta = angle of maximum variance, math notation (east == 0, north=90)
%           maj   = major axis of principal ellipse
%           min   = minor axis of principal ellipse
%           wr    = rotated time series, where real(wr) is aligned with 
%                   the major axis.
%
% For derivation, see Emery and Thompson, "Data Analysis Methods
%   in Oceanography", 1998, Pergamon, pages 325-327.  ISBN 0 08 0314341
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0 (12/4/1996) Rich Signell (rsignell@usgs.gov)
% Version 1.1 (4/21/1999) Rich Signell (rsignell@usgs.gov) 
%     fixed bug that sometimes caused the imaginary part 
%     of the rotated time series to be aligned with major axis. 
%     Also simplified the code.
% Version 1.2 (3/1/2000) Rich Signell (rsignell@usgs.gov) 
%     Simplified maj and min axis computations and added reference
%     to Emery and Thompson book
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% use only the good (finite) points
ind=find(isfinite(w));
wr=w;
w=w(ind);

% find covariance matrix
cv=cov([real(w(:)) imag(w(:))]); 

% find direction of maximum variance
theta=0.5*atan2(2.*cv(2,1),(cv(1,1)-cv(2,2)) );

% find major and minor axis amplitudes 

term1=(cv(1,1)+cv(2,2));
term2=sqrt((cv(1,1)-cv(2,2)).^2 + 4.*cv(2,1).^2);
maj=sqrt(.5*(term1+term2));
min=sqrt(.5*(term1-term2));

% rotate into principal ellipse orientation

wr(ind)=w.*exp(-i*theta);
theta=theta*180./pi;

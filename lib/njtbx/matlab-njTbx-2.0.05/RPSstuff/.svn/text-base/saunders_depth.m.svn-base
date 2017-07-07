function DEPTHM = saunders_depth(P,LAT)
% SAUNDERS_DEPTH simple formula to convert pressure in db to depth in meters
% Usage: DEPTHM = saunders_depth(P,LAT)
% P in decibars
% LAT in degrees north
% DEPTHM in meters
% from Saunders, 1981, "Practical conversion of pressure to depth"
% Journal of Physical Oceanography, April 1981, V11, p573-574.

% Rich Signell (rsignell@usgs.gov)
% Compared to the more accurate UNESCO formula implemented in the seawater toolkit routine
% SW_DPTH, this simpler formula yeilds depths within 1 meter


DEG2RAD=pi/180;
X = sin(LAT*DEG2RAD);
c1 = (5.92 + 5.25*X.*X)*1.e-3;
c2 = 2.21E-6;
DEPTHM = (1 - c1).*P - c2*P.*P;

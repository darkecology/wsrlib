function [filtdat]=fourfilt(x,delt,tmax,tmin)

%  FOURFILT  Fourier low, high, or bandpass filter.
%
%     [filtdat]=fourfilt(x,delt,tmax,tmin)
%
%     where:   x:      data series to be filtered
%              delt:   sampling interval
%              tmax:   maximum period filter cutoff
%              tmin:   minimum period filter cutoff
%
%     usage:  lowpassdata=fourfilt(data,0.5,2000,20)
%
%               gives lowpass filter with cutoff at 20.0 sec
%               tmax set > (length(x)*delt) for no cutoff at low freq end
%
%     usage:  highpassdata=fourfilt(x,0.5,20,0.9)
%
%               gives highpass filter with cutoff at 20.0 sec
%               tmin set < (2*delt) for no cutoff at high freq end
%
%     usage:  bandpassdata=fourfilt(x,0.5,20,10)
%
%               gives bandpass filter passing 10-20 sec. band
% 
% Reference:
% Walters, R. A.  and Heston, C., 1982. Removing the tidal-period variations from time-series
% data using low-pass digital filters. Journal of Physical Oeanography, 12 112-115 .
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0  (12/4/96)  Jeff List (jlist@usgs.gov)
% Version 1.1  (1/8/97)  Rich Signell (rsignell@usgs.gov)
%     removed argument for number of points and add error trapping for matrices
% Version 1.1b (12/1/2005) Rich Signell (rsignell@usgs.gov)
%     added reference
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m,n]=size(x);
if(min(m,n)~=1),
  disp('fourfilt cannot handle matrices');
  stop
end
npts=length(x);

nby2=npts/2;
tfund=npts*delt;
ffund=1.0/tfund;

%  remove the mean from data:

datamean=mean(x);
x=x-datamean;

% fourier transform data:

coeffs=fft(x);

%  filter coefficients:

f=ffund;
for i=2:nby2+1
  t=1.0/f;
  if t > tmax | t < tmin
     coeffs(i)=0.0*coeffs(i);
  end
  f=f+ffund;
end


%  calculate the remaining coefficients:

for i=2:nby2
   coeffs(npts+2-i)=conj(coeffs(i));
end


%  backtransform data and take real part:

backcoeffs=ifft(coeffs);
filtdat=real(backcoeffs);

% add back the mean:

filtdat=filtdat+datamean;

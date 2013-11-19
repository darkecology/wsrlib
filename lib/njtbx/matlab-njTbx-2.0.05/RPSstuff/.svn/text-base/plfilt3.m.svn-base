function [ufilt,jdf]=plfilt(u,jd,nsamp)
% PLFILT  Low-pass filters hourly data using the pl33 filter 
%
%  USAGE: [ulp]=plfilt(u)
%     or
%         [ulp,jdlp]=plfilt(u,jd)
%     or
%         [ulp,jdlp]=plfilt(u,jd,nsub)
%
%    Input:  u =  matrix with time series in each column
%           jd =  julian day time vector (optional)
%         nsub =  subsampling interval for the output low-pass data (optional)
%  
%    Output: ulp = low-pass filtered data with 33 hours removed at each end.
%            jdlp = julian time vector corresponding to the data ulp.
%
%    Example:   [ulp,jdlp]=plfilt(u,jd,4);   %jdlp and ulp at 4 hour intervals 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0 (12/4/96) Rich Signell (rsignell@usgs.gov)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%half the filter weights
pl33=[  
  -0.00027 -0.00114 -0.00211 -0.00317 -0.00427 ...
  -0.00537 -0.00641 -0.00735 -0.00811 -0.00864 ...
  -0.00887 -0.00872 -0.00816 -0.00714 -0.00560 ...
  -0.00355 -0.00097  0.00213  0.00574  0.00980 ...
   0.01425  0.01902  0.02400  0.02911  0.03423 ...
   0.03923  0.04399  0.04842  0.05237  0.05576 ...
   0.05850  0.06051  0.06174  0.06215  ]';

% symmetric filter
pl33=[pl33(1:34); pl33(33:-1:1)];

[m,n]=size(u);
if(min(m,n)==1),
  m=length(u);
  n=1;
  u=u(:);
end
if (m<length(pl33)),
  disp('data too short for this filter!!');
  return
end
ufilt=zeros(m-66,n);
for i=1:n,
  uf=conv(u(:,i),pl33);
  ufilt(:,i)=uf(67:length(uf)-66);
end
[m,n]=size(ufilt);
if (nargin>1),
  jdf=jd(34:34+m-1);
end
if (nargin==3)
 ufilt=ufilt([1:nsamp:m],:);
 jdf=jdf([1:nsamp:m]);
end

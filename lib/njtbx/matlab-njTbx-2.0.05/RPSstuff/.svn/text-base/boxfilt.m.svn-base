function [ufilt,jdf]=boxfilt(u,nbox,jd,nsamp)
% BOXFILT: Low-pass filters [and subsamples] using boxcar filter[s] 
%
%  USAGE: [ulp]=boxfilt(u,nbox)
%     or
%         [ulp,jdlp]=boxfilt(u,nbox,jd)
%     or
%         [ulp,jdlp]=boxfilt(u,nbox,jd,nsub)
%
%    Input:  u =  matrix with time series in each column
%            nbox = number of points to boxfilter (must be odd)
%            jd =  julian day time vector (optional)
%         nsub =  subsamboxing interval for the output low-pass data (optional)
%  
%    Output: ulp = low-pass filtered data 
%            jdlp = julian time vector corresponding to the data ulp.
%
%    Example:   [ulp,jdlp]=boxfilt(u,[6 6 7],jd,6);   
%               applies successive boxcar filters of 6, 6 and then 7,
%               then subsamples the output every 6 hours
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0 (4/4/97) Rich Signell (rsignell@usgs.gov)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 2.0 (1/10/99) Rich Signell (rsignell@usgs.gov)
% allows for successive boxcar filters to be applied by
% making NBOX a vector.  I've done this mainly for input
% to Foreman's Tidal Program, which can scale up higher
% frequency tidal coefficients if the sucessive filtering
% information is specified.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nnbox=nbox;
for ii=1:length(nnbox);
  nbox=nnbox(ii);
  %filter weights
  box=ones(nbox,1)./nbox;
  [m,n]=size(u);
  if(min(m,n)==1),
    m=length(u);
    n=1;
    u=u(:);
  end
  if (m<length(box)),
    disp('data too short for this filter!!');
    return
  end
  ufilt=zeros(m-nbox+1,n);
  for i=1:n,
    uf=conv(u(:,i),box);
    ufilt(:,i)=uf(nbox:(length(uf)-(nbox-1)));
  end
end
[m,n]=size(ufilt);
if (nargin>=3)
  jdf=conv(jd(:),box);
  jdf=jdf(nbox:(length(jdf)-(nbox-1)));
end
if (nargin==4)
  ufilt=ufilt([1:nsamp:m],:);
  jdf=jdf([1:nsamp:m]);
end

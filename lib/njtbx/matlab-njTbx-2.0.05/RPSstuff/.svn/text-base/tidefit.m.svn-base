function [ucoef,ngood,unew]=tidefit(jd,uu,period,jdnew)
%TIDEFIT  Simple tide fit.  Fits sine waves with specified periods to data
%  Usage: [ucoef,ngood,unew]=tidefit(jd,uu,[period],[jdnew])
%  Inputs: jd = datenum time vector 
%      period = periods to fit (hours)    (defaults to [12 6 4] hours if not supplied)
%          uu = input vector time series, or matrix where each column is a time series
%       jdnew = new time base for simulated tide (defaults to original time base if not supplied)
%  Output: ucoef = harmonic coefficients, starting with mean, then cos(f1), then sin(f1), 
%                  up to the number of periods.  Hence there are 2f+1 coefficients.
%          ngood = number of good points in each time series
%          unew  = time series constructed from harmonic constituents (simulated tide)
%        

% Rich Signell (rsignell@usgs.gov)
goplot=0;  
if nargin<3; period=[12.0 6.0 4.0]; end        % can add 24 if interested
[n,m]=size(uu);
[njd,mjd]=size(jd);
if (n~=njd)&(m~=mjd); jd=jd'; end
if n<5; uu=uu.';jd=jd'; [n,m]=size(uu); [njd,mjd]=size(jd); end;
%if n<m; disp('note: time should be first dimension of uu'); end

if nargin<4; jdnew=jd;end;


range=m;
[njdn,mjdn]=size(jdnew);

if njdn==1;jdnew=jdnew'; end;

unew=ones(length(jdnew),range)*nan;

tt=jd*24;
freq=(2.*pi)*ones(size(period))./period;
nfreq=length(freq);

for nn=1:range
%fprintf('%4.0f',nn);
u=uu(:,nn);
   if length(tt(:))==length(uu(:))
         t0=tt(:,nn);
   else
         t0=tt;
   end
      ind=find(~isnan(u));
   nind=length(ind);
   ngood(nn)=nind;

   if nind>length(period)*2+1
      u=u(ind);
      t=t0(ind);
      u=u(:);
      t=t(:);      t0=t0(:);
      nt=length(t);

%------ set up A -------
       A=zeros(nind,nfreq*2+1); 
       A(:,1)=ones(nind,1);
       for j=[1:nfreq]
           A(:,2*j)=cos(freq(j)*t);
           A(:,2*j+1)=sin(freq(j)*t);
       end
%-------solve [A coeff = u] -----------------
%       coef=A\u;
        coef=lscov(A,u);
%-------generate solution components-----
       tnew=jdnew*24;
       
       up=zeros(length(tnew),nfreq*2+1);
       up(:,1)=coef(1)*ones(size(tnew));
       for j=[1:nfreq]
          up(:,j+1)=coef(j*2)*cos(freq(j)*tnew)+coef(j*2+1)*sin(freq(j)*tnew);
       end
       up(:,nfreq+2)=sum(up(:,[1:nfreq+1])')';  % sum of all comps
       unew(:,nn)=up(:,nfreq+2);
             ucoef(:,nn)=coef;
             error=std(A*coef-u)/sqrt(nind-length(period)*2+1);
       if goplot
          jdp=tnew/24;
          plot(jdp(ind),u,'oc5',jdp,up,jdp,unew(:,nn),'x',jdp,zeross(jdp),'w')
             title(sprintf('Least Squares Fit, series %g   error= %5.2g cm/s',nn,error));
             xlabel('julian day');
             ylabel('cm/second')
          pause
       end
else
             ucoef(:,nn)=ones(2*nfreq+1,1)*nan;
end   % if nind> ....
end   %  loop

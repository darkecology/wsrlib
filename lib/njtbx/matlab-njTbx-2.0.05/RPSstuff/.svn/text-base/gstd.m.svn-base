function xnew=gstd(x)
% gstd - just like std, except that it skips over NaN's, Inf's, etc.
%  Usage:  xnew=gstd(x);
%             x can be a vector or matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use of this program is self described.
% Program written in Matlab v7.1.0 SP3
% Program ran on PC with Windows XP Professional OS.
%
% "Although this program has been used by the USGS, no warranty, 
% expressed or implied, is made by the USGS or the United States 
% Government as to the accuracy and functioning of the program 
% and related program material nor shall the fact of distribution 
% constitute any such warranty, and no responsibility is assumed 
% by the USGS in connection therewith."
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
[imax,jmax]=size(x);
if(imax==1),
  imax=jmax;
  jmax=1;
  x=x.';
end
for j=1:jmax
       good=find(isfinite(x(:,j)));
       if length(good)>0
          xnew(j)=std(x(good,j));
       else
          xnew(j)=NaN;
       end
end
function unew=denan(u);
% DENAN removes all the rows of a matrix that contain NaNs.
%   
% unew=DENAN(u);
%
% Version 1.0 (12/4/1996) Rich Signell (rsignell@usgs.gov)
% Version 1.1 (4/16/1999) Rich Signell (rsignell@usgs.gov)
%    fixed bug so that denan now works for single column vectors
%
unew=u;
[m,n]=size(u);
if(n==1),
  ii=find(isnan(u));
else
  ii=find(isnan(sum(u.')));
end
unew(ii,:)=[];

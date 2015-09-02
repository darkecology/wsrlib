function [coast]=fixcoast(coast)
% FIXCOAST  Makes sure coastlines meet Signell's conventions.
%
% Usage:  [coast]=fixcoast(coast)
% 
% Fixes coastline is in the format we
% want.  Assumes that lon/lat are in the first two columns of
% the matrix coast, and that coastline segments are 
% separated by rows of NaNs (or -99999s).  This routine ensures that
% only 1 row of NaNs separates each segment, and makes
% sure that the first and last rows contain NaNs.
%
%
% Rich Signell (rsignell@usgs.gov)

ind=find(coast==(-99999.));
if(~isempty(ind)),
  coast(ind)=coast(ind)*nan;
end
ind=find(isnan(coast(:,1)));
if(~isempty(ind)),
  dind=diff(ind);
  idup=find(dind==1);
  if(~isempty(idup)),
    coast(ind(idup),:)=[];
    ind(idup)=[];
  end
end
[m,n]=size(coast);
if(~isnan(coast(1,1))),
  coast=[ones(1,n)*nan; coast];
end
[m,n]=size(coast);
if(~isnan(coast(m,1))),
  coast=[coast; ones(1,n)*nan];
end

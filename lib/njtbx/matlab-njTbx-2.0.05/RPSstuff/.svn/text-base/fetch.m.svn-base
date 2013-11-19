function [dist]=fetch(xc,yc,xp,yp,angs,iplot)
% FETCH calculate fetch from points to coastline
%  [dist]=fetch(xc,yc,xp,yp,angs,[iplot])
% inputs:  
%          xc = coast x locations (m)
%          yc = coast y locations (m)
%          xp = x locations (m)
%          yp = y locations (m)
%          angs = vector of angles to lookup 
%          iplot = optional argument to plot the coastline & fetch 
% Note: the coast should be arranged so that "fillseg([xc yc])" displays filled 
% if not, use "join_cst" and/or manually edit the first points on the longest coastline
% segment so that it closes correctly

% Find points inside polygon (land assumed inside)
%  ind=0 outside polygon
%  ind=1 inside
%  ind=2 on exterior edge
%  ind=4 on exterior vertex
X=[xc yc]; X2=fixcoast(X); xc=X2(:,1); yc=X2(:,2);
ii=find(isnan(xc));
nseg=length(ii)-1;
mask=ones(size(xp));
if(nseg>0),
  for iseg=1:nseg;   % look through coast segments
     i1=ii(iseg)+1;
     i2=ii(iseg+1)-1;
     ind=i1:i2;
     ind=insider(xp,yp,xc(ind),yc(ind));
     iland=find(ind>0);
     mask(iland)=0;
  end
end
iwater=find(mask==1);

%preallocate fetch distance array
dist=ones(length(xp),length(angs))*nan;

%determine extents of grid
xcmax=max(xc(:)); xcmin=min(xc(:)); 
ycmax=max(yc(:)); ycmin=min(yc(:));
distmax=abs((xcmax-xcmin)+sqrt(-1)*(ycmax-ycmin));
clf
if exist('iplot'),fillseg([xc yc]);dasp;end
for i=1:length(iwater);
  for j=1:length(angs); 
     aang=angs(j);
% make a long line in the fetch direction
     [x,y]=xycoord([0 distmax],[aang aang]);
     xline=xp(iwater(i))+x;   
     yline=yp(iwater(i))+y;
% find crossings of this line with coastline
     icross=crossings(xc,yc,xline,yline);
     ii=find(icross>0);
     xland=interp1(1:length(xc),xc,icross(ii));
     yland=interp1(1:length(yc),yc,icross(ii));
% find distance from coastline crossings to our point
     X1=xland+sqrt(-1)*yland;
     X2=xp(iwater(i))+sqrt(-1)*yp(iwater(i));
     dists=abs(X1-X2);
     ind=find(dists==min(dists));
     dist(iwater(i),j)=dists(ind);
if exist('iplot'),line([xp(iwater(i)) xland(ind)],...
  [yp(iwater(i)) yland(ind)],'color','red','marker','o');end
     xfetch(iwater(i),j)=xland(ind);
     yfetch(iwater(i),j)=yland(ind);
  end
end

function [h]=fillseg(X,c1,c2);
% FILLSEG  Fills polygon line segments separated by [nan nan] (eg. Coastline data)
%   
%  Usage:  [h]=fillseg(x,c1,c2);
%
%  Inputs:  x = two column matrix with x and y values, where  
%               line segments are separated by [nan nan].
%           c1 =  color for polygon fill ([r g b])
%           c2 =  edgecolor for polygon ([r g b])
%
% If c1 and c2 can be three column matrices, the first row is used to
% fill the first segment, the second row is used to fill the second segment, etc.
%
% Rich Signell  (rsignell@usgs.gov)
%
if(nargin==1),
  c1=[.7 .7 .7];  % default to light grey fill if none supplied
  c2=[0 0 0];     % default to black edges if none supplied
elseif(nargin==2);
  c2=[0 0 0];
end
X=fixcoast(X);
ii=find(isnan(X(:,1)));
nseg=length(ii)-1;
if(nseg>0),
% fill out matrix c1 and c2
if(length(c1(:))==3),
  c1=ones(nseg,1)*c1;
  c2=ones(nseg,1)*c2;
elseif(length(c1(:))~=(3*nseg)),
  [m,n]=size(c1);
  clast=c1(m,:);
  c=clast(ones(nseg,1),:);
  c(1:m,:)=c1(1:m,:);
  c1=c;
  [m,n]=size(c2);
  clast=c2(m,:);
  c=clast(ones(nseg,1),:);
  c(1:m,:)=c2(1:m,:);
  c2=c;
end
for iseg=1:nseg;
     i1=ii(iseg)+1;
     i2=ii(iseg+1)-1;
     ind=i1:i2;
     h(iseg)=patch(X(ind,1),X(ind,2),c1(iseg,:));...
       set(h(iseg),'edgecolor',c2(iseg,:));
  end
end

function [new_coast,iseg]=join_cst(coast,tol);
% JOIN_CST  Makes continuous coastline from fragmented segments.
%
%   USAGE: [new_coast,iseg]=join_cst(coast,tol);
%
%   Inputs: coast =  contains the x and y coastline positions
%                    in the first two columns, and coastine segments are
%                    separated by a row containing [NaN NaN] or [-99999. -99999.],
%
%           tol = the distance within which coastline segments will be joined. 
%
%   Outputs:
%            new_coast = the new joined coastline, sorted from largest segment
%                        to smallest segment.

%            iseg      = vector containing the indices of the line breaks 
%
%   Description: Makes continous coastline from fragmented segments
%           joining endpoints of segments less than 
%           TOL distance apart.   The resulting coastline can be
%           used for blanking or filling by adding in a few extra 
%           points, and the islands will also be polygons.  This routine 
%           draws the new coastline as it works so you can see it's progress.
% 
%
% Rich Signell               |  E-mail: rsignell@crusty.er.usgs.gov
%  
% requires FIXCOAST.M
%

coast=fixcoast(coast);   %replace -99999. with NaN, eliminate dup NaNs, etc.

plot(coast(:,1),coast(:,2),'g-');set(gca,'aspectratio',[nan 1]);
figure(gcf);

iseg=find(isnan(coast(:,1)));
nseg=length(iseg)-1;
irem=ones(nseg,1);
z=coast(:,1)+sqrt(-1)*coast(:,2);
zstart=z(iseg(1:nseg)+1);
zstop=z(iseg([2:(nseg+1)])-1);
zends=[zstart(:) zstop(:)];

znew=nan+sqrt(-1)*nan;
k=0;

%while there are remaining segments, process
while(~isempty(find(irem))),
%start at 1st remaining segment
ii=find(irem);
id0=ii(1);
id=id0;
z0=z(iseg(id)+1);   %first point on segment
zind=[(iseg(id)+1):(iseg(id+1)-1)];
line(real(z(zind)),imag(z(zind)),'erasemode','none','color','blue')
zc=z(iseg(id+1)-1); %last point on segment

irem(id)=0;    %add current segment to list of segments used 

found_next=1;
tried_reverse=0;
while (found_next),
  ii=find(irem);     %indices of remaining segments
  nrem=length(ii);
  dgap=abs((ones(size(zends(ii,:))))*zc-zends(ii,:));  
  id=find(dgap<tol);
  if(~isempty(id)),
    idt=find(dgap==min(dgap(:)));                       % find closest points
    idt=idt(1);                                %take first if  equal dist
    if(idt>nrem),                              %found stop point of segment
      id=ii(idt-nrem);                   %find which segment we matched 
      zi=[(iseg(id+1)-1):-1:(iseg(id)+1)];  %segment coordinates
    else                                       %found start point of segment
      id=ii(idt);                        %find which segment we matched 
      zi=[(iseg(id)+1):1:(iseg(id+1)-1)];   %segment coordinates
    end
    ni=length(zi);
    line(real(z(zi)),imag(z(zi)),'erasemode','none','color','blue') %draw seg
    irem(id)=0;             %mask out segment
    zc=z(zi(ni));              %next connecting point
    zind=[zind zi];         %add segment to index list
  else
    if(~tried_reverse),
      zc=z0;
      nzind=length(zind);
      zind=zind([nzind:-1:1]);
      tried_reverse=1;
    else
      found_next=0;
    end
  end
end
k=k+1
znew=[znew; nan+sqrt(-1)*nan; z(zind)];   %add on new contatenated segment 
end
znew=[znew; nan+sqrt(-1)*nan];  %add nan on end
iseg=find(isnan(znew));
nseg=length(iseg)-1;
slen=(iseg([2:(nseg+1)])-iseg(1:nseg)-2);    %data pts in segments
[y,isort]=sort(slen);
isort=flipud(isort);
zind=[];
%sort largest to smallest
for i=1:nseg;
  zind=[zind (iseg(isort(i)):iseg(isort(i)+1))];
end
znew=znew(zind);
new_coast=[real(znew) imag(znew)];
new_coast=fixcoast(new_coast);
iseg=find(isnan(new_coast(:,1)));
nseg=length(iseg)-1;
slen=(iseg([2:(nseg+1)])-iseg(1:nseg)-2);    %data pts in segments

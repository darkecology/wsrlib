function []=mapax(nminlong,ndiglong,nminlat,ndiglat);

%   MAPAX  Puts degrees and minutes on map axes instead of decimal degrees
%
%   Usage: mapax(nnminlong,ndiglong,nminlat,ndiglat);
%
%   Inputs:
%          nminlon  = minutes of spacing between longitude labels
%          ndiglong = number of decimal places for longitude minute label
%
%          nminlon  = minutes of spacing between latitude labels
%          ndiglong = number of decimal places for latitude minute  label
%
% Example:  mapax(15,1,20,0);   
%               labels lon every 15 minutes with 1 decimal place (eg 70 40.1')
%           and labels lat every 20 minutes with no decimal place (eg 42 20')
%
% Version 1.0 Rocky Geyer  (rgeyer@whoi.edu)
% Version 1.1 J. List (6/5/95) had apparent bug with
%  ndigit being set to 0: routine degmins blows up.
%  Fixed by adding arguments specifying number of decimal
%  digits (can vary from 0 to 2)
% Version 1.2 W. Sheldon (4/20/98) corrected rounding errors
%  when fractional minutes specified, and added support for precision
%  beyond 2 decimal places
% Version 1.3  Rich Signell (6/11/99) Found the BUG!!!  When the 
%  first "nice" tick is determined, CEIL should have been used instead
%  of FLOOR so that the first tick is actually on the axis!

if nargin==1;
   nminlat=nminlong;
end;
if nargin==2;
   nminlat=ndiglong;
   ndiglat=0;
   ndiglong=0;
end;   

nfaclong=60/nminlong;
nfaclat=60/nminlat;

if nminlong>0;

xlim=get(gca,'xlim');
% RPS 6/11/99 -- FLOOR is wrong!  It should be CEIL, so that
%   the 1st tick is on the plot!
%xlim(1)=floor(xlim(1)*nfaclong)/nfaclong;
xlim(1)=ceil(xlim(1)*nfaclong)/nfaclong;
xtick=xlim(1):1/nfaclong:xlim(2);
set(gca,'xtick',xtick);

% modified 6/5/95 J.List:

xticklab=degmins(-xtick,ndiglong);

set(gca,'xticklabel',xticklab);

end;


if nminlat>0;

ylim=get(gca,'ylim');

% RPS 6/11/99 -- FLOOR is wrong!  It should be CEIL, so that
%   the 1st tick is on the plot!
%ylim(1)=floor(ylim(1)*nfaclat)/nfaclat;
ylim(1)=ceil(ylim(1)*nfaclat)/nfaclat;
ytick=ylim(1):1/nfaclat:ylim(2);
set(gca,'ytick',ytick);

% modified 6/5/95 J.List:

yticklab=degmins(-ytick,ndiglat);

set(gca,'yticklabel',yticklab);

end;




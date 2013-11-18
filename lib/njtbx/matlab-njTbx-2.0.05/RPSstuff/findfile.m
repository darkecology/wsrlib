function [filenum,istep]=findfile(greg0,start,dt,nt);
% function [filenum,istep]=findfile(greg0,start,dt,nt);
% greg0 =desired gregorian time
% start = start of model run
% dt = time step in hours
% nt = number of steps per his file
% example:
%   [filenum,istep]=findfile([2003 1 26 0 0 0],[2002 9 17 0 0 0],3,32);
jd0=julian(greg0);
jdstart=julian(start);
t=jd0-jdstart;
thours=t*24;
filenum=floor(thours/dt/nt)+1;
istep=rem(thours/dt/nt,filenum-1)*nt;

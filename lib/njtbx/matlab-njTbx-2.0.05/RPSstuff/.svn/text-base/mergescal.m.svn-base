function [wi,jd]=mergescal(cdflist,uname,start,stop,dt);
% MERGESCAL   Merges scalar data from multiple EPIC time series files
%             onto a uniform time base (perhaps with gaps)
% 
%
% Usage: [u,jd]=mergescal(cdflist,uname,start,stop,dt);
%
%      Inputs:  cdflist = array of netcdf file names, one name per row 
%               uname = character string containing the variable name 
%                       that you want to contatenate
%                       (must be found in all files in CDFLIST)
%               start =  gregorian start time
%               stop  =  gregorian stop time
%               dt    =  time interval (seconds) for concatenated time series
%
%      Outputs: u = new scalar time series with uniform time base
%              jd = corresponding julian day time base 
%
%      Example:  [u,jd]=mergescal(['file_1.nc '
%                                   'file_2.nc '
%                                   'file_10.nc'],...
%                   'T_20',[1997 4 1 8 0 0],[1998 8 2 0 0 0],3600);
%
%       This merges temperature from three different deployments onto
%       a uniform hourly time base beginning at April 1, 1998, 0800 UTC
%       and ending August 2, 0000 UTC.

%   Rich Signell, USGS  rsignell@usgs.gov  (August 7, 1998)

jd0=julian(start);
jd1=julian(stop);
% number of points
npts=((jd1-jd0)/(dt/3600/24))+1;
jdi=0:npts-1;
jdi=jdi*dt;     %time in seconds from start
wi=jdi*NaN;

[m,n]=size(cdflist);
for icdf=1:m,
  cdf=cdflist(icdf,:);
  ind=min(find(cdf==' '));
  if(length(ind)>0),
    cdf=cdf(1:ind-1);
  end
%  [w,jd]=getts(cdf,uname,start,stop);
  cdf
  [w,jd]=getts(cdf,uname);
  if(isempty(w)==0),
% convert to seconds from start
    jd=(jd-jd0)*24*3600;
    w=interp1(jd,w,jdi);
    ind=find(~isnan(w));
    wi(ind)=w(ind);
  end
end
wi=wi(:);
jd=jd0+jdi/3600/24;

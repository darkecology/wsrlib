function [wi,jd]=mergevec(cdflist,uname,vname,start,stop,dt);
%function [w,jd]=mergevec(cdflist,uname,vname,start,stop,dt);
% MERGEVEC   Merges vector data from multiple EPIC time series files
%             onto a uniform time base (perhaps with gaps)
%
%
% Usage: [w,jd]=mergevec(cdflist,uname,vname,start,stop,dt);
%
%      Inputs:  cdflist = array of netcdf file names, one name per row
%               uname = character string containing the "east" variable name
%                       that you want to contatenate
%                       (must be found in all files in CDFLIST)
%               vname = character string containing the "north" variable name
%               start =  gregorian start time
%               stop  =  gregorian stop time
%               dt    =  time interval (seconds) for concatenated time series
%
%      Outputs: w = new vector time series with uniform time base (complex)
%              jd = corresponding julian day time base
%
%      Example:  [w,jd]=mergevec(  ['file_1.nc '
%                                   'file_2.nc '
%                                   'file_10.nc'],...
%                   'u_1205','v_1206',[1997 4 1 8 0 0],[1998 8 2 0 0 0],3600);
%
%       This merges velocity from three different deployments onto
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
  cdf
  [w,jd]=getvel(cdf,uname,vname,start,stop);
  if(isempty(w)==0),
% convert to seconds from start
    jd=(jd-jd0)*24*3600;
    w=interp_r(jd,w,jdi);
    ind=find(~isnan(w));
    wi(ind)=w(ind);
  end
end
wi=wi(:);
jd=jd0+jdi/3600/24;

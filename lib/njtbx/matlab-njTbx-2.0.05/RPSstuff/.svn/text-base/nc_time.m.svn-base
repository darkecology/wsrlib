function jd=nc_time(ncfile,arg);
% NC_TIME returns datenum format "time" or "ocean_time" 
% variable in NetCDF file
% Usage: jdmat=nc_time(ncfile);
% Warning: Only NetCDF time units encoded as " units since YYYY-MO-DA" are
% handled properly by this routine and time starting at midnight UTC is assumed

% Rich Signell  (rsignell@usgs.gov)

nc=netcdf(ncfile);
if isempty(nc), return, end
s=nc{'time'}.units(:);
if isempty(s),
 s=nc{'ocean_time'}.units(:);
 tim=nc{'ocean_time'}(:);
else
 tim=nc{'time'}(:);
end

n=findstr(s,'since');
units=lower(s(1:n-2));
j=findstr(s,'-');
if(isempty(j)),
  j=findstr(s,'/');
end
j1=j(1);j2=j(2);
yr=str2num(s((j1-4):(j1-1)));
mo=str2num(s((j1+1):(j2-1)));
da=str2num(s((j2+1):(j2+2)));
if strmatch(units,'days'),
  jdmat=datenum(yr,mo,da,0,0,0)+tim;
elseif strmatch(units,'hours'),
  jdmat=datenum(yr,mo,da,0,0,0)+tim/24;
elseif strmatch(units,'seconds'),
  jdmat=datenum(yr,mo,da,0,0,0)+tim/(3600*24);
else
  disp('time unit not known');
end
close(nc);
jd=jdmat;
if(nargin>1),
if(strcmp('rps',lower(arg))),
  jd=jdmat+1721059;   %  matlab datenum to 'rps' julian time
end
end

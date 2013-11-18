function jdmat=swantime(a);
% SWANTIME  converts SWAN default time format to DATENUM format
% Usage: jdmat=swantime(a);
if (isstr(a)),
  a=str2num(a);
end
year=floor(a/1e4);
a=a-year*1e4;
mon=floor(a/1e2);
a=a-mon*1e2;
day=floor(a);
a=a-day;
hour=floor(a*1e2);
a=a-hour/1e2;
min=floor(a*1e4);
a=a-min/1e4;
sec=floor(a*1e6);
jdmat=datenum(year,mon,day,hour,min,sec);

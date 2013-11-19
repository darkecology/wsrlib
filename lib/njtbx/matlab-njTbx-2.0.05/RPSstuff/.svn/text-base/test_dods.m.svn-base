%test dods
dods_base='http://stellwagen.er.usgs.gov/cgi-bin/nph-dods';
file='/DATAFILES/CAPE_COD_BAY/3051A-A1H.cdf';
url=[dods_base file]
for i=1:50,
    nc=netcdf(url);
    i
    time(i)=nc{'time'}(i);
    close(nc);
end

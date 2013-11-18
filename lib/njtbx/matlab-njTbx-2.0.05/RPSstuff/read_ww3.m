%read Wave Watch 3 (WW3) grib file
a=read_grib('nww3.HTSGW.grb',1,1,1,1);
nx=a.gds.Ni;
ny=a.gds.Nj;

lon1=a.gds.Lo1;
lon2=a.gds.Lo2;
lat1=a.gds.La1;
lat2=a.gds.La2;
dx=(lon2-lon1)/(nx-1);
dy=(lat2-lat1)/(ny-1);
lat=lat1:dy:lat2;
lon=lon1:dx:lon2;
hsig=reshape(a.fltarray,nx,ny);
hsig(hsig>1000)=nan;
hsig=hsig.';
pslice(lon,lat,hsig);





function [lon,lat,z,url]=read_srtm30plus(lon_range,lat_range,res,iplot);
% READ_SRTM30PLUS  Read SRTM30+ ~1km) World topo/bathy into Matlab via WMS
% Usage:   [lon,lat,depth]=read_srtm30plus(lon_range,lat_range,res,iplot);
%  Inputs: lon_range=[lon_min lon_max] (decimal degrees, east positive)
%          lat_range=[lat_min lat_max] (decimal degrees, north positive)
%          res = optional resolution of requested grid (arc seconds) [default=30]
%          iplot = option to control plot. (1 for plot) [default=0]
%          
%  Outputs:lon = vector of longitudes
%          lat = vector of latitudes
%          z  = topography/bathymetry in meters (up positive)
%               NOTE: SRTM30+ data are integers, therefore flat shallow
%               areas will have a stair-step behavior, and gentle sloping
%               coastal areas will have poorly defined coastlines (z=0).
%          url = the url sent to the WMS
%
%  Examples: [lon,lat,z]=read_srtm30plus([10 20],[40 46],30,1); 
%               Reads and plots 30" topo/bathy for the Adriatic Sea
%
%            [lon,lat,z,url]=read_srtm30plus([-71 -65],[40 46],60);
%               Reads topo/bathy averaged to 60" for the Gulf of Maine (no
%             plot)

% Full SRTM30PLUS info:  http://topex.ucsd.edu/WWW_html/srtm30_plus.html

% Rich Signell (rsignell@usgs.gov)

if(nargin<3);iplot=0;res=30;end
if(nargin<4);iplot=0;end
if(nargin>4);help read_srtm30plus;end
ds=res/3600;
lon_range=round(lon_range/ds)*ds; 
lat_range=round(lat_range/ds)*ds; 
lon=(lon_range(1)+ds/2):ds:(lon_range(2)-ds/2);  % 30 sec resolution
lat=(lat_range(1)+ds/2):ds:(lat_range(2)-ds/2);  
nx=length(lon);
ny=length(lat);
%wms_server='http://maps.gdal.org/cgi-bin/mapserv_dem?';
%wms_layer='srtmplus_raw';
wms_server='http://onearth.jpl.nasa.gov/wms.cgi?';
wms_layer='srtmplus';
wms_proj='EPSG:4326';
wms_format='image/geotiff&version=1.1.1';
wms_max_width=4096;  %maximum image width allowed (WMS server dependent)
wms_max_height=4096; %maximum image height allowed (WMS server dependent)
if(nx>wms_max_width);
    sprintf('Maximum image width %d exceeded.  Please try again.',wms_max_width)
    lon=nan;lat=nan;z=nan;
    return
end
if(ny>wms_max_height);
    sprintf('Maximum image height %d exceeded.  Please try again.',wms_max_height)
    lon=nan;lat=nan;z=nan;
    return
end
% The WMS query specifies a lon,lat range and also the desired size of the image in
% pixels.  We request an image size that gives us the original 30 second data values
url=sprintf('%srequest=GetMap&styles=short_int&layers=%s&bbox=%d,%d,%d,%d&SRS=%s&TRANSPARENT=FALSE&width=%d&height=%d&format=%s',...
    wms_server,wms_layer,lon_range(1),lat_range(1),lon_range(2),lat_range(2),wms_proj,nx,ny,wms_format)
pix=imread(url,'tif');
z=flipud(double(pix));
ind=find(z>32768);% values greater than 32768 are actually negative values
z(ind)=z(ind)-65536;
if iplot
  imagesc(lon,flipud(lat),z);set(gca,'ydir','normal');colorbar
  xfac=cos(mean(lat(:))*pi/180);set(gca,'DataAspectRatio', [1 xfac 1] );
  if(max(z(:))*min(z(:))<0),
    hold on;
    contour(lon,lat,z,[0 0],'k-');
    hold off;
    title('SRTM30+ World Topo/Bathy');
  end
end
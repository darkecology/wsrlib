% BATHY_COMP - plot comparison between two bathymetry datasets
%  
%   uri1 = URI of CF-compliant bathymetry (NetCDF file, OpenDAP)
%   uri2 = URI of CF-compliant bathymetry 
%   ax   = bounding box [lon_min lon_max lat_min lat_max] 
%                  (decimal degrees east and north)
%   cax =  color range [cmin cmax]  (defaults to full range)
%
% e.g,
%   uri1='http://coast-enviro.er.usgs.gov/thredds/dodsC/bathy/srtm30plus_v1.nc';
%   uri2='http://coast-enviro.er.usgs.gov/thredds/dodsC/bathy/srtm30plus_v3.nc';
%   ax=[-71 -70 41 42];
%   cax=[-100 0];  
% 
% See: http://coast-enviro.er.usgs.gov/thredds/bathy_catalog.html
% for more bathymetry datasets
%
% rsignell@usgs.gov (28-Apr-2008)

%% Specify input variables

  uri1='http://coast-enviro.er.usgs.gov/thredds/dodsC/bathy/smith_sandwell_v11';
  uri2='http://coast-enviro.er.usgs.gov/thredds/dodsC/bathy/etopo1_bed_g2';
  ax=[-71 -70 41 42];
  cax=[-100 0];


%% Call njTBX functions

[h1,g1]=nj_subsetGrid(uri1,'topo',ax);
[h2,g2]=nj_subsetGrid(uri2,'topo',ax);

%% Plot data

clf;set(gcf,'color','white');
ax1=axes('pos',[.1 .1 .35 .8]);
pcolorjw(g1.lon,g1.lat,double(h1));dasp(mean(g1.lat(:)));
set(gca,'tickdir','out');
caxis(cax);
ii=strfind(uri1,'/');
if ~isempty(ii),
   title(uri1(ii(end)+1:end),'interpreter','none');
else
    title(uri1,'interpreter','none');
end
ax2=axes('pos',[.5 .1 .35 .8]);
pcolorjw(g2.lon,g2.lat,double(h2));dasp(mean(g2.lat(:)));
set(gca,'tickdir','out');
set(gca,'yticklabel',' ');
caxis(cax);
ii=strfind(uri2,'/');
if ~isempty(ii),
   title(uri2(ii(end)+1:end),'interpreter','none');
else
    title(uri2,'interpreter','none');
end
pclegend(cax',[.95 .3 .02 .4],gcf,'m');

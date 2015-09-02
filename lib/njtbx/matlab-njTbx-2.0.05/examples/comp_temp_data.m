% COMP_TEMP_DATA - Compare temperature data from various model output and observations
%
% A script to compare temperature data from AVHRR SST from NOAA
% CoastWatch), UMASSB-ECOM (Mass Bay) and  UMAINE-POM (Gulf Wide)
%
% rsignell@usgs.gov

%% Specify input variables
var='temp';
%date='01-Jul-2008 09:32';
date=now;
%cax='auto'
cax=[1 7];
ax=[-71.1390  -69.6150   41.6479   43.2754]; %mass bay


% Model 1: UMASSB-ECOM (Mass Bay)
uri1 ='http://coast-enviro.er.usgs.gov/thredds/dodsC/gom_interop/umassb/latest';
ilev1=1; % surface is layer 1

% Model 2: UMAINE-POM (Gulf Wide)
uri2 ='http://coast-enviro.er.usgs.gov/thredds/dodsC/gom_interop/umaine/latest';
ilev2=1; % surface is layer 1

% DATA: AVHRR SST from NOAA CoastWatch)
uri3='http://coastwatch.chesapeakebay.noaa.gov/thredds/dodsC/remote_sensing/avhrr';
var3='sst';

% load GOM coastline
load gom_coast.mat coast

%% Call njTBX functions

% AVHRR SST
[sst,g3]=nj_subsetGrid(uri3,var3,ax,date);
date_data=g3.time;

% UMASSB-ECOM
jd1=nj_time(uri1,var);
itime1=date_index(jd1,date_data);
[d1,g1] = nj_grid_varget(uri1,var,[itime1,ilev1,1,1],[1,1,inf,inf]);

% UMAINE-POM
jd2=nj_time(uri2,var);
itime2=date_index(jd2,date_data);
[d2,g2] = nj_grid_varget(uri2,var,[itime2,ilev2,1,1],[1,1,inf,inf]);

%% Plot data

clf;set(gcf,'color','white');

set(gcf,'pos',[ 71   347   985   451]);
ax1=axes('pos',[.05 .1 .25 .8]);
pcolorjw(g1.lon,g1.lat,double(d1));dasp(mean(g1.lat(:)));
fillseg(coast);
set(gca,'tickdir','out');
caxis(cax);
ii=strfind(uri1,'/');
if ~isempty(ii),
   title([uri1(ii(end-1)+1:ii(end)-1) ':' datestr(g1.time)],'interpreter','none');
else
    title(uri1,'interpreter','none');
end

axis(ax);

ax2=axes('pos',[.35 .1 .25 .8]);
pcolorjw(g2.lon,g2.lat,double(d2));dasp(mean(g2.lat(:)));
fillseg(coast);
set(gca,'tickdir','out');
set(gca,'yticklabel',' ');
caxis(cax);
ii=strfind(uri2,'/');
if ~isempty(ii),
   title([ uri2(ii(end-1)+1:ii(end)-1) ':' datestr(g2.time)],'interpreter','none');
else
    title(uri2,'interpreter','none');
end

axis(ax);

ax3=axes('pos',[.65 .1 .25 .8]);
pcolorjw(g3.lon,g3.lat,double(sst));dasp(mean(g3.lat(:)));
fillseg(coast);
set(gca,'tickdir','out');
set(gca,'yticklabel',' ');
caxis(cax);
title(['AVHRR SST: ' datestr(g3.time)])

pclegend(cax',[.95 .3 .02 .4],gcf,'degrees C');


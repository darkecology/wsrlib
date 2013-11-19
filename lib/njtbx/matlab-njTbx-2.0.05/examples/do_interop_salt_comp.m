% DO_INTEROP_SALT_COMP - Compare model forecast surface salinities
%
% Rich Signell (rsignell@usgs.gov)

%% Specify input variables

% UMASSB (Mass Bay)
uri1 ='http://coast-enviro.er.usgs.gov/thredds/dodsC/gom_interop/umassb/latest';
ilev1=1; % surface is layer 1
var1='salt';

% UMAINE (Gulf Wide)
uri2 ='http://coast-enviro.er.usgs.gov/thredds/dodsC/gom_interop/umaine/latest';
ilev2=1; % surface is layer 1
var2='salt';

%% Call njTBX functions

jd1=nj_time(uri1,var1);
jd2=nj_time(uri2,var2);

itime2=length(jd2);  % choose last time from MODEL2
itime1=near(jd2(end),jd1); % choose time in MODEL1 closest to last time in MODEL 2

[d1,g1] = nj_grid_varget(uri1,var1,[itime1,ilev1,1,1],[1,1,inf,inf]);
[d2,g2] = nj_grid_varget(uri2,var2,[itime2,ilev2,1,1],[1,1,inf,inf]);
%cax='auto'
cax=[30 35];

%% Plot data

clf;set(gcf,'color','white');
ax1=axes('pos',[.1 .1 .35 .8]);
pcolorjw(g1.lon,g1.lat,double(d1));dasp(mean(g1.lat(:)));
set(gca,'tickdir','out');
caxis(cax);
ii=strfind(uri1,'/');
if ~isempty(ii),
   title([uri1(ii(end-1)+1:ii(end)-1) ':' datestr(g1.time)],'interpreter','none');
else
    title(uri1,'interpreter','none');
end
ax1=axis;

ax2=axes('pos',[.5 .1 .35 .8]);
pcolorjw(g2.lon,g2.lat,double(d2));dasp(mean(g2.lat(:)));
set(gca,'tickdir','out');
set(gca,'yticklabel',' ');
caxis(cax);
ii=strfind(uri2,'/');
if ~isempty(ii),
   title([ uri2(ii(end-1)+1:ii(end)-1) ':' datestr(g2.time)],'interpreter','none');
else
    title(uri2,'interpreter','none');
end
axis(ax1);

pclegend(cax',[.95 .3 .02 .4],gcf,'ppt');


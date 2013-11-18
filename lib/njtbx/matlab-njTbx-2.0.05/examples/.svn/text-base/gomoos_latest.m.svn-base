% GOMOOS_LATEST - Grab alongshore velocity 
% Along a onshore/offshore section from latest GOMOOS-UMAINE-POM run, 
% averaging over 24 hours to remove tide
%
% Uses:
%
% SW_DIST - SEAWATER toolkit
%
% DASP, PCOLORJW - RPSstuff toolkit
%
% Rich Signell (rsignell@usgs.gov)

%% Specify input variables
tic
% Access latest GoMOOS forecase via  THREDDS OPeNDAP 
uri='http://coast-enviro.er.usgs.gov/thredds/dodsC/gom_interop/umaine/latest';

%% Call njTBX functions

% Get U component of velocity along this section:
ii=92;
jj=85:110;

jd=nj_time(uri,'temp');
nt=length(jd);
itime=nt-7:nt;  % time steps to average over (8 steps @ 3 hours = 24 hours)
levs=1:22;  % get these vertical levels
% get lon,lat,z
istep=nt-3;
disp('accessing data...');
[t,t_grd] = nj_grid_varget(uri,'u',[istep,1,1,1],[1,inf,inf,inf]);

lon=t_grd.lon;
lat=t_grd.lat;
%
u=nj_varget(uri,'u',[itime(1) levs(1) jj(1) ii(1)],...
    [length(itime) length(levs) length(jj) length(ii)]);
umean=squeeze(mean(u));
dist=sw_dist(lat(jj,ii),lon(jj,ii),'km');
x=[0 cumsum(dist(:).')];
z=t_grd.z(:,jj,ii);
[nz,ny]=size(umean);
x=ones(nz,1)*x;

%% Plot data

%plot section
figure;
set(gcf,'color','white');
set(gcf,'pos',[ 384   294   672   504]);
[c,h]=contourf(max(x(:))-x,z,double(umean),[-.5:.02:.5]);hc=colorbar;
set(get(hc,'YLabel'),'String','m/s');
hold on;
[c2,h2]=contourf(max(x(:))-x,z,double(umean),[0 0]);
set(h2,'linewidth',2);
hold off;
%pcolorjw(max(x(:))-x,z,double(umean));colorbar

titl=sprintf('UMAINE-POM: Daily-Averaged Alongshore Velocity: %s',...
    datestr(t_grd.time));
title(titl);
xlabel('Distance offshore (km)');
ylabel('Depth (m)');

% plot location of section as inset
h3=axes('pos',[0.15 .15 .3 .3]);
pcolorjw(lon,lat,squeeze(double(t_grd.z(end,:,:))));
caxis([-300 0]);dasp(44);
title('Transect Location:');
line(lon(jj,ii),lat(jj,ii),'color','black','linewidth',2);
axis off
toc








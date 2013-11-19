% DO_INTEROP_DATA: Demonstrate Model/Data comparison of Profile data
%
% Rich Signell (rsignell@usgs.gov)

%% Specify input variables

% Observation
uri_obs='http://coast-enviro.er.usgs.gov/models/test/OC412_412078.nc';  
%UMAINE
uri_1='http://coast-enviro.er.usgs.gov/thredds/dodsC/gom_interop/umaine/2005';
%WHOI
uri_2='http://coast-enviro.er.usgs.gov/thredds/dodsC/gom_interop/whoi/2005_his';

%% Call njTBX functions

% obs
[t,t_grd] = nj_grid_varget(uri_obs,'temperature',[1,1,1,1],[1,inf,inf,inf]);
jd_obs=t_grd.time;

% load 3D field from MODEL 1
jd_mod=nj_time(uri_1,'temp');
itime=near(jd_mod,jd_obs);
[t1,t1_grd] = nj_grid_varget(uri_1,'temp',[itime,1,1,1],[1,inf,inf,inf]);

% load 3D field from MODEL 2
jd_mod=nj_time(uri_2,'temp');
itime=near(jd_mod,jd_obs);
[t2,t2_grd] = nj_grid_varget(uri_2,'temp',[itime,1,1,1],[1,inf,inf,inf]);

% extract profile from 3D Field at DATA location (Model 1)
ind=nearxy(t1_grd.lon(:),t1_grd.lat(:),t_grd.lon,t_grd.lat);
[ii,jj]=ind2ij(t1_grd.lat,ind);
zp1=t1_grd.z(:,ii,jj);
tp1=t1(:,ii,jj);

% extract profile from 3D Field at DATA location (Model 2)
ind=nearxy(t2_grd.lon(:),t2_grd.lat(:),t_grd.lon,t_grd.lat);
[ii,jj]=ind2ij(t2_grd.lat,ind);
zp2=t2_grd.z(:,ii,jj);
tp2=t2(:,ii,jj);

%% Plot data

% make the comparison plot
plot(t,t_grd.z,tp1,zp1,tp2,zp2);
thicker;grid;
legend('Data','UMAINE','WHOI');
xlabel('Temp (C)');
ylabel('Depth (m)');
title(sprintf('Gulf of Maine: Time:%s, Lon:%8.4f, Lat:%8.4f',datestr(jd_obs),t_grd.lon,t_grd.lat)); 
set(gcf,'color','white');
figure(gcf);


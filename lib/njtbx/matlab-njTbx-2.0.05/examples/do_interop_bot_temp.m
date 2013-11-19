% DO_INTEROP_BOT_TEMP: Plot modeled and observed bottom temperatures
%
% A diver requested an example of something that would allow him to view
% predicted and observed temperatures in the Gulf of Maine, hence the
% units in Farenheit.
%
% Rich Signell (rsignell@usgs.gov)

% Get latest bottom (actually deepest) temps from buoys.
% Find the URLs to more buoy data at:
% http://gyre.umeoce.maine.edu/buoyhome.php

%% Specify input variables

% GOMOOS Buoy A bottom temp (20 m Temp)
uri_a='http://gyre.umeoce.maine.edu/data/gomoos/buoy/archive/A01/realtime/A01.sbe37.realtime.20m.nc';

% GOMOOS Buoy B bottom temp (50 m Temp)
uri_b='http://gyre.umeoce.maine.edu/data/gomoos/buoy/archive/B01/realtime/B01.sbe37.realtime.50m.nc';

% URI to Umaine's latest forecast

uri_mod='http://coast-enviro.er.usgs.gov/thredds/dodsC/gom_interop/umaine/latest';

%% Call njTBX functions

[Tc_a,ga] = nj_grid_varget(uri_a,'temperature');

[Tc_b,gb] = nj_grid_varget(uri_b,'temperature');

Tf_last=[Tc_a(end) Tc_b(end)]*(9/5)+32;
lon=[ga.lon gb.lon];
lat=[ga.lat gb.lat];

% Get model forecast closest to last observed bottom temperature:

jd=[ga.time(end) gb.time(end)];  % UTC
ind=find(abs(now+4/24-jd)<1); %plot all results within last day
if isempty(ind),
    disp('Sorry, no model data within 24 hours of last observation');
    return
end
jdmax=max(jd(ind));

jdmod=nj_time(uri_mod,'temp');     % retrieve the dates of the forecast
itime=near(jdmod,jdmax);

% retrieve the model forecast data
[Tc,g] = nj_grid_varget(uri_mod,'temp',[itime,1,1,1],[1,inf,inf,inf]);

Tf = (9/5)*Tc+32;   % switch to fahrenheit

%% Plot data

%Plot bottom temperature

pcolorjw(g.lon,g.lat,squeeze(double(Tf(end,:,:)))); shading flat;
dasp(43);
set(gcf,'color','white');

title(['Bottom Temperature (deg F): ' datestr(g.time) ' UTC'])
cax=caxis;

%plot observed bottom temps as colored dots

cdot(lon(ind),lat(ind),Tf_last(ind),jet,20,1,cax);
colorbar

% load and plot a Gulf of Maine coastline
load gom_coast.mat coast
fillseg(coast);



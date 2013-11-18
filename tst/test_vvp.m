%radar_file = 'KBGM20110901_114600_V04.gz';
radar_file = 'KBGM20100911_052711_V03.gz';
%radar_file = 'KBGM20110925_015712_V03.gz';
%radar_file = 'KDOX20090902_104018_V04.gz';  % Legacy resolution
%radar_file = 'KBGM20100930_064817_V03.gz';   % Rain

radar_dir = '/Users/sheldon/projects/data/cajun-test';

filename = sprintf('%s/%s', radar_dir, radar_file);

% Parse the filename to get the station
scaninfo = wsr88d_scaninfo(filename);

% Construct options for rsl2mat
opt = struct();
opt.cartesian = false;
opt.max_elev = 5; 
radar = rsl2mat(filename, scaninfo.station, opt);

rmax = 200000;
dim = 400;

velmap = vrmap2(32);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aliased velocity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1);
im = sweep2cart(radar.vr.sweeps(1), rmax, dim);
imagesc(im);
colormap(velmap);
colorbar();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dealiased velocity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
rmse_thresh = inf;
[ edges, z, u, v, rmse, nll, ~, cnt] = epvvp(radar, 100, 0, rmax, 5000, 'EP', .1, .08, 200);
cnt = cnt(1:end-1);
[radar_dealiased, radar_smoothed] = vvp_dealias(radar, edges, u, v, rmse, rmse_thresh);

figure(2);
im = sweep2cart(radar_dealiased.vr.sweeps(1), rmax, dim);
imagesc(im);
colormap(velmap);
colorbar();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Plot velocity profiles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
I = cnt > 10 & rmse < 5 & z < 5000;

[thet,s] = cart2pol(u, v);
thet = pol2cmp(thet);

figure(3); 

subplot(1, 2, 1);
plot(thet(I), z(I), 'o', 'Linewidth', 2);
xlabel('Direction');
ylabel('Height (m)')
xlim([0 360]);
ylim([0 5000]);

subplot(1, 2, 2);
plot(s(I), z(I), 'o', 'Linewidth', 2);
xlim([0 20]);
ylim([0 5000]);
xlabel('Speed (m/s)');

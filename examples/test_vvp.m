%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ingest data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filename = '../data/KBGM20100911_012056_V03.gz';
station = 'KBGM';

% Parameters for data ingest
opt = struct();
opt.max_elev = 5.5;   % save time by only pulling in lower elevations

% Ingest data
radar = rsl2mat(filename, station, opt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% View velocity image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rmax = 200000;
dim = 400;
im = sweep2cart(radar.vr.sweeps(1), rmax, dim);

figure(1);
imagescnan(im);
colormap(vrmap2(32));
colorbar();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VVP and dealiasing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameters for vvp and dealising. All units are in meters
RMIN  = 5000;
RMAX  = 150000;
ZSTEP = 100;
ZMAX  = 3000;
RMSE_THRESH = inf;
EP_GAMMA = 0.1;

[ edges, z, u, v, rmse, ~, ~, cnt ] = epvvp(radar, ZSTEP, RMIN, RMAX, ZMAX, 'EP', EP_GAMMA);
[radar_dealiased, radar_smoothed] = vvp_dealias(radar, edges, u, v, rmse, RMSE_THRESH);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% View dealiased velocity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2);
im = sweep2cart(radar_dealiased.vr.sweeps(1), rmax, dim);
imagesc(im);
colormap(vrmap2(32));
colorbar();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot velocity profiles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

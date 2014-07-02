%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load radar data
%%%%%%%%%%%%%%%%%%%%%%%%%%

%radar_file = 'data/KDOX20090902_104018_V04.gz';  % Legacy resolution
%radar_file = 'data/KBGM20110901_114600_V04.gz';   % Super resolution
radar_file = 'data/KBGM20100911_052711_V03.gz';

% Parse the filename to get the station
scaninfo = wsr88d_scaninfo(radar_file);

% Construct options for rsl2mat
opt = struct();
opt.max_elev = 4;
opt.cartesian = false;

radar = rsl2mat(radar_file, scaninfo.station, opt);

BADVAL = radar.constants.BADVAL;    % constant representing return < signal-to-noise
sweep = radar.dz.sweeps(1);         % lowest elev. angle dz sweep
data  = sweep.data;
data(data==BADVAL) = 0;             % set BADVAL to 0 dBZ

% Compute azimuth for each ray
[az, col_order] = sort(sweep.azim_v); % sort azimuth angles in increasing order
data = data(:,col_order);             % adjust data order to match

% Compute ranges
range = sweep.range_bin1 + sweep.gate_size*(0:sweep.nbins-1);

% Plot
figure(1); clf();
set(gca, 'FontSize', 20);

imagesc(az, range, data);
axis xy;
xlabel('Azimuth');
ylabel('Range');

rmax = 1500000; % in meters
hmax = 4000;
figure(2);
clf();
fs = 18;
set(gca, 'fontsize', fs);
hold on;
for i=1:numel(radar.dz.sweeps)
    h = plotsweep3d(radar.dz.sweeps(i), rmax, hmax, false);
end
opt = displayopts();
colormap(opt.dzmap);
zlim([0 hmax/1000]);
caxis([0 30])
grid on;

xlabel('x (km)');
ylabel('y (km)');
zlabel('z (km)');

hc = colorbar('fontsize', fs);
xlabel(hc, 'dBZ');


% X = vec(x(I,J));
% Y = vec(y(I,J));
% Z = vec(z(I,J));
% C = vec(data(I,J));
% 
% i = C > 5;
% 
% scatter3(X(i), Y(i), Z(i), 10, C(i), '*');



% figure(2);
% clf();
% set(gca, 'FontSize', 20);
% plot(dist, height);
% xlabel('Distance (m)');
% ylabel('Height (m)');

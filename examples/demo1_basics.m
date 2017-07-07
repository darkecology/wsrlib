%% 0. Help

help wsrlib 
doc wsrlib

%% 1. Read radar file
radar_file = 'data/KBGM20150508_065830_V06.gz';
station    = 'KBGM';

radar = rsl2mat(radar_file, station);

%% 2. Explore data structure

radar                                     % top-level data structure
radar.dz                                  % reflectivity volume
radar.vr                                  % radial velocity volume
radar.dz.sweeps                           % list of sweeps in reflectivity volume
[radar.dz.sweeps.elev]                    % elevation angles of sweeps
radar.dz.sweeps(1)                        % the first sweep
%radar.dz.sweeps(1).data                  % data matrix from first sweep


%% 3. View data matrix from first sweep in polar coordinates
figure(1)
imagesc(radar.dz.sweeps(1).data, [-5 20])
colormap(jet(32)); colorbar();

%% 4. Use sweep2mat to normalize and extract data
%     - sort radials so angles are increasing
%     - set special numerical codes to NaN
[data, range, az] = sweep2mat(radar.dz.sweeps(1));
imagesc(data, [-5 30])

colormap(jet(32)); colorbar();

%% 5. Show image in actual coordinates
imagesc(az, range, data, [-5 20]);

colormap(jet(32)); colorbar();
xlabel('azimuth (degrees)');
ylabel('range');

%% 6. sweep2cart: view data in cartesian coordinates

rmax         = 150000;  % 150km
dim          = 600;     % 600 pixel image
[data, x, y] = sweep2cart(radar.dz.sweeps(1), rmax, dim);

imagesc(x, y, data, [-5 20]);
colorbar();

%% 7. View all products

figure(1); clf();

ax = subplot(2,3,1);
[data, x, y] = sweep2cart(radar.dz.sweeps(1), rmax, dim);
imagesc(x, y, data, [-5 20]);
axis xy;
colormap(ax, jet(32));
colorbar();
title('Reflectivity');

ax = subplot(2,3,2);
[data, x, y] = sweep2cart(radar.vr.sweeps(1), rmax, dim);
imagesc(x, y, data, [-15 15]);
axis xy;
colormap(ax, vrmap2(32));
colorbar()
title('Radial velocity');

ax = subplot(2,3,3);
[data, x, y] = sweep2cart(radar.sw.sweeps(1), rmax, dim);
imagesc(x, y, data, [0 10]);
axis xy;
colormap(ax, jet(32));
colorbar();
title('Spectrum width');

ax = subplot(2,3,4);
[data, x, y] = sweep2cart(radar.dr.sweeps(1), rmax, dim);
imagesc(x, y, data, [-4 8]);
axis xy;
colormap(ax, jet(32));
colorbar();
title('Differential reflectivity');

ax = subplot(2,3,5);
[data, x, y] = sweep2cart(radar.ph.sweeps(1), rmax, dim);
imagesc(x, y, data, [0 250]);
axis xy;
colormap(ax, jet(32));
colorbar();
title('Differential phase');

ax = subplot(2,3,6);
[data, x, y] = sweep2cart(radar.rh.sweeps(1), rmax, dim);
imagesc(x, y, data);
axis xy;
colormap(ax, jet(32));
colorbar();
title('Correlation coefficient');

%% 8. View data from all products as function of azimuth for fixed range

fields = {'dz', 'vr', 'sw', 'dr', 'ph', 'rh'};
names  = {'dBZ', 'v_r', 's.w.', 'diff. refl.', 'diff phase', 'corr. coef.'};

range_lim = [20000 22000];

figure(2); clf();
for i=1:length(fields)

    field = fields{i};
    [data, range, az] = sweep2mat(radar.(field).sweeps(1));
    
    rows = range >= range_lim(1) & range <= range_lim(2);
    
    subplot(6,1,i);
    scatter(az, mean(data(rows,:)), 4);
    xlabel('azimuth');
    ylabel(names{i});
end

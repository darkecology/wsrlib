radar_file = 'data/KBGM20110925_015712_V03.gz';

% Parse the filename to get the station
scaninfo = wsr88d_scaninfo(radar_file);

% Construct options for rsl2mat
opt = struct();
opt.cartesian = false;
radar = rsl2mat(radar_file, scaninfo.station, opt);

[az, range] = get_az_range(radar.dz.sweeps(1));

elev = 0.5;
[s, h] = slant2ground(range, elev);

[range1, elev1] = ground2slant(s, h);

[range2, h1] = groundElev2slant(s, elev);

fprintf('Max range error: %.4e\n', max(abs(range - range1)));
fprintf('Max elev error: %.4e\n',  max(abs(elev - elev1)));

fprintf('Max range error 2: %.4e\n', max(abs(range - range2)));
fprintf('Max height error: %.4e\n',  max(abs(h - h1)));

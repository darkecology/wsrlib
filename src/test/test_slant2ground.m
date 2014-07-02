function test_slant2ground()
% TEST_SLANT2GROUND Test conversions between slant and ground coordinates
%

[file, station] = sample_radar_file();

% Construct options for rsl2mat
opt = struct();
opt.cartesian = false;
radar = rsl2mat(file, station, opt);

[az, range] = get_az_range(radar.dz.sweeps(1));

elev = 0.5;
[s, h] = slant2ground(range, elev);
[range1, elev1] = ground2slant(s, h);
[range2, h1] = groundElev2slant(s, elev);

tol = 1e-4;

range1_err = max(abs(range - range1));
elev1_err   = max(abs(elev - elev1));

range2_err = max(abs(range - range2));
height_err = max(abs(h - h1));

fprintf('Max range error: %.4e\n', range1_err);
fprintf('Max elev error: %.4e\n',  

fprintf('Max range error 2: %.4e\n', 
fprintf('Max height error: %.4e\n',  

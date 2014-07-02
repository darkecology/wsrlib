function test_slant2ground()
% TEST_SLANT2GROUND Test conversions between slant and ground coordinates
%

[file, station] = sample_radar_file();

% Construct options for rsl2mat
opt = struct();
opt.cartesian = false;
radar = rsl2mat(file, station, opt);

[~, range] = get_az_range(radar.dz.sweeps(1));

elev = 0.5;
[s, h] = slant2ground(range, elev);
[range1, elev1] = ground2slant(s, h);
[range2, h1] = groundElev2slant(s, elev);

tol = 1e-4;

range1_err = max(abs(range - range1));
elev1_err   = max(abs(elev - elev1));

range2_err = max(abs(range - range2));
height_err = max(abs(h - h1));

fprintf('Testing conversions\n');

fprintf('  Max range error: %.4e\n', range1_err);
fprintf('  Max elev angle error: %.4e\n', elev1_err); 
fprintf('  Max range error 2: %.4e\n', range2_err);
fprintf('  Max height error: %.4e\n', height_err);

if range1_err > tol
    error('Range (1) error exceeds tolerance');
end

if elev1_err > tol
    error('Elevation angle error exceeds tolerance');
end

if range2_err > tol
    error('Range (2) error exceeds tolerance');
end

if height_err > tol
    error('Height error exceeds tolerance');
end

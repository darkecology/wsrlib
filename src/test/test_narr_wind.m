function test_narr_wind()
% TEST_NARR_WIND Test NARR wind functions:
%
%  narr_wind_file, narr_read_wind, narr_wind_profile

test_narr_wind_file();
test_narr_wind_profile();

end

function test_narr_wind_file()

% Get 0Z file
date = datenum('2010-09-11 01:10:00');

if ~strcmp(narr_wind_file(date), 'merged_AWIP32.2010091100.3D')
    error('Error in narr_wind_file');
end

% Get 3Z file
date = datenum('2010-09-11 01:31:00');

if ~strcmp(narr_wind_file(date), 'merged_AWIP32.2010091103.3D')
    error('Error in narr_wind_file');
end

end

function test_narr_wind_profile()

wind_file = sample_narr_file();

% KBGM
lat = 42.1997;
lon = -75.9847;

[u_wind, v_wind] = narr_read_wind(wind_file);

[u, v, speed, direction, elev] = narr_wind_profile(u_wind, v_wind, lon, lat);

expected_direction = [
    134.8586
    134.8808
    134.9660
    154.4307
    163.2103
    169.9886
    173.7888
    174.4002
    173.8176
    177.4704
    177.7318
    175.9206
    175.4194
    176.9748
    177.2704
    174.3456
    170.2616
    164.8412
    160.6136
    158.0301
    152.9178
    150.4224
    148.9008
    147.8305
    147.3324
    148.8396
    149.7050
    149.8114
    145.1835 ];

if norm(direction - expected_direction, 1) > 1e-3
    error('test_wind_profile: Direction does not match');
end

end
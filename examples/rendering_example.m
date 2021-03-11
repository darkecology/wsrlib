%key = '2017/04/18/KBRO/KBRO20170418_035225_V06';   % no rain
%key = '2017/09/27/KBRO/KBRO20170927_032053_V06';  % rain
%key = '2017/09/18/KTBW/KTBW20170918_023500_V06'; % no rain
%key = '2017/04/20/KBGM/KBGM20170420_024713_V06'; % rain
key = '2017/04/21/KBGM/KBGM20170421_025222_V06'; % rain
%key = 'KBUF20190101_160811';
station = 'KBGM';

scan = aws_get_scan(key, '.');
radar = rsl2mat(scan, station);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Render in polar coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ polar_data, range, az, elev ] = radar2mat( radar, ...
    'coords', 'polar', ...
    'fields', {'dz', 'vr', 'rh'});

figure(1);
imagesc(az, range, polar_data.dz(:,:,3:5));
xlabel('Azimuth (degrees)');
ylabel('Range (km)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Render in Cartesian coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ cartesian_data, x, y, elev ] = radar2mat( radar, ...
    'coords', 'cartesian', ...
    'fields', {'dz', 'vr', 'rh'});

figure(2);
imagesc(x, y, cartesian_data.dz(:,:,3:5));
xlabel('x (meters)');
ylabel('y (meters)');
axis xy;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Downsampling example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Specifically ask for these elevations
ELEVS = [0.5 1.5 2.5 3.5 4.5];

% Legacy resolution parameters
R_MIN = 0;
R_MAX = 150000;
R_RES = 1000;
AZ_RES = 1;
DIM = 500;

% Render in polar coordinates at legacy resolution
[ data_lowres, range, az, elev ] = radar2mat( radar, ...
    'coords', 'polar', ...
    'r_min', R_MIN, ...
    'r_max', R_MAX * sqrt(2), ...
    'r_res', R_RES, ...
    'az_res', AZ_RES, ...
    'elevs', ELEVS);

% Test 
test_polar = true;
if test_polar 
    [data_lowres2, range2, az2, elev] = mat2mat(data_lowres, range, az, elev, ...
        'r_min', R_MIN, ...
        'r_max', R_MAX, ...
        'r_res', R_RES, ...
        'az_res', AZ_RES);

    figure()
    subplot(1,2,1);
    imagesc(data_lowres.dz(:,:,1));
    subplot(1,2,2);
    imagesc(data_lowres2.dz(:,:,1));    
end


[data_lowres, ~, ~, ~] = mat2mat(data_lowres, range, az, elev, ...
    'r_max', R_MAX, ...
    'in_coords', 'polar', ...
    'out_coords', 'cartesian', ...
    'dim', DIM);

% For comparison, render directly to Cartesian from full resolution
[data, y, x, elev] = radar2mat(radar, ...
    'coords', 'cartesian', ...
    'elevs',  ELEVS, ..., 
    'dim', DIM, ...
    'ydirection', 'ij' );

% Visualize
figure()
n_elev = numel(elev);
cc = jet(32);
DZ = cat(4, data.dz, data_lowres.dz);
montage(uint8(reshape(DZ, [DIM DIM 1 2*n_elev])), cc, 'Size', [2 n_elev]);

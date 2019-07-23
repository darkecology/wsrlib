% Read radar file
key = 'KBGM20130412_022349'; % weather
key = 'KRTX20100510_062940'; % weather
radar_file = aws_get_scan(key, 'tmp');
scaninfo = aws_parse(radar_file);
station = scaninfo.station;

radar = rsl2mat(radar_file, station);

% Preliminaries: vvp, dealias

% VVP: get velocity profile
RMIN_M  = 5000;
RMAX_M  = 37500;
ZSTEP_M = 100;
ZMAX_M  = 3000;
[ edges, height, u, v, rmse ] = epvvp(radar, ZSTEP_M, RMIN_M, RMAX_M, ZMAX_M);
[thet, speed] = cart2pol(u, v);         % get direction and speed
direction     = pol2cmp(thet);          % convert to compass heading

% Dealias
radar_dealiased = vvp_dealias(radar, edges, u, v, rmse);

% Extract 3D data matrices and coordinate vectors
AZ_RES    = 0.5;
RANGE_RES = 250;
[data, range, az, elev] = radar2mat(radar_dealiased, ...
    'fields', {'dz', 'vr'}, ...
    'r_min', RMIN_M,...
    'r_max', RMAX_M,...
    'az_res', AZ_RES,...
    'r_res', RANGE_RES);
DZ = data.dz;
VR = data.vr;

% Get sample volume coordinate matrices
[RANGE, AZ, ELEV] = ndgrid(range, az, elev);

% Use mistnet_polar to make predictions for points in polar coordinates
[PREDS, classes, PROBS] = mistnet_polar( radar, RANGE, AZ, ELEV);

% Convert range and elevation to height in meters above elevation of radar
[~, HEIGHT] = slant2ground(RANGE, ELEV);


% Plot mistnet predictions in polar coordinates
figure(1);
clf();

cmap = [0, 0.5, 1;
        1, 0.5, 0;
        1, 0, 0];
colormap(cmap);

for i = 1:5
    subplot(5,3, 3*(i-1) + 1);
    imagesc(az, range, DZ(:,:,i), [-5, 35]);
    colormap(gca, jet(32));
    colorbar();

    subplot(5,3, 3*(i-1) + 2);
    imagesc(az, range, PROBS(:,:,i,3), [0 1]);
    colormap(gca, hot(32));
    colorbar();

    subplot(5,3, 3*(i-1) + 3);
    image(az, range, PREDS(:,:,i));    
    colormap(gca, cmap);
    colorbar('YTick', 1.5:3.5, 'YTickLabel', {'background', 'biology', 'rain'});
end

% Set rain sample volumes to 0 reflectivity (-inf on decibel scale)
DZ(PREDS==classes.rain) = -inf;

% Set nodata sample volumes to 0 reflectivity (-inf on decibel scale)
DZ(isnan(DZ)) = -inf;

% Convert to reflectivity
Z    = idb(DZ);             % inverse decibel transform --> reflectivity factor
REFL = z_to_refl(Z);        % reflectivity factor --> reflectivity

% Compute mean reflectivity in each 100m height bin

% use height bins from previous velocity analysis 
nbins   = length(edges)-1;

% initialize density vector to nan
density = nan(nbins,1);

% compute density for each bin
for i=1:nbins
    
    height_min = edges(i);
    height_max = edges(i+1);
    
    inds = HEIGHT >= height_min & HEIGHT < height_max;
    density(i) = mean(REFL(inds));    
end

% Plot results

figure(2); clf();

subplot(1,3,1);
plot(density, height, 'o');
xlabel('Mean reflectivity (cm^2/km^3)');
ylabel('Height (m)');

subplot(1,3,2);
plot(direction, height, 'o');
xlabel('Heading (degrees)');
ylabel('Height(m)');

subplot(1,3,3);
plot(speed, height, 'o');
xlabel('Speed (m/s)');
ylabel('Height');
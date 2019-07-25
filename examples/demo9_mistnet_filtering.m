% Read radar file
key = 'KBGM20130412_022349'; % weather
key = 'KRTX20100510_062940'; % weather
key = 'KABX20170902_041920'; % mix

info = aws_parse(key);
radar = rsl2mat_s3(key, info.station);

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

% Set rain sample volumes to 0 reflectivity (-inf on decibel scale)
MASKED_DZ = DZ;
MASKED_DZ(PREDS==classes.rain) = -inf;

% Set nodata sample volumes to 0 reflectivity (-inf on decibel scale)
MASKED_DZ(isnan(MASKED_DZ)) = -inf;

% Convert to reflectivity
Z    = idb(MASKED_DZ);      % inverse decibel transform --> reflectivity factor
REFL = z_to_refl(Z);        % reflectivity factor --> reflectivity


% Plot predictions 
f = figure(1);
f.Position = [100, 800, 1800, 600];
cmap = [0, 0.5, 1;
        1, 0.5, 0;
        1, 0, 0];

colormap(cmap);

nr = 5;
nc = 4;
figure;
ax = gobjects(nc,nr); % Subplots use opposite numbering convention 
                      % from arrays, so start reversed
figure(1);                      
                    
for i = 1:5
    
    ind = nc*(i-1) + 1;
    ax(ind) = subplot(5,4, ind);
    imagesc(az, range, DZ(:,:,i), [-5, 35]);
    colormap(gca, jet(32));
    colorbar();

    ind = nc*(i-1) + 2;
    ax(ind) = subplot(5,4, ind);
    imagesc(az, range, PROBS(:,:,i,3), [0 1]);
    colormap(gca, hot(32));
    colorbar();

    ind = nc*(i-1) + 3;
    ax(ind) = subplot(5,4, ind);
    image(az, range, PREDS(:,:,i));    
    colormap(gca, cmap);
    colorbar('YTick', 1.5:3.5, 'YTickLabel', {'background', 'biology', 'rain'});
    
    ind = nc*(i-1) + 4;
    ax(ind) = subplot(5,4, ind);
    imagesc(az, range, MASKED_DZ(:,:,i), [-5, 35]);
    colormap(gca, jet(32));
    colorbar();
end

ax = ax'; % Your handle array now has the same layout as your subplots

title(ax(1,1), 'DZ');
title(ax(1,2), 'Rain prob.');
title(ax(1,3), 'Classification');
title(ax(1,4), 'Filtered DZ');

ylabel(ax(1,1), '0.5 deg.');
ylabel(ax(2,1), '1.5 deg.');
ylabel(ax(3,1), '2.5 deg.');
ylabel(ax(4,1), '3.5 deg.');
ylabel(ax(5,1), '4.5 deg.');




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
figure(2); 
clf();

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
%% 1. Read radar file
radar_file = 'data/KBGM20150508_065830_V06.gz';
station    = 'KBGM';

radar = rsl2mat(radar_file, station);

%% 2. Preliminaries: vvp, dealias

% Parameters for epvvp. All units are in meters
RMIN_M  = 5000;
RMAX_M  = 37500;
ZSTEP_M = 100;
ZMAX_M  = 3000;
RMSE_THRESH = inf;
EP_GAMMA = 0.1;

% Paramters for align_scan
AZ_RES    = 0.5;
RANGE_RES = 250;

% VVP: extract velocity information
[ edges, height, u, v, rmse ] = epvvp(radar, ZSTEP_M, RMIN_M, RMAX_M, ZMAX_M, 'EP', EP_GAMMA);
[thet, speed] = cart2pol(u, v);         % get direction and speed
direction     = pol2cmp(thet);          % convert to compass heading

% Dealias
radar_dealiased = vvp_dealias(radar, edges, u, v, rmse, RMSE_THRESH);

%% 3. Align volumes and extract 3D data matrices

% Align all sweeps to a common polar grid
%radar_aligned = align_scan(radar_dealiased, AZ_RES, RANGE_RES, RMAX_M );

% Extract 3D data matrices and coordinate vectors
[data, range, az, elev] = radar2mat(radar_dealiased, ...
    'fields', {'dz', 'vr'}, ...
    'r_max', RMAX_M,...
    'az_res', AZ_RES,...
    'r_res', RANGE_RES);
DZ = data.dz;
VR = data.vr;

% Set nodata pulse volumes to 0 reflectivity (-inf on decibel scale)
DZ(isnan(DZ)) = -inf;

% Convert to reflectivity
Z    = idb(DZ);             % inverse decibel transform --> reflectivity factor
REFL = z_to_refl(Z);        % reflectivity factor --> reflectivity

%% 4. Design pattern: coordinate matrices and conversions

% Get coordinate matrices
[RANGE, AZ, ELEV] = ndgrid(range, az, elev);

% Convert range and elevation to height in meters above elevation of radar
[~, HEIGHT] = slant2ground(RANGE, ELEV);

%% 5. Design pattern: slice data by coordinate (example)

inds = HEIGHT > 1000 & HEIGHT < 1500;
mean_refl = mean(REFL(inds));

%% 6. Analysis: compute mean reflectivity in each 100m height bin

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

%% 7. Plot results

figure(1); clf();

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
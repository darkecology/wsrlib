% 1. Read radar file
key = 'KBGM20130412_022349'; % weather
key = 'KRTX20100510_062940' % weather
radar_file = aws_get_scan(key, 'tmp');
scaninfo = aws_parse(radar_file);
station    = scaninfo.station;

radar = rsl2mat(radar_file, station);

% 2. Preliminaries: vvp, dealias

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

%%%% Classify using mistnet

% Location of model on disk
model_file = sprintf('%s/cnn/mistnet.mat', cajun_root());

% Avoid costly reloading of model into memory
if ~exist('net', 'var')
    net = load_segment_net(model_file, []);
end

% Make predictions
[PREDS_YX, PROBS_YX, classes, x, y, elevs] = segment_scan( radar, net );

% Get coordinate matrices
[RANGE, AZ, ELEV] = ndgrid(range, az, elev);
[GROUND_RANGE, HEIGHT] = slant2ground(RANGE, ELEV);

% Make predictions for polar volume by interpolating Cartesian volume
F = griddedInterpolant({y', x', elevs'}, PREDS_YX, 'nearest');
PHI = cmp2pol(AZ);
[X, Y] = pol2cart(PHI, GROUND_RANGE);
PREDS = F(Y, X, ELEV);

% Alternately: use mat2mat
%
% data = mat2mat({PREDS}, x, y, elevs, ...
%     'in_coords', 'cartesian',...
%     'out_coords', 'polar',...
%     'r_min', RMIN_M,...
%     'r_max', RMAX_M,...
%     'az_res', AZ_RES,...
%     'r_res', RANGE_RES); 

%%
figure(1);
clf();

mycmap = [1 0 0; 0 1 0; 0 0 1];
colormap(mycmap);

for i = 1:5
    subplot(5,2, 2*(i-1) + 1);
    imagesc(az, range, DZ(:,:,i), [-5, 35]);
    colormap(gca, jet(32));
    colorbar();
    
    subplot(5,2, 2*(i-1) + 2);
    image(az, range, PREDS(:,:,i));    
    colormap(gca, mycmap);
    colorbar('YTick', 1.5:3.5, 'YTickLabel', {'background', 'biology', 'rain'});
end

%%
return

% now interpolate to a full mask of size sz (in radial coords)
% first, get cartesian X and Y of each pixel in final mask
[MASK_X, MASK_Y] = pol2cart(cmp2pol(AZ), RANGE, HEIGHT);



% Set nodata pulse volumes to 0 reflectivity (-inf on decibel scale)
DZ(isnan(DZ)) = -inf;

% Convert to reflectivity
Z    = idb(DZ);             % inverse decibel transform --> reflectivity factor
REFL = z_to_refl(Z);        % reflectivity factor --> reflectivity

% 4. Design pattern: coordinate matrices and conversions

% Get coordinate matrices
[RANGE, AZ, ELEV] = ndgrid(range, az, elev);

% Convert range and elevation to height in meters above elevation of radar
[~, HEIGHT] = slant2ground(RANGE, ELEV);

% 5. Design pattern: slice data by coordinate (example)

inds = HEIGHT > 1000 & HEIGHT < 1500;
mean_refl = mean(REFL(inds));

% 6. Analysis: compute mean reflectivity in each 100m height bin

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

% 7. Plot results

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
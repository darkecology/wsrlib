
%% Load radar file and show image

radar_file = 'data/KDOX20111001_110612_V04.gz';
station    = 'KDOX';
radar      = rsl2mat(radar_file, station);

figure(1); clf();
rmax = 150000;   % 150km
dim  = 600;      % 600 pixel image
[data, x, y] = sweep2cart(radar.dz.sweeps(1), rmax, dim);
imagesc(x, y, data, [-5 32]);
colormap(jet(32));
axis xy;
colorbar();

%% Extract data and coordinate matrices
[dBZ, range, az]  = sweep2mat(radar.dz.sweeps(1));

% Convert to reflectivity and set NODATA = 0
REFL              = z_to_refl(idb(dBZ));
REFL(isnan(REFL)) = 0;

% Expand coordinate vectors to matrices
[RANGE, AZ, ELEV] = ndgrid(range, az, radar.dz.sweeps(1).elev);

%% Pulse volume coordinate conversions

% Get range along ground and height above ground
[GROUND_RANGE, HEIGHT] = slant2ground(RANGE, ELEV);

% Convert azimuth to mathematical angle
THETA = cmp2pol(AZ);

% Convert to X,Y coordinates of each pulse volume
[X, Y] = pol2cart(THETA, GROUND_RANGE); 


%% Roost location
x0 = -6909;        % offset in meters from radar station
y0 = 68397.5;      % offset in meters from radar station (image coordinates)
r  = 10560.28723;  % meters

%% Convert roost location to lat / lon

[angle, dist_from_radar] = cart2pol(x0, y0);
bearing = pol2cmp(angle);
[roost_lon, roost_lat] = m_fdist(radar.lon, radar.lat, bearing, dist_from_radar);
roost_lon = alias(roost_lon, 180);
fprintf('lat,lon=%.4f,%.4f\n', roost_lat, roost_lon)


%% Another coordinate conversion: get distance of each PV from roost center

DIST = sqrt( (X-x0).^2 + (Y-y0).^2 );

%% Now get average reflectivity as a function of distance from roost center

% Use 500m bins up to twice the roost radius
edges = 0:500:2*r;
nbins = length(edges)-1;

% Initialize density vector to nan
density = nan(nbins,1);

% Compute density for each bin
for i=1:nbins
    
    dist_min = edges(i);
    dist_max = edges(i+1);
    
    inds = DIST >= dist_min & DIST < dist_max;
    density(i) = mean(REFL(inds));    
end

%% Plot result

figure(2); clf();
bin_start = edges(1:end-1);
plot(bin_start, density, 'o', 'linewidth', 2);



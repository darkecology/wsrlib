%% Demo: basic VAD/VVP analysis

%% 1. Read radar file
radar_file = 'data/KBGM20100911_033915_V03.gz';
station    = 'KBGM';

radar = rsl2mat(radar_file, station);

%% 2. Extract data

% Get lowest velocity sweep
sweep = radar.vr.sweeps(1);      

% Get sweep elevation angle and convert to radians
elev = deg2rad(sweep.elev);

% Get data matrix
[data, range, az] = sweep2mat(sweep);

% Convert azimuths measurements from compass headings to standard 
% mathematical angle (radians counterclockfrom positive x axis)
az = cmp2pol(az); 

%% 2. Set up and solve linear regression problem. 
%      - Use data from 100th range bin (~25km)

range_bin = 300;
y = data(range_bin, :)';
X = [cos(az).*cos(elev) sin(az).*cos(elev)];

% Exclude invalid measurements
valid_inds = ~isnan(y);
az         = az(valid_inds);
X          = X(valid_inds,:);
y          = y(valid_inds);

% Solve linear regression problem
w = X \ y;

%% 3. Plot results
figure(1); clf();
hold on;

% Plot data
scatter(az, y);

% Plot fitted model
u = w(1);
v = w(2);
phi = 0:.01:(2*pi);
plot(phi, u*cos(phi)*cos(elev) + v*sin(phi)*cos(elev));

%% 4. Visualize results: draw direction line on image

% Display velocity image
figure(2); clf();
[data, x, y] = sweep2cart(sweep, 100000, 400); % 50km range, 400 pixels
imagesc(x, y, data);
axis xy;
colormap(vrmap2(32));
hold on;

% Plot direction line
len = range(range_bin)/norm(w);
line([0 len*u], [0 len*v], 'color', 'b', 'linewidth', 4);



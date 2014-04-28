
radar_dir = sprintf('%s/radar/data/KBGM/KBGM-2010-09' , getenv('BIRDCAST_HOME'));

radar_file = [radar_dir '/KBGM20100911_012056_V03.gz'];
    
%radar_file = 'data/KDOX20090902_104018_V04.gz';  % Legacy resolution
%radar_file = 'data/KDIX20090902_103042_V03.gz';

% Parse the filename to get the station
scaninfo = wsr88d_scaninfo(radar_file);

% Construct options for rsl2mat
opt = struct();
opt.cartesian = false;
opt.max_elev = inf;
radar = rsl2mat(radar_file, scaninfo.station, opt);

rmax = 100000;

% Paramters for alignSweepsToFixed
radar = alignSweepsToFixed(radar, 0.5, 250, rmax, true);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create interpolant function F
%  accepts query points in polar coordinate
%  spits out interpolated values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% old function call
%F = vol_interp(radar.dz, rmax, 'linear');

type = 'nearest';
default_val = nan;
vol = radar.dz;
n = numel(vol.sweeps);

sweeps = cell(n,1);
for i=1:n
    sweeps{i} = vol.sweeps(i);
end

[ data, ~, az, range ] = align_sweeps( sweeps, rmax, 'slant', '' );

elev = [vol.sweeps.elev];
data = cat(3, data{:});

data(data > 131000) = default_val;

az = [az(end)-360; az(:); az(1)+360];
data = cat(2, data(:,end,:), data(:,:,:), data(:,1,:));

[RANGE, AZ, ELEV] = ndgrid(range, az, elev);

[~, Z] = slant2ground(RANGE, ELEV);

% Set "training data" to nan if it is not close enough to 
% our desired query elevation
% replace this with your own conditions...
is_valid = Z > 900 & Z < 1100; 
data(~is_valid) = nan;

% Create the interpolating function
F = griddedInterpolant({range, az, elev}, data, type);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create query
%  1. Generate a mesh in cartesian
%  2. Convert to 3d polar
%  3. Call interpolant
%  4. plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dim = 400;

xmin = -100000;
xmax = 100000;
ymin = -100000;
ymax = 100000;
z = 1000;

x = linspace(xmin, xmax, dim);
y = linspace(ymin, ymax, dim);

[X, Y] = meshgrid(x, y);
[m, n] = size(X);
Z = repmat(z, m, n);

[AZ, RANGE, ELEV] = xyz2radar(X, Y, Z);
data = F(RANGE, AZ, ELEV);
imagesc(data);

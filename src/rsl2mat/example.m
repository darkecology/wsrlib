% Example script to read in and display radar data

filename = 'data/KDOX20090902_104018_V04.gz';

% Parse the filename
scaninfo = wsr88d_scaninfo(filename);

% Ingest the radar file
radar = rsl2mat(filename, scaninfo.station);

% Fetch and align the lowest sweep
%
%   sweep.dz = reflectivity
%   sweep.vr = radial velocity
%   sweep.sw = spectrum width
%
%   NOTE: After this call, measurements that are below signal-to-noise are 
%        coded as nan
sweep = get_aligned_sweep(radar, 1);

% Some handy display options
opt = displayopts();
black = [0 0 0];

% Display reflectivity image
figure(1);
colormap(opt.dzmap);
imagesc_nan(black, sweep.dz, opt.dzlim); % render nan as black
colorbar();

% Display velocity image
figure(2);
colormap(opt.vrmap);
imagesc_nan(black, sweep.vr, opt.vrlim); % render nan as black
colorbar();

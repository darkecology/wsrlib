%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%

LONLIM = [-82 -65];       % bounding box
LATLIM = [36 48];

IMAGE_SIZE = [600, 600];  % width, height in pixels
RMAX = 200000;            % max. distance from radar

WHITE = [1 1 1];          % rgb value for white
BGCOLOR = 0.8*[1 1 1];    % rgb for background (NODATA pixels within RMAX)

DZMAP = jet(32);          % reflectivity colormap
DZLIM = [-5 35];          % reflectivity color range

VRMAP = vrmap2(32);       % radial velocity colormap
VRLIM = [-20 20];         % radial velocity color range

%%%%%%%%%%%%%%%%%%%%%
% Data
%%%%%%%%%%%%%%%%%%%%%

files = {
    'KBGM20100911_012056_V03.gz'
    'KBOX20100911_010428_V03.gz'
    'KBUF20100911_013602_V03.gz'
    'KCBW20100911_005706_V03.gz'
    'KCCX20100911_013442_V03.gz'
    'KCXX20100911_011459_V03.gz'
    'KDIX20100911_011759_V03.gz'
    'KDOX20100911_012056_V04.gz'
    'KENX20100911_011108_V03.gz'
    'KGYX20100911_005803_V03.gz'
    'KLWX20100911_012733_V03.gz'
    'KOKX20100911_011047_V03.gz'
    'KTYX20100911_012210_V04.gz'};


% Build lists of stations names and filenames with paths
stations = {};  % station names
for i = 1:numel(files)
    stations{i} = files{i}(1:4); %#ok<SAGROW>
    files{i} = sprintf('data/mosaic/%s', files{i});
end

% Set map projection, which is used internally by mosaic function
m_proj('utm', 'long', LONLIM, 'lat', LATLIM, 'rec', 'on');

max_elev = 1;    % for speed, only process lowest elevation. there are options to combine multiple elevations

% Make the mosaic
%  - im is a cell array that contains mosaic images for requested fields
%  - E.g., when called with {'dz', 'vr'}, im{1} is the reflectivty mosaic, and
%    im{2} is the radial velocity mosaic
%
[im, minDist, x, y, ~, ~, LON, LAT] = mosaic(files, LONLIM, LATLIM, IMAGE_SIZE, RMAX, {'dz', 'vr'}, stations, max_elev);

% TODO output world file...


%%
%%%%%%%%%%%%%%%%%%%%%
% Post-process and save DZ image
%%%%%%%%%%%%%%%%%%%%%

% Convert to indexed image (i.e., GIF)
[dzim, cmap, ~, ~, edges] = mat2ind(im{1}, DZLIM, DZMAP);

% Display in figure window
imHandle = image(x, y, dzim);
imHandle.AlphaData = ~isnan(dzim);  % make NaN pixels transparent
colormap(cmap);
axis xy;

% Save as GIF with NaNs mapped to transparent
imwrite_gif_nan(dzim, cmap, 'mosaic_dz.gif');


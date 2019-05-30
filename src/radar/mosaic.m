function [im, minDist, x, y, X, Y, LON, LAT] = mosaic(files, lonlim, latlim, imageSize, rmax, fields, stations, max_elev, dealias)

if nargin < 9
    dealias = false;
end

n = numel(files);

if nargin < 6
    fields = {'dz'};
end

nFields = numel(fields);

% If not supplied, parse the filename to get the station
if nargin < 7
    stations = cell(n,1);
    for i=1:length(files)
        info = wsr88d_scaninfo(files{i});
        stations{i} = info.station;
    end
end

if nargin < 8
    max_elev = 1;
end

pixelWidth = imageSize(1);
pixelHeight = imageSize(2);

% Get a bounding box in x/y coordinates that encloses the lat/lon region
[xrng, yrng] = m_get_bbox(lonlim, latlim);

% Create grid on that bounding box
s = create_grid(xrng, yrng, pixelWidth, pixelHeight);

% Determine approximate pixel size in km
x_min = s.x0;
x_max = s.x0 + (s.nx * s.dx);
y_min = s.y0;
y_max = s.y0 + (s.ny * s.dy);
x_len = m_xydist([x_min x_max], [y_min y_min]);
y_len = m_xydist([x_min x_min], [y_min y_max]);

pixel_size_x = x_len/pixelWidth;
pixel_size_y = y_len/pixelHeight;

% Upper bound on how big a patch to consider around each station
patchRadius = [ 
    ceil(1.5*rmax/1000/pixel_size_y)   % # rows 
    ceil(1.5*rmax/1000/pixel_size_x)   % # columns
    ];

% Generate coordinates of each pixel
[X, Y, x, y] = grid_points(s);
[LON, LAT] = m_xy2ll(X, Y);

imageSz = [pixelHeight, pixelWidth];

% Initialize the images
im = cell(nFields, 1);
for i=1:nFields
    im{i} = nan(imageSz);      % the image
end

% Distance to nearest station
minDist = inf(imageSz);

% rsl2mat parameters
opt = struct();
opt.cartesian = false;
opt.max_elev = max_elev;

for f=1:n
    fprintf('Processing file %s\n', files{f});
    
    try
        radar = rsl2mat(files{f}, stations{f}, opt);
        
        if dealias
            RMIN  = 5000;
            RMAX  = 150000;
            ZSTEP = 100;
            ZMAX  = 3000;
            RMSE_THRESH = inf;
            EP_GAMMA = 0.1;

            [ edges, ~, u, v, rmse, ~, ~, ~ ] = epvvp(radar, ZSTEP, RMIN, RMAX, ZMAX, 'EP', EP_GAMMA);
            [radar, ~] = vvp_dealias(radar, edges, u, v, rmse, RMSE_THRESH);
        end
        
        % Get coordinates of rectangular image patch centered at radar
        [I, J, inds] = getPatch(radar, imageSz, patchRadius, s);
                
        % Compute radar coordinates (distance and azimuth) for pixels in the patch
        [R, PHI] = ll2radar(radar.lon, radar.lat, LON(I,J), LAT(I,J));
        
        % Iterate through fields and update images
        for field_idx = 1:nFields
            
            field = fields{field_idx};

            switch field
                case 'dz' % use all sweeps
                    sweeps = radar.(field).sweeps;
                case 'vr' % use only lowest 
                    sweeps = radar.(field).sweeps(1);
                otherwise
                    error('Unrecognized field');
            end

            % Combine data from desired number of sweeps  
            for i=1:numel(sweeps)
                sweep = sweeps(i);
                
                rmax = inf;
                dim = 10;
                
                % Get interpolating function F
                [~, ~, ~, F] = sweep2cart(sweep, rmax, dim);

                % Call F on radar coordinates of pixels in this patch
                Z = F(R, PHI);
                
                % Set to nan outside valid radius
                Z(R > rmax) = nan;
                
                switch field
                    
                    case 'dz'
                        % Keep maximum reflectivity value
                        im{field_idx}(inds) = max(im{field_idx}(inds), Z(:));
                    
                    case 'vr'
                        % Replace pixels that are closest to this radar station than
                        % any previous one
                        K = R(:) < minDist(inds);
                        im{field_idx}(inds(K)) = Z(K);
                    
                    otherwise
                        error('Unrecognized field')
                end
            end
        end
        
        % Update dist to closest radar station
        minDist(inds) = min(minDist(inds), R(:));
        
     catch err
         fprintf('Failed:\n%s\n', getReport(err));
         continue;
     end
    
end

% Flip ordering of rows of all return values so they are in standard image
% coordinates, with origin at top left
y = flip(y);
Y = flip(Y, 1);

for i=1:length(im)
    im{i} = flip( im{i}, 1 );
end
minDist = flip( minDist, 1 );

end

function [I, J, inds] = getPatch(radar, imageSz, patchRadius, s)        
% GETPATCH Get coordinates of rectangular image patch centered around radar
%
% [I, J, inds] = getBoundingBox(radar, imageSz, patchRadius, s) 
%
% Inputs:
%   radar        radar struct
%   imageSz      image size as [w h]
%   patchRadius  patch radius as [yRadius, xRadius]
%   s            grid struct
% 
% Outputs:
%   I            list of rows
%   J            list of columns
%   inds         list of pixels indices (linear indices)

% Get station location in grid coordinates
[radar_x, radar_y] = m_ll2xy(radar.lon, radar.lat);
[i,j] = xy2ij(radar_x, radar_y, s);

% Select rows / columns within radius of [i, j]
I = i - patchRadius(1) : i + patchRadius(1);
J = j - patchRadius(2) : j + patchRadius(2);

% Eliminate anything that falls outside the image
I(I < 1) = [];
I(I > imageSz(1)) = [];
J(J < 1) = [];
J(J > imageSz(2)) = [];

% Also compute linear indices for combining patch back into big image
[Jbig,Ibig] = meshgrid(J, I);
inds = sub2ind(imageSz, Ibig(:), Jbig(:));

end

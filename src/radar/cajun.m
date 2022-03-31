function [result] = cajun( radar_path, station, year, varargin )
% CAJUN Run cajun workflow on a single scan to create vertical profiles
%
% [result] = cajun( radar_path, station, varargin )
%
% Required inputs:
%    radar_path   Path to radar file
%    station      station id
%    year         year of scan
%
% Outputs: 
%    result       Results struct
%
% Optional named inputs: (see file)
%    s3
%    yearly_clutter_version
%    static_clutter_version
%    occult_version
%    max_elev
%    elevs
%    rmin_m
%    rmax_m
%    zstep_m
%    zmax_m
%    dz_max
%    dz_max_val
%    rmse_thresh
%    ep_gamma
%    az_res
%    range_res
%    dz_trim
%    diagnostics

p = inputParser;

%Keep/Ignore Unmatched Inputs
p.KeepUnmatched = true;

%%% INPUT DEFINITIONS %%%
addRequired(p, 'radar_path', @ischar);
addRequired(p, 'station',    @ischar);
addRequired(p, 'year',       @isinteger);

addParameter(p, 's3',                       true,        @islogical);
addParameter(p, 'yearly_clutter_version',   '',          @ischar);
addParameter(p, 'static_clutter_version',   'least',     @ischar);
addParameter(p, 'occult_version',           '150km',     @ischar);
addParameter(p, 'max_elev',          uint32(10),  @isinteger);
addParameter(p, 'elevs',             0.5:4.5, @isreal);
addParameter(p, 'rmin_m',            5000,  @isreal);
addParameter(p, 'rmax_m',            50000, @isreal);
addParameter(p, 'zstep_m',           100,   @isreal);
addParameter(p, 'zmax_m',            3000,  @isreal);
addParameter(p, 'dz_max',            35);
addParameter(p, 'dz_max_val',        nan);
addParameter(p, 'rmse_thresh',       inf,   @isreal);
addParameter(p, 'ep_gamma',          0.1,   @isreal);
addParameter(p, 'az_res',            0.5,   @isreal);
addParameter(p, 'range_res',         250,   @isreal);
addParameter(p, 'dz_trim',           0.0,   @isreal);
addParameter(p, 'diagnostics',       false, @islogical);

parse(p, radar_path, station, year, varargin{:});

params = p.Results;
paramsUnmatched = p.Unmatched;

% Output structure
result = struct();          % scan-level output
result.profile = struct();  % vertical profile output (binned by elevation)
result.info  = struct();    % diagnostic info (if enabled)

% Add parameters to result struct
result.params = params;

try
    % Choose which reader
    if params.s3
    	rsl2mat_ = @rsl2mat_s3;
    else
        rsl2mat_ = @rsl2mat;
    end
    
    % Read radar
    radar = rsl2mat_(radar_path, ...
        station, ...
        struct('cartesian', false, ...
        'max_elev',  params.max_elev));
catch err
    fprintf('Error loading radar file %s.\n', radar_path);
    rethrow(err);
end
                       
%%% VELOCITY PROFILE %%%
[ edges, z, u, v, rmse, ~, ~, ~ ] = epvvp(radar, ...
                                           params.zstep_m, ...
                                           params.rmin_m, ...
                                           params.rmax_m, ...
                                           params.zmax_m, ...
                                           'EP', params.ep_gamma);
                                           
% Convert u, v components of velocity to compass heading
[ theta, speed ] = cart2pol(u, v);
direction = pol2cmp(theta);

% Dealias velocity
radar_dealiased = vvp_dealias(radar, edges, u, v, rmse, params.rmse_thresh);

% Extract matrices (all capitals)
fields = {'dz', 'vr'};
[data, range, az, elev] = radar2mat(radar_dealiased, 'fields', fields, 'r_max', params.rmax_m, 'elevs', params.elevs);
DZ = data.dz;
VR = data.vr;
[RANGE, AZ, ELEV] = ndgrid(range, az, elev);
[~, HEIGHT] = slant2ground(RANGE, ELEV); % height (in meters) above radar of each PV


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clutter masks and other classification and masking of pulse volumes
%  (optionally includes "Gauthreaux"-style insect classifiction)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% We will create a number of different Boolean masks that delineate
% properties pulse volumes may have:
%
% DYNAMIC_CLUTTER   radial velocity in [-1, 1] m/s
%      NN_CLUTTER   CNN predicts clutter
%  STATIC_CLUTTER   static clutter map predicts clutter
%          NODATA   DZ or VR is NODATA (nan)
%            RAIN   CNN predicts rain
%
% A pulse volume may have many properties.
%
% Our overall goal is to exclude "clutter", and then classify the remaining 
% pulse volumes as either birds or non-birds, so we can set the 
% reflectivity to zero for non-birds. The general scheme is:
%
% clutter:
%   static        --> ignore
%   dynamic       --> ignore
%   beam-blockage --> ignore
%
% non-clutter:
%   nodata        --> 0
%   rain          --> 0
%   insects       --> 0
%   birds         --> nonzero
%
% In the end we will use the following Boolean logic to classify each pulse 
% volume into *exactly* one class among {IGNORE, SET_TO_ZERO, BIRDS} that
% dictates how we will treat it:
%
%  IGNORE       = DYNAMIC_CLUTTER | NN_CLUTTER | STATIC_CLUTTER | BEAM_BLOCKAGE
%  SET_TO_ZERO  = (NODATA | RAIN) & ~IGNORE
%  BIRDS        = ~SET_TO_ZERO & ~IGNORE

sz = size(DZ);
NEW_MASK = false(sz);

NODATA = NEW_MASK;
NODATA(isnan(DZ)) = true;

DYNAMIC_CLUTTER = NEW_MASK;
DYNAMIC_CLUTTER(abs(VR) < 1) = true;

STATIC_CLUTTER = NEW_MASK;
BEAM_BLOCKAGE = NEW_MASK;

if ~isempty(params.static_clutter_version)
    try
        [MASK, range_, az_, elev_] = static_clutter_mask(station, params.static_clutter_version);
        F = mask_interpolant(MASK, range_, az_, elev_);
        STATIC_CLUTTER(F(RANGE, AZ, ELEV) > 0) = true;
    catch err
        fprintf('Error loading static clutter mask: %s', err.message);
        rethrow(err);
    end
end

if ~isempty(params.yearly_clutter_version)
    try
        [MASK, range_, az_, elev_] = yearly_clutter_mask(station, year, params.yearly_clutter_version);
        F = mask_interpolant(MASK, range_, az_, elev_);
        STATIC_CLUTTER(F(RANGE, AZ, ELEV) > 0) = true;
    catch err
        fprintf('Warning: could not load yearly clutter mask: %s\n', err.message);
    end
end

if ~isempty(params.occult_version)
    try
        [MASK, range_, az_, elev_] = occult_mask(station, params.occult_version);
        F = mask_interpolant(MASK, range_, az_, elev_);
        BEAM_BLOCKAGE(F(RANGE, AZ, ELEV) > 0) = true;
    catch err
        fprintf('Error loading occultation mask: %s', err.message);
        rethrow(err);
    end
end

%%% BUILD MASKS FROM SEGMENTER %%%
try        
    % get the segmented img (in cartesian coords)
    
    [SEG_MASK_CART, ~, net_labels, seg_y, seg_x] = mistnet(radar, paramsUnmatched);

    % now interpolate to a full mask of size sz (in radial coords)
    % first, get cartesian X and Y of each pixel in final mask
    [MASK_X, MASK_Y] = pol2cart(cmp2pol(AZ), RANGE, HEIGHT);

    % build an interpolant for SEG_MASK_CART
    SEG_MASK_POL = zeros(sz);
    n_output_sweeps = size(SEG_MASK_CART,3);
    for i_output_layer = 1:n_output_sweeps
        seg_interpolant = griddedInterpolant({seg_y, seg_x}, SEG_MASK_CART(:,:,i_output_layer), 'nearest');
        SEG_MASK_POL(:,:,i_output_layer) = seg_interpolant(MASK_Y(:,:,i_output_layer), MASK_X(:,:,i_output_layer));
    end

    % convert SEG_MASK to a binary mask with true == rain
    % this is throwing out the segmenting of background pixels that the
    % segmenter does, but the background will already be masked by
    % other masks
    RAIN       = (SEG_MASK_POL == net_labels.rain);
    NN_CLUTTER = (SEG_MASK_POL == net_labels.clutter);

catch err
    fprintf('Error performing segmentation');
    rethrow(err);
end

IGNORE      = DYNAMIC_CLUTTER | NN_CLUTTER | STATIC_CLUTTER | BEAM_BLOCKAGE;
SET_TO_ZERO = (NODATA | RAIN) & ~IGNORE;
BIRDS       = ~SET_TO_ZERO & ~IGNORE;

SEGLESS_IGNORE = DYNAMIC_CLUTTER | STATIC_CLUTTER | BEAM_BLOCKAGE;
SEGLESS_SET_TO_ZERO = NODATA & ~SEGLESS_IGNORE;

% Assign a unique labels to each pulse volume for the purpose of
% visualization
labels = struct('dynamic_clutter', 1, ...
                'static_clutter',  2, ...
                'beam_blockage',   3, ...
                'nodata',          4, ...
                'rain',            5, ...
                'birds',           6);

CLASS_LABELS = zeros(sz, 'uint8');

% Note that for clutter labels, the later ones will take precedence
CLASS_LABELS(DYNAMIC_CLUTTER)      = labels.dynamic_clutter;
CLASS_LABELS(STATIC_CLUTTER)       = labels.static_clutter;
CLASS_LABELS(BEAM_BLOCKAGE)        = labels.beam_blockage;

% Clutter will take precedence over these classifications, and the later
% ones over earlier ones if there are duplicates (e.g., CNN_RAIN over
% WIND_BORNE)
CLASS_LABELS(NODATA & ~IGNORE)     = labels.nodata;
CLASS_LABELS(RAIN & ~IGNORE)       = labels.rain;
CLASS_LABELS(BIRDS & ~IGNORE)      = labels.birds;

%%% APPLY MASKS TO REFLECTIVITY %%%
%   -inf = count as zero reflectivity
%    nan = exclude from calculation
% (order doesn't matter because these labels are mutually exclusive)
MASKED_DZ = DZ;
MASKED_DZ(SET_TO_ZERO) = -inf;
MASKED_DZ(IGNORE)      = nan;

% do the same, but without the segmenter (for debugging)
SEGLESS_MASKED_DZ = DZ;
SEGLESS_MASKED_DZ(SEGLESS_SET_TO_ZERO) = -inf;
SEGLESS_MASKED_DZ(SEGLESS_IGNORE)      = nan;

% Set large dBZ values to default value
MASKED_DZ(MASKED_DZ >= params.dz_max) = params.dz_max_val;
SEGLESS_MASKED_DZ(SEGLESS_MASKED_DZ >= params.dz_max) = params.dz_max_val;

%%% COMPUTE VPR %%%
[z_profile, dz_cnt] = vpr(MASKED_DZ, HEIGHT, params.zstep_m, params.zmax_m);
z_profile_segless = vpr(SEGLESS_MASKED_DZ, HEIGHT, params.zstep_m, params.zmax_m);

% Hack: use VPR to compute average rain, but it expects its input in
% decibel scale
pct_rain = vpr(db(double(RAIN)), HEIGHT, params.zstep_m, params.zmax_m);

% Convert to reflectivity
refl_profile = z_to_refl(z_profile);
refl_profile_segless = z_to_refl(z_profile_segless);

% Count classifications of non-clutter pulse volumes
num_bird_volumes   = nnz(BIRDS);
num_nodata_volumes = nnz(NODATA     & ~IGNORE);
num_rain_volumes   = nnz(RAIN       & ~IGNORE);
num_volumes        = numel(MASKED_DZ);
num_bb_volumes     = nnz(BEAM_BLOCKAGE);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% STORE ALL RESULTS AND RETURN %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[~,key] = fileparts(radar_path);

% Scan-level information, mostly meta info
result.key                  = key;
result.station              = radar.station;
result.lat                  = radar.lat;
result.lon                  = radar.lon;
result.year                 = radar.year;
result.hour                 = radar.hour;
result.minute               = radar.minute;
result.second               = radar.second;
result.vcp                  = radar.vcp;
result.height               = radar.height;
result.num_bird_volumes     = num_bird_volumes;
result.num_nodata_volumes   = num_nodata_volumes;
result.num_rain_volumes     = num_rain_volumes;
result.num_volumes          = num_volumes;
result.num_bb_volumes       = num_bb_volumes;


% Specify which fields to output to csv and their format
result.scan_fields = {
    'key'                           '%s'
    'station'                       '%s'
    'lat'                           '%.4f'
    'lon'                           '%.4f'
    'height'                        '%d'
    'vcp'                           '%d'
    'num_bird_volumes'              '%d'
    'num_nodata_volumes'            '%d'
    'num_rain_volumes'              '%d'
    'num_volumes'                   '%d'
    };

if params.diagnostics
    result.info.az                 = az;
    result.info.range              = range;
    result.info.radar              = radar;
    result.info.radar_dealiased    = radar_dealiased;
    result.info.DZ                 = DZ;
    result.info.MASKED_DZ          = MASKED_DZ;
    result.info.VR                 = VR;
    result.info.CLASS_LABELS       = CLASS_LABELS;
    result.info.labels             = labels;
end

if params.diagnostics
    result.info.SEG_MASK_CART      = SEG_MASK_CART;
    result.info.seg_y              = seg_y;
    result.info.seg_x              = seg_x;
    result.info.SEG_MASK_POL       = SEG_MASK_POL;
    result.info.net_labels         = net_labels;
end

% Profile fields
result.profile.bin_lower        = edges(1:end-1); % use the lowest height in each bin
result.profile.height           = z;
result.profile.linear_eta       = refl_profile;
result.profile.nbins            = dz_cnt;
result.profile.direction        = direction; % degrees CW from N
result.profile.speed            = speed;     % m/s
result.profile.u                = u;
result.profile.v                = v;
result.profile.rmse             = rmse;
result.profile.elev1            = elev(1) * ones(size(z));
result.profile.nvolumes_gr35_e1 = sum(sum(MASKED_DZ(:,:,1) >= 35)) * ones(size(z));
result.profile.elev2            = elev(2) * ones(size(z));
result.profile.nvolumes_gr35_e2 = sum(sum(MASKED_DZ(:,:,2) >= 35)) * ones(size(z));
result.profile.vcp              = radar.vcp * ones(size(z));
result.profile.linear_eta_unfiltered = refl_profile_segless;
result.profile.percent_rain     = pct_rain;

% Specify which fields to output to csv and their format
result.profile_fields = {
    'bin_lower'                 '%d'
    'height'                    '%d'
    'linear_eta'                '%.4f'
    'nbins'                     '%d'
    'direction'                 '%.4f'
    'speed'                     '%.4f'
    'u'                         '%.4f'
    'v'                         '%.4f'
    'rmse'                      '%.4f'
    'elev1'                     '%.4f'
    'nvolumes_gr35_e1'          '%d'
    'elev2'                     '%.4f'
    'nvolumes_gr35_e2'          '%d'
    'vcp'                       '%d'
    'linear_eta_unfiltered'     '%.4f'
    'percent_rain'              '%d'
    };

end

function F = mask_interpolant(MASK, range, az, elev)
    az = [az(end)-360; az(:); az(1)+360];
    MASK = cat(2, MASK(:,end,:), MASK(:,:,:), MASK(:,1,:));
    F = griddedInterpolant({range, az, elev}, double(MASK), 'nearest');
end
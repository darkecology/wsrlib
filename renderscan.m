function [gif, bg, x, y] = renderscan( radar, varargin )
%RENDERSCAN Render a radar scan for segmentation


% Copy of original RENDERSCAN, but supports multiple modalities
%such as radial velocity ('vr') and spectrum width ('sw') in addition to
%the default relfectivity ('dz').

%radar loading params
DEFAULT_COORDINATES     = 'cartesian'; % 'polar', 'cartesian'
DEFAULT_SWEEPS          = 1;           %a vector of length 1, 2, or 3

%radar alignment params
DEFAULT_RANGEMAX        = 150000;       %positive real

%image dimension params
DEFAULT_DIM             = uint16(500); %positive int
%Values changed as suggested by @tsungyu
DEFAULT_DZLIM           = [-33, 200];    %tuple of reals
DEFAULT_DZMAP           = gray(256);   %colormap

% parse inputs
parser = inputParser;
addRequired  (parser,'radar');
addParameter(parser,'sweeps',      DEFAULT_SWEEPS,         @(x) validateattributes(x,{'numeric'},{'nonempty','positive','integer'}));% && numel(x) <= 3);
addParameter(parser,'rangemax',    DEFAULT_RANGEMAX,       @(x) validateattributes(x,{'numeric'},{'>',0}));
addParameter(parser,'dim',         DEFAULT_DIM,            @(x) validateattributes(x,{'numeric'},{'integer','>',0}));
addParameter(parser,'dzlim',       DEFAULT_DZLIM,          @(x) validateattributes(x,{'numeric'},{'numel',2}));
addParameter(parser,'dzmap',       DEFAULT_DZMAP,          @(x) iptcheckmap(x,'renderscan','dzmap'));

parse(parser, radar, varargin{:});

sweeps      = parser.Results.sweeps;
rangemax    = parser.Results.rangemax;
dim         = parser.Results.dim;
dzlim       = parser.Results.dzlim;
dzmap       = parser.Results.dzmap;

% Initialize output
n_sweeps = length(sweeps);
%gif = zeros(dim, dim, n_sweeps, 'uint8');
if nargout >= 2
    bg = false(dim, dim, n_sweeps);
end

datalim = dzlim;
datanan= min(dzlim);

[data, y, x] = radar2mat(radar, 'fields', {'dz'}, 'coords', 'cartesian', 'r_max', rangemax, 'dim', dim, 'sweeps', sweeps);
data = data.dz;

bg = isnan(data);
data(bg) = datanan;
%mat2ind not used by segmentation training code for pre-processing
gif = data;
%gif = mat2ind(data, datalim, dzmap);

end
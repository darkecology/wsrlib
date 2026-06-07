function [MASK, range, az, elev] = static_clutter_mask(station, name)
%STATIC_CLUTTER_MASK Get static clutter mask for station
%
% [MASK, range, az, elev] = static_clutter_mask(station)
% [MASK, range, az, elev] = static_clutter_mask(station, name)
%
% Inputs:
%    station  The station call sign, e.g., KDOX
%    name     Which masks to use ('more' or 'less', default 'more'; see below)
%
% Outputs:
%    MASK     3D logical array, true corresponds to clutter
%    range    vector of range coordinates
%    az       vector of az coordinates
%    elev     vector of elevation coordinates
%
% The ouputs are compatible with griddedInterpolant:
%
%   F = griddedInterpolant({range, az, elev}, double(MASK), 'nearest')
%
% Masks are created from the average dBZ and POD@10dBZ over a number of
% daytime scans in January. 
%
%   "more" is the low threshold mask, which identifies more volumes as
%   clutter: a volume is clutter if
%
%     (average DBZ >= 20 and POD@10dBZ >= 5%) OR (POD@10dBZ >= 10%)
%
%   "less" is the high threshold mask, which identifies fewer volumes as
%   clutter: a volume is clutter if
%
%     (average DBZ >= 20 and POD@10dBZ >= 10%) OR (POD@10dBZ >= 20%)

if nargin < 2
    name = 'more';
end

filename = sprintf('%s/data/masks/clutter/static/%s/%s.mat', wsrlib_root(), name, station);

s = load(filename);
MASK = s.MASK;

% Cartesian interpolation
range = 500:500:150000;
az = linspace(1, 360, 360);
elev = 0.5:4.5;

end
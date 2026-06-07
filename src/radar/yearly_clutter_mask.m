function [MASK, range, az, elev] = yearly_clutter_mask(station, year, name)
%YEARLY_CLUTTER_MASK Get yearly clutter mask for station and year
%
% [MASK, range, az, elev] = yearly_clutter_mask(station, year)
% [MASK, range, az, elev] = yearly_clutter_mask(station, year, name)
%
% Inputs:
%    station  The station call sign, e.g., KDOX
%    year     The year (from 1995 to 2020)
%    name     Which masks to use ('more' or 'less', default 'more'; see below)
%
% Outputs:
%    MASK     3D logical array, true corresponds to clutter
%    range    vector of range coordinates
%    az       vector of az coordinates
%    elev     vector of elevation coordinates
%
% Masks do not exist for all station-year combinations. An error is thrown
% if the mask does not exist.
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

if nargin < 3
    name = 'low';
end

filename = sprintf('%s/data/masks/clutter/yearly/%s/%d/%s.mat', wsrlib_root(), name, year, station);

if ~exist(filename, 'file')
    error('No mask for %s, %4d', station, year);
end

s = load(filename);
MASK = s.MASK;

switch name
    case {'legacy'}
        az = linspace(1, 360, 360);
        range = linspace(500, 37500, 75);
        elev = 0.5:4.5;
    otherwise
        az = linspace(1, 360, 360);
        range = 500:500:150000;
        elev = 0.5:4.5;
end
end
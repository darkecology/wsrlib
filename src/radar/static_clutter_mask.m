function [MASK, range, az, elev] = static_clutter_mask(station, name)
%STATIC_CLUTTER_MASK Get static clutter mask for station
%
% [MASK, range, az, elev] = static_clutter_mask(station)
% [MASK, range, az, elev] = static_clutter_mask(station, name)
%
% Inputs:
%    station  The station call sign, e.g., KDOX
%    name     Which masks to use ('low' or 'high', default 'low'; see below)
%
% Outputs:
%    MASK     3D logical array, true corresponds to clutter
%    range    vector of range coordinates
%    az       vector of az coordinates
%    elev     vector of elevation coordinates
%
% The ouputs are compatible with griddedInterpolant:
%
%   F = griddedInterpolant(MASK, range, az, elev)

if nargin < 2
    name = 'low';
end

filename = sprintf('%s/data/masks/clutter/static/%s/%s.mat', wsrlib_root(), name, station);

s = load(filename);
MASK = s.MASK;

% Cartesian interpolation
range = 500:500:150000;
az = linspace(1, 360, 360);
elev = 0.5:4.5;

end
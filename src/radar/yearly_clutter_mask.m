function [MASK, range, az, elev] = yearly_clutter_mask(station, year, name)
%YEARLY_CLUTTER_MASK Get yearly clutter mask for station and year
%
% [MASK, range, az, elev] = yearly_clutter_mask(station, year)
% [MASK, range, az, elev] = yearly_clutter_mask(station, year, name)
%
% Inputs:
%    station  The station call sign, e.g., KDOX
%    year     The year (from 1995 to 2020)
%    name     Which masks to use ('low' or 'high', default 'low'; see below)
%
% Outputs:
%    MASK     3D logical array, true corresponds to clutter
%    range    vector of range coordinates
%    az       vector of az coordinates
%    elev     vector of elevation coordinates
%
% Masks do not exist for all station-year combinations. 
%
% The ouputs are compatible with griddedInterpolant:
%
%   F = griddedInterpolant(MASK, range, az, elev)


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
    case {'low', 'high'}
        % Cartesian interpolation
        az = linspace(1, 360, 360);
        range = 500:500:150000;
        elev = 0.5:4.5;
    case {'legacy'}
        az = linspace(1, 360, 360);
        range = linspace(500, 37500, 75);
        elev = 0.5:4.5;
end
end
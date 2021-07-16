function [MASK, range, az, elev] = occult_mask(station, name)
%OCCULT_MASK Get beam occultation mask for station
%
% [MASK, range, az, elev] = occult_mask(station)
% [MASK, range, az, elev] = occult_mask(station, name)
%
% Inputs:
%    station  The station call sign, e.g., KDOX
%    name     Which masks to use: '150km' or '50km'
%
% Outputs:
%    MASK     3D logical array, true corresponds to occultation
%    range    vector of range coordinates
%    az       vector of az coordinates
%    elev     vector of elevation coordinates
%
% The ouputs are compatible with griddedInterpolant:
%
%   F = griddedInterpolant(MASK, range, az, elev)

if nargin < 2
    name = '150km';
end

switch name
    case '150km'
        num_range = 150;
    case '50km'
        num_range = 50;
end

occult_thresh = 0.1;

filename = sprintf('%s/data/masks/occult/%s/%s.h5', wsrlib_root(), name, station);
info = h5info(filename);

% The last three datasets are /how, /what and /where. All of the previous
% ones correspond to occulation data for a given elevation
num_input_elevs = size(info.Groups, 1) - 3;

% Always output at least two elevations so it is suitable for interpolation.
% All data for the final elevation is always FALSE.
if num_input_elevs > 1
    num_output_elevs = num_input_elevs;
else
    num_output_elevs = 2;
end

all_elevs = [0.5, 1.0, 1.5, 1.8, 2.4, 3.1, 3.5, 4.0, 4.5, 5.1, 6.0, ...
    6.4, 7.5, 8.0, 8.7, 10.0, 12.0, 12.5, 14.0, 14.6, 15.6, 16.7, 19.5];

range = linspace(1000, num_range*1000, num_range);
az = linspace(0, 359, 360);
elev = all_elevs(1:num_output_elevs);

MASK = false(num_range, 360, num_output_elevs);

for i = 1:num_input_elevs
    dataset_key = sprintf('/dataset%d/data1/data', i);
    occult_data = h5read(filename, dataset_key);
    MASK(:, :, i) = occult_data > occult_thresh;
end

end
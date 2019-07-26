function [ data, range, az, elev ] = radar2mat_legacy( radar, fields, rmax )
%RADAR2MAT_LEGACY Convert an aligned radar volume to 3d-matrix
%
% [ data, range, az, elev ] = radar2mat_legacy( radar, fields, rmax )
%
% Inputs:
%   radar     radar struct (must be aligned. See below)
%   fields    cell array of fields to return (default: {'dz', 'vr'})
%   rmax      trim data beyond this radius (default: inf)
% Outputs:
%   data      cell array of 3D data matrices of size m x n x p
%   range     vector of ranges in meters (m x 1)
%   az        vector of azimuths in degrees (n x 1)
%   elev      vector of elevations in degrees (p x 1)
%
% NOTE: radar must first be aligned. 
%
% This function is now deprected. See radar2mat, which replaces it and does
% not require first calling align_radar
%
% SEE ALSO: radar2mat


if nargin < 2
    fields = {'dz', 'vr'};
end

if nargin < 3
    rmax = inf;
end

[is_aligned, msg] = check_aligned(radar, fields);
if ~is_aligned
    error('Radar is not aligned: %s\n. Please call align_scan\n', msg);
end

n = numel(fields);
data = cell(n,1);

% First compute the coordinates of each pulse volume
elev = [radar.dz.sweeps.elev]';
[az, range] = get_az_range(radar.dz.sweeps(1));
az = az(:);
range = range(:);

I = range < rmax;

% Get the output for each field
for f=1:n        
    tmp = cat(3, radar.(fields{f}).sweeps.data);        
    data{f} = tmp(I,:,:);
end

end

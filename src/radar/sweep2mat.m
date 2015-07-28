function [ data, range, az ] = sweep2mat( sweep )
%SWEEP2MAT Extract data matrix from sweep
%
% [ data, range, az ] = sweep2mat( sweep )
%
% Inputs:
%   radar     sweep struct
%
% Outputs:
%   data      matrix of size m x n  (m = # range bins, n = # radials)
%   range     vector of ranges in meters (m x 1)
%   az        vector of azimuths in degrees (n x 1)
%
% Note: replaces special flags with NaN
% 
% See also RADAR2MAT

% First compute the coordinates of each pulse volume
[az, range] = get_az_range(sweep);
az    = az(:);
range = range(:);
data  = sweep.data;

% Normalize column order so azimuths are increasing
[az, I] = sort(az(:));
data = data(:,I);

% Convert special codes in data matrix to NaN
FLAG_START = 131067;
data(data>=FLAG_START) = nan;

end

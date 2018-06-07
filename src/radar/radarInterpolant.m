function [ F ] = radarInterpolant( data, az, range, type )
%RADARINTERPOLANT - Create interpolating function for radar data
%
% F = radarInterpolant( data, az, range )
%
% Inputs:
%   data  - m x n data matrix in polar coordinates (columns are rays)
%   az    - vector or matrix of azimuths (*)
%   range - vector or matrix of ranges (*)
%
% Outputs:
%   F - interpolating function
%
% (*) az and range can be in matrix or vector form
% 
%  Matrix form: 
%    - az and range are both m x n
%    - az(i,j) is the azimuth for data(i,j)
%    - range(i,j) is the range for data(i,j)
%    - all rows of az are identical
%    - all columns of range are identical
%
%  Vector form:
%    - az is n x 1; az(j) is the azimuth of data(i,j)
%    - range is m x 1; range(i) is the range of data(i,j)

if nargin < 4
    type = 'linear';
end

[m,n] = size(data);

% Normalize az and range to be in compact form
if isequal(size(az), [m,n])
    az = az(1,:);
end

if isequal(size(range), [m,n])
    range = range(:,1);
end

% Ensure column vectors
az = az(:);
range = range(:);

% Normalize column order so azimuths are increasing
[az, I] = sort(az(:));
data = data(:,I);

% Make radials wrap around for proper interpolation
az   = [az(end)-360;  az;  az(1)+360 ]; 
data = [data(:,end)   data data(:,1)   ];

%Simple check to ensure strict monotonicity
n_mon = find(diff(az)==0);
for i=1:size(n_mon)
     az(n_mon(i)+1) =  az(n_mon(i)+1)+0.001;
end

% Create the interpolating function
F = griddedInterpolant({range, az}, data, type);

% We need to disable extrpolation in MATLAB 2013a and later, but
% the property does not exist in previous versions
if ismember('ExtrapolationMethod', properties('griddedInterpolant'))
    F.ExtrapolationMethod = 'none';
end

end


function F = vol_interp( radar, fields, type )
%VOL_INTERP Create an interpolating function for a volume

if nargin < 2
    fields = {'dz'};
end

if nargin < 3
    type = 'nearest';
end

n = length(fields);

[data, range, az, elev] = radar2mat(radar, fields);

% Repeat the first and last radials w/ azimuth += 360 degrees to get
% propert interpolation at boundary
az = [az(end)-360; az(:); az(1)+360];

% Make same adjustment in each 3D data matrix
for i=1:n
    data{i} = cat(2, data{i}(:,end,:), data{i}(:,:,:), data{i}(:,1,:));
end

% Create the interpolating functions
F = cell(n,1);
for i=1:n
    F{i} = griddedInterpolant({range, az, elev}, data{i}, type);
    
    % We need to disable extrpolation in MATLAB 2013a and later, but
    % the property does not exist in previous versions
    if ismember('ExtrapolationMethod', properties('griddedInterpolant'))
        F{i}.ExtrapolationMethod = 'none';
    end
end


end


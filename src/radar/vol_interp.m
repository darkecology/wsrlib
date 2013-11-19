function F = vol_interp( vol, rmax, type, default_val )
%volInterp Create an interpolating function for a volume

if nargin < 3
    type = 'nearest';
end

if nargin < 4 || isempty(default_val)
    default_val = 0;
end

n = numel(vol.sweeps);

sweeps = cell(n,1);
for i=1:n
    sweeps{i} = vol.sweeps(i);
end

[ data, ~, az, range ] = align_sweeps( sweeps, rmax, 'slant', '' );

elev = [vol.sweeps.elev];
data = cat(3, data{:});

data(data > 131000) = default_val;

az = [az(end)-360; az(:); az(1)+360];
data = cat(2, data(:,end,:), data(:,:,:), data(:,1,:));

% Create the interpolating function
F = griddedInterpolant({range, az, elev}, data, type);

end


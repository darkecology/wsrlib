function F = vol_interp_scatter( vol, type, default_val )
%volInterp Create an interpolating function for a volume

if nargin < 3
    type = 'nearest';
end

if nargin < 4
    default_val = 0;
end

n = numel(vol.sweeps);

azc    = cell(n,1);
rangec = cell(n,1);
elevc  = cell(n,1);
datac  = cell(n,1);

for i=1:n
    
    sweep = vol.sweeps(i);
    
    [ data, mask, az, range ] = align_sweeps( {sweep}, inf, 'slant' );
    
    data = data{:};
    data(~mask) = default_val;
%    az = [az(end)-360; az(:); az(1)+360];
%   data = [data(:,end) data data(:,1)];
    
    [m, n] = size(data);

    elev  = sweep.elev;
    az    = repmat(az, m, 1);
    range = repmat(range', 1, n);
    elev  = repmat(elev, m, n);
    
    datac{i}  = data(:);
    azc{i}    = az(:);
    rangec{i} = range(:);
    elevc{i}  = elev(:);
    
end

data = cat(1, datac{:});
az   = cat(1, azc{:});
range = cat(1, rangec{:});
elev = cat(1, elevc{:});

% Create the interpolating function
F = TriScatteredInterp(range, az, elev, data, 'nearest');

end


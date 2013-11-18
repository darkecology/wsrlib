function [ nyq_vel, az, range, elev, height, vr, azgvad, ygvad ] = get_pulse_volume_data(radar, rmin, rmax, zmax, gamma, min_vel)
%GET_PULSE_VOLUME_DATA 
%  Extract vectorized info about all pulse volumes in a volume scan

if nargin < 2
    rmin = 5000;
end

if nargin < 3
    rmax = 40000;
end

if nargin < 4
    zmax = 6000;
end

if nargin < 5
    gamma = 0.1;
end

if nargin < 6
    min_vel = 1; % Ignore targets with radial velocity < 1 m/s (AP ground clutter)
end

ntilts = length(radar.vr.sweeps);

NYQ_VEL = cell(ntilts, 1);
AZ      = cell(ntilts, 1);
RANGE   = cell(ntilts, 1);
ELEV    = cell(ntilts, 1);
HEIGHT  = cell(ntilts, 1);
VR      = cell(ntilts, 1);
AZGVAD  = cell(ntilts, 1);
YGVAD   = cell(ntilts, 1); % GVAD response variable

for i=1:ntilts

    sweep   = radar.vr.sweeps(i);
    elev    = deg2rad(sweep.elev);
    nyq_vel = sweep.nyq_vel;
        
    [az, range] = get_az_range(sweep);
    az = cmp2pol(az);
    [~, z] = slant2ground(range, sweep.elev);
    [az, range, z] = get_pixel_coords(az, range, z);
    
    vr = radar.vr.sweeps(i).data;
    vr(abs(vr) < min_vel | vr > 131000) = nan;
    [azgvad, ygvad] = gvad_response(nyq_vel, az, vr, gamma);
    
    inds = ~isnan(vr) & range >= rmin & range <= rmax & z <= zmax;
    n = nnz(inds);
    
    NYQ_VEL{i} = repmat(nyq_vel, n, 1);
    AZ{i}      = az(inds);
    RANGE{i}   = range(inds);
    ELEV{i}    = repmat(elev, n, 1);
    HEIGHT{i}  = z(inds);
    VR{i}      = vr(inds);
    AZGVAD{i}  = azgvad(inds);
    YGVAD{i}   = ygvad(inds);

end

% Now, put everything together into long vectors
nyq_vel = cat(1, NYQ_VEL{:});
az      = cat(1, AZ{:});
range   = cat(1, RANGE{:});
elev    = cat(1, ELEV{:});
height  = cat(1, HEIGHT{:});
vr      = cat(1, VR{:});
azgvad  = cat(1, AZGVAD{:});
ygvad   = cat(1, YGVAD{:});


end


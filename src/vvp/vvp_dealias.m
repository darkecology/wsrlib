function [ radar_dealiased, radar_smoothed ] = vvp_dealias( radar, edges, u, v, rmse, rmse_thresh )
%VVP_DEALIAS Dealias a volume using a velocity profile
%
%   radar_dealiased = vvp_dealias( radar, edges, u, v, rmse, rmse_thresh )
%
%  [radar_dealiased, radar_smoothed ] = vvp_dealias( radar, edges, u, v, rmse, rmse_thresh )
% 
% Inputs:
%   radar                 Radar struct from rsl2mat
%   edges, u, v, rmse     Output from epvvp (see also EPVVP)
%   rmse_thresh           Don't dealias in height bins with rmse exceeding
%                         this value
% Outputs:
%   radar_dealiased       Dealiased radar struct 
%
%   radar_smoothed        Optional second output gives predicted values
%                         under uniform velocity model
%
% See also EPVVP

if nargin < 6
    rmse_thresh = inf;
end

ntilts = numel(radar.vr.sweeps);

radar_dealiased = radar;
radar_smoothed = radar;

edges(1) = -inf;
edges(end) = inf;

for i=1:ntilts

    sweep = radar.vr.sweeps(i);
    nyq_vel = sweep.nyq_vel;

    % Get az, z, elev for each pulse volume
    [az, range] = get_az_range(sweep);
    az = cmp2pol(az);
    [~, z] = slant2ground(range, sweep.elev);
    [az, ~, z] = expand_coords(az, range, z);

    % Assign pulse volumes to wind levels
    [~, bin] = histc(z, edges);

    elev = repmat(deg2rad(sweep.elev), size(az));
    
    rmse_wind = nan(size(az));
    u_wind = nan(size(az));
    v_wind = nan(size(az));
    
    rmse_wind(:) = rmse(bin(:));
    u_wind(:) = u(bin(:));
    v_wind(:) = v(bin(:));

    vr = radar.vr.sweeps(i).data;
    vr(vr > 131000) = nan;
    valid = ~isnan(vr);        
    
    % The predicted value
    mu = cos(az).*cos(elev).*u_wind + sin(az).*cos(elev).*v_wind;    
    radar_smoothed.vr.sweeps(i).data(valid) = mu(valid);
    
    % Now dealias
    k = round((mu-vr)/(2*nyq_vel));
    dealiased_vr = vr + 2*nyq_vel*k;
%    resid = mu - dealiased_vr; 
    
    valid = rmse_wind < rmse_thresh;
    radar_dealiased.vr.sweeps(i).data(valid) = dealiased_vr(valid);
    
end

end


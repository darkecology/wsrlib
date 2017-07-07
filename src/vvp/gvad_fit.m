function [ u, v, y, nvalid, resid ] = gvad_fit( nyq_vel, az, elev, vr, beta )
%GVAD_FIT Fit velocity using gradient-based least squares
%
% Inputs: 
%  nyq_vel  Nyquist velocity
%  az       azimuth in radians
%  elev     elevation angle in radians
%  vr       radial velocity
%  beta     shift amount in radians

vel_res = nanmean(diff([az(:); az(1)+2*pi]));

lag = round(beta/vel_res);
beta = vel_res*lag;

n = length(az);

I = [lag+1:n 1:lag];
J = [n-lag+1:n 1:n-lag];

delta = vr(I) - vr(J);
beta_meas = (az(I)-az(J))/2;
az_meas   = az(I) + beta_meas;

delta = alias(delta, nyq_vel);

X = [-cos(elev) .* sin(az_meas), ...
      cos(elev) .* cos(az_meas)];

valid = ~isnan(delta);
nvalid = sum(valid);

if nvalid < 2
    y = nan(n,1);
    resid = nan(n,1);
    u = nan;
    v = nan;
else
    y = delta./(2*sin(beta_meas));

    coef = X(valid,:)\y(valid);
        
    u = coef(1);
    v = coef(2);

    resid = y - X*coef;
end

end


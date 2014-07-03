function [az_meas, y] = gvad_response( nyq_vel, az, vr, gamma )
%GVAD_RESPONSE Compute GVAD response variable
%
% Inputs: 
%  nyq_vel  Nyquist velocity
%  az       azimuth in radians
%  vr       radial velocity
%  gamma    shift amount in radians

[m, n] = size(az);

% If az is a matrix, turn it into a vector for now...
if m > 1
    az = az(1,:);
end
    
az_diff = alias(diff(az), pi);
vel_res = nanmedian(az_diff);

lag = round(gamma/vel_res);

I = lag + (1:n);
J = (1:n) - lag;

I = mod(I-1, n) + 1;
J = mod(J-1, n) + 1;

delta = vr(:,I) - vr(:,J);
gamma_meas = alias((az(I)-az(J))/2, pi);
az_meas = az(I) - gamma_meas;

delta = alias(delta, nyq_vel);
y = bsxfun(@rdivide, delta, (2*sin(gamma_meas)));

% Restore to original dimension of az
az_meas = repmat(az_meas, m, 1);

end

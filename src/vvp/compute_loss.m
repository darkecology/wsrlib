function [ rmse, nll ] = compute_loss( u, v, az, elev, height, vr, nyq_vel, edges, sigma)
% COMPUTE_LOSS Compute rmse and wrapped normal neg. log likelihood 
%
%  [ rmse, nll ] = compute_loss( u, v, az, elev, height, vr, nyq_vel, edges, sigma)
%

m = length(edges)-1;
[~, bin] = histc(height, edges);

rmse = nan(m,1);
nll  = nan(m,1);

X = [cos(az).*cos(elev) sin(az).*cos(elev)];

for i = 1:m 
    I = bin == i;
    
    y = vr(I);    
    mu = X(I,:)*[u(i); v(i)];
    
    n = sum(~isnan(y));
    
    if n > 0

        resid = alias(mu - y, nyq_vel(I));
        rmse(i) = sqrt(nanmean(resid.^2));

        if nargin < 9
            sigma = rmse(i)^2;
        end

        nll(i) = wrapped_normal_nll(nyq_vel(I), mu, y, sigma, 2)/n;        
    end
end

end

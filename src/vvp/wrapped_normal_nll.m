function [ nll ] = wrapped_normal_nll( nyq_vel, mu, y, sigma, k)
%WRAPPED_NORMAL_NLL Compute the wrapped normal negative log likelihood
%
% Inputs:
%   u        east-west wind component (scalar)
%   v        north-south wind component (scalar)
%   lambda   weight on prior term (scalar)
%   nyq_vel  the Nyquist velocity (scalar)
%   az       azimuth angle of measured gates (radians; vector)
%   elev     elevation of measured gates (radians; vector)
%   y        radial velocity of measured gates
% Outputs:
%   nll      negative log likelihood


if nargin < 5
    sigma = 4;
end

if nargin < 5
    k = 2;
end

resid = alias(mu(:) - y(:), nyq_vel(:));

% NOTE: outer product in expression for offsets
%   offsets(i,j) is the jth offset for nyquist velocity nyq_vel(i)
offsets = 2*nyq_vel(:)*(-k:k);  
resid = bsxfun(@plus, resid, offsets);

nll = -logsumexp(-resid.^2/(2*sigma^2), 2);
nll = nansum(nll);

end

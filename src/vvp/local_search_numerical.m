function [ K, b ] = local_search_numerical( K0, b0, X, y, nyq_vel, sigma, maxiter, w0 )
%LOCAL_SEARCH_NUMERICAL Perform numerical local search

if nargin < 7
    maxiter = 50;
end

if nargin < 8
    w0 = K0\b0;
end

thresh = 1e-3;

% Function to evaluate the negative log posterior
neglogprior = @(w) (w'*K0*w/2 - b0'*w);
negloglik   = @(w) (wrapped_normal_nll(nyq_vel, X*w, y, sigma, 2));

f = @(w) (neglogprior(w) + negloglik(w));

options = optimset('Display', 'off', 'LargeScale', 'off', 'MaxIter', maxiter, 'TolX', thresh, 'TolFun', thresh);

[w, ~, ~, ~, ~, H] = fminunc(f, w0, options);

K = H;
b = K*w;

end

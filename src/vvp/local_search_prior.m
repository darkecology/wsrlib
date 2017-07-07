function [ K, b ] = local_search_prior( K0, b0, X, y, nyq_vel, sigma, maxiter, mu0 )
%LOCAL_SEARCH_PRIOR Perform a local search with prior via least squares refitting

if nargin < 7
    maxiter = 10;
end

K = K0;
b = b0;

if nargin < 8
    mu = K\b;
else
    mu = mu0;
end

S = X'*X;

delta = inf;
iter = 1;

thresh = 1e-5;
estimate_sigma = true;

while delta > thresh && iter < maxiter
    
    interval = round((X*mu - y)./(2*nyq_vel));
    y_hat = y + 2*interval.*nyq_vel;
    
    if estimate_sigma       
        resid = X*mu - y_hat;
        sigma = sqrt(nanmean(resid.^2));
    end
    
    K = K0 + S/sigma^2;
    b = b0 + X'*y_hat/(sigma^2);

    tmp = K\b;
    delta = norm(mu - tmp);
    mu = tmp;
    
%    fprintf('Iter %d, delta=%.4f\n', iter, delta);
    iter = iter+1;
end

end

function [ w ] = local_search( nyq_vel, w, X, y, maxiter )
%LOCAL_SEARCH Perform a local search based on least squares refitting

if nargin < 5
    maxiter = 10;
end

w_old = inf;

thresh = 1e-5;

iter = 1;
delta = norm(w - w_old);
pred = X*w;

while delta > thresh && iter < maxiter

    w_old = w;
    
    interval = round((pred - y)./(2*nyq_vel));
    yhat = y + 2*interval.*nyq_vel;

    w = X\yhat;
    
    delta = norm(w - w_old);
%    fprintf('Iter %d, delta=%.4f, err=%.4f\n', iter, delta, nll);
    iter = iter+1;
end

end

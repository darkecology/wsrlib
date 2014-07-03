function [ edges, z, u, v, rmse, nll, cov, cnt ] = ...
    epvvp( radar, zstep, rmin, rmax, zmax, alg, gamma, sigma, sigma_prior, sigma_noise, verbose )
%EPVVP Volume velocity profile based on EP
%
% [ edges, z, u, v, rmse, nll, cov, cnt ] = epvvp( radar, zstep, rmin, rmax, zmax, alg, gamma, sigma, sigma_prior, sigma_noise, verbose )
%

MIN_DATA = 5;       % Height bins with fewer data points are discarded

if nargin < 2 || isempty(zstep)
    zstep = 20;
end

if nargin < 3 || isempty(rmin)
    rmin = 5000;
end

if nargin < 4 || isempty(rmax)
    rmax = 40000;
end

if nargin < 5 || isempty(zmax)
    zmax = 6000;
end

if nargin < 6 || isempty(alg)
    alg = 'EP';
end

if nargin < 7 || isempty(gamma)
    gamma = 0.1;
end

if nargin < 8 || isempty(sigma)
    sigma = 0.08;
end

if nargin < 9 || isempty(sigma_prior)
    sigma_prior = 50;
end

if nargin < 10 || isempty(sigma_noise)
    sigma_noise = 4;
end

if nargin < 11 || isempty(verbose)
    verbose = false;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Flags for the different processing steps
%   We use these sequentially, so the most basic algorithm is just gvad,
%   more sophisticated algorithms add additional steps.

use_gvad = true;
gvad_local_search = false;
kalman_pass = false;
ep_passes = 0;
numerical_hessian = false;

switch alg
    case 'GVAD'
    case 'GVAD+LOCAL'
        gvad_local_search = true;
    case 'GVAD+KALMAN'
        gvad_local_search = true;
        kalman_pass = true;
    case 'EP'
        gvad_local_search = true;
        kalman_pass = true;
        ep_passes = 1;
    case 'EP-NUMERICAL'
        gvad_local_search = true;
        kalman_pass = true;
        ep_passes = 1;
        numerical_hessian = true;
    otherwise
        error('Unrecognized algorithm');
end

% Model parameters
sigma_neighbor = sigma*sqrt(zstep);
maxiter = 10;        % max # of iterations in local search

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get data and split into bins
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ nyq_vel, az, range, elev, height, vr, azgvad, ygvad ] = get_vr_pulse_volumes(radar, rmin, rmax, zmax, gamma);

edges  = (0:zstep:zmax)';
m = length(edges)-1;
[cnt, bin] = histc(height, edges);
cnt = cnt(1:end-1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup for message passing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% Create node and edge potentials
prior = new_gausspot(eye(2)/sigma_prior^2, [0 0]); % weak gaussian prior
psi   = new_gausspot(kron([1 -1; -1 1]/sigma_neighbor^2, eye(2)), zeros(4,1));

% Create messages: intialize to all ones potential
ones_msg   = new_gausspot(zeros(2), zeros(2,1));
alpha      = repmat(ones_msg, m, 1);
beta       = repmat(ones_msg, m, 1);    
likelihood = repmat(ones_msg,  m, 1);  % approximate likelihood
posterior  = repmat(ones_msg,  m, 1);  % estimated posterior

% First pass: intialize unary potentials using gvad
if use_gvad
    for i = 1:m
                
        I = bin == i;

        y = ygvad(I);
        X = [-sin(azgvad(I)).*cos(elev(I)) cos(azgvad(I)).*cos(elev(I))];
        
        J = ~isnan(y);        
        
        if sum(J) < MIN_DATA
            likelihood(i) = prior;
        else
            % Do the GVAD fit
            X = X(J,:);
            y = y(J);
            w = X\y;
            resid = X*w - y;
            
            if gvad_local_search
                % Local search using VAD
                X = [cos(az(I)).*cos(elev(I)) sin(az(I)).*cos(elev(I))];
                y = vr(I);
                w = local_search( nyq_vel(I), w, X, y, maxiter );
                resid = X*w - y;
            end            
            
            n = sum(~isnan(resid));
            sigma_hat = sqrt(nansum(resid.^2)/(n-2));
            
            K = X'*X*(2*sin(gamma)/sigma_hat)^2; % Use estimated variance       
            likelihood(i).K = K;
            likelihood(i).b = K*w;
        end
    end
    
    posterior = likelihood;
end

    function alpha_update(i)
        % Update alpha(i+1) (to next step)
        if i < m
            p1 = expand_gausspot(alpha(i), [1 0]);
            p2 = expand_gausspot(likelihood(i), [1 0]);
            p  = multiply_gausspot(p1, p2, psi);
            alpha(i+1) = marg_gausspot(p, [0 0 1 1]);
        end
    end

    function beta_update(i)
        % Recompute beta(i-1) (to previous step)
        if i > 1
            p1 = expand_gausspot(beta(i),  [0 1]);
            p2 = expand_gausspot(likelihood(i), [0 1]);
            p  = multiply_gausspot(p1, p2, psi);
            beta(i-1) = marg_gausspot(p, [1 1 0 0]);
        end
    end

    function likelihood_update(i)
        % Update likelihood(i) (current time step)

        pot = multiply_gausspot(alpha(i), beta(i), prior);
%        mom = pot2moment(pot);
%        fprintf('Level %d, prior u= %.2f, v= %.2f, var(u)= %.2f, var(v)= %.2f\n', i, mom.mu(1), mom.mu(2), mom.S(1,1), mom.S(2,2));
        
        if cnt(i) < MIN_DATA
            posterior(i) = pot;
        else
            
            I = bin == i;
            y = vr(I);
            X = [cos(az(I)).*cos(elev(I)) sin(az(I)).*cos(elev(I))];

            [ posterior(i).K, posterior(i).b ] = local_search_prior( pot.K, pot.b, X, y, nyq_vel(I), sigma_noise, maxiter );
            
            if numerical_hessian
                [ posterior(i).K, posterior(i).b ] = local_search_numerical( pot.K, pot.b, X, y, nyq_vel(I), sigma_noise, maxiter );
            end
            likelihood(i) = divide_gausspot(posterior(i), pot);
            
        end

    end

if kalman_pass
    for i=1:m
        alpha_update(i);
    end
    for i=m:-1:1
        beta_update(i);
    end
    for i=1:m
        posterior(i) = multiply_gausspot(alpha(i), beta(i), likelihood(i), prior);
    end
end

for pass=1:ep_passes

    % Forward
    for i=1:m
        if verbose
            fprintf('Forward: level %d\n', i);
        end
        likelihood_update(i);
        alpha_update(i);
    end
    
    % Backward
    for i=m:-1:1
        if verbose
            fprintf('Backward: level %d\n', i);
        end
        likelihood_update(i);
        beta_update(i);
    end
    
end

% Now recover the parameters
z = edges(1:m) + diff(edges)/2; % Bin midpoints

% Convert to moment form (mean and variance)
moment = pot2moment(posterior);

w = cat(2, moment.mu)';
u = w(:,1);
v = w(:,2);

S = cat(3, moment.S);
S = reshape(S, 4, m)';
cov = S(:, [1 4 2]); % var(u), var(v), cov(u,v)

% Assess model fit
[rmse, nll] = compute_loss(u, v, az, elev, height, vr, nyq_vel, edges, sigma_noise);

end

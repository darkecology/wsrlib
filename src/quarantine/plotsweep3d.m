function h = plotsweep3d( sweep, rmax, hmax, scatter, sz, edgealpha )
%PLOTSWEEP3D Plot data from a sweep in 3-D
% Input:
%   sweep     - the sweep
%   rmax      - max. radius 
%   hmax      - max height.
%   scatter   - if true, displays a 3d scatter plot
%   sz        - resolution (optional)
%   edgealpha (optional)

if nargin < 5
    sz = [100 180];  % default resolution is 100 range bins and 180 degrees
end

if nargin < 6
    edgealpha = 0.06;
end

[datac, mask, az, range] = align_sweeps_old({sweep}, rmax, 'ground');
data = datac{1};
data(~mask) = 0;

[dist, height] = slant2ground(range, sweep.elev);

% m = # gates, n = # rays
[m,n] = size(data);

I = find(range <= rmax & height < hmax);
J = 1:n;

% Downsample to specified size
istep = round(length(I)/sz(1));
jstep = round(length(J)/sz(2));

I = I(1:istep:end);
J = [J(1:jstep:end) 1];
az = [az; az(1)+360];      % always include wraparound


% Compute cartesian coordinates
r = repmat(dist', 1, n);
z = repmat(height', 1, n);
thet = repmat(sweep.azim_v', m, 1);
[x,y] = pol2cart(deg2rad(90-thet), r);

x = x/1000;
y = y/1000;
z = z/1000;

if scatter
    X = vec(x(I,J));
    Y = vec(y(I,J));
    Z = vec(z(I,J));
    C = vec(data(I,J));
    i = C > 5;
    h = scatter3(X(i), Y(i), Z(i), 20, C(i), 'o', 'filled');
else
    
    im = imresize(data, sz);
    
    % Some fancy 
    mu = 8;
    sigma = 1;
    sigmoid = @(x) (1./(1+exp(-(x - mu)/sigma^2)));
    alpha = sigmoid(im);

    alpha_max = 0.5;
    alpha_min = 0.0;
    alpha = alpha*(alpha_max - alpha_min) + alpha_min;
    alpha(:) = 1;
    
    h = surf(x(I,J), y(I,J), z(I,J), im, 'edgecolor', 'black', 'edgealpha', edgealpha, 'facealpha', 'flat', 'alphadatamapping', 'none', 'alphadata', alpha, 'LineSmoothing', 'on', 'Linewidth', 0.1, 'EdgeColor', 0.5*[1 1 1]);
    
end

end


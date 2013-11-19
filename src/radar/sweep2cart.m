function [z, x, y, F] = sweep2cart( sweep, rmax, dim, interp_type, use_ground_range )
%SWEEP2CART Convert a sweep to cartesian coordinates
% 
%  im = sweep2cart( sweep, rmax, dim )
%
% Inputs:
%   sweep - a sweep struct
%   rmax  - the max radius of the cartesian image
%   dim   - # of pixels of the cartesian image
%
% Example:
%   radar = rsl2mat(...);
%   z = sweep2cart(radar.dz.sweeps(1));
%   imagesc(z);
%

if nargin < 4
    interp_type = 'linear';
end

if nargin < 5
    use_ground_range = true;
end

[az, range] = get_az_range(sweep);
data = sweep.data;

FLAG_START = 131067;
data(data > FLAG_START) = nan;

% Convert from slant range to ground range
if use_ground_range
    range = slant2ground(range, sweep.elev);
end

% Now convert to cartesian
[z, x, y, F] = mat2cart(data, az, range, dim, rmax, interp_type);

end

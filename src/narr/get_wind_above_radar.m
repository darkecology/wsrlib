function [u, v, windSpeed, windDirection, elev] = get_wind_above_radar(u_wind, v_wind, lon, lat, mode, min_elev, max_elev)

if nargin < 2
    error('First two arguments (u_wind and v_wind) are required');    
end

if nargin < 4
    error('Arguments lon and lat are required');
end

if nargin < 5
    mode = 'nearest';
end

if nargin < 6
    min_elev = 0;
end

if nargin < 7
    max_elev = realmax();
end

%get the coordinates for the radar station
[x, y] = ll2xy(lon, lat);
[i, j] = xy2ij(x, y);

%create height bins (translate heights to indices)
start_bin = height2level(min_elev);
end_bin = height2level(max_elev);

levels = (start_bin:end_bin)';
nlevels = length(levels);

%init returns
%note there will be (end_bin-start_bin+1) total bins returned
u = zeros(nlevels, 1);
v = zeros(nlevels,1);
windSpeed = zeros(nlevels,1);
windDirection = zeros(nlevels,1);
elev = zeros(nlevels,1);

%compute the wind velocity at each bin
switch mode
    case 'average'
        %compute average wind metrics over all data in each bin
        for elev_index = (start_bin:end_bin)
            u_wind_level = u_wind(elev_index,:,:);
            v_wind_level = v_wind(elev_index,:,:);
            
            [s1,s2,s3] = size(u_wind_level);
            u_avg = nanmean(reshape(u_wind_level,s1*s2*s3,1));
            v_avg = nanmean(reshape(v_wind_level,s1*s2*s3,1));
            
            %convert to polar (measured in degrees)
            [theta, radius] = cart2pol(u_avg,v_avg);
            theta = rad2deg(theta);
            theta = wrapTo180(theta);
            
            %save to the return vals (index is adjusted to [1:N])
            windSpeed(elev_index - start_bin + 1) = radius;
            windDirection(elev_index - start_bin + 1) = theta;
            elev(elev_index - start_bin + 1) = level2height(elev_index);
        end
    case 'nearest'
                
        u(:) = u_wind(levels, i, j);
        v(:) = v_wind(levels, i, j);
                
        [theta, radius] = cart2pol(u, v);
        windDirection = pol2cmp(theta);
        windSpeed = radius;
        elev = level2height(levels);

end

end
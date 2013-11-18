function [u, v, windSpeed, windDirection, elev] = get_wind_above_radar(radar, u_wind, v_wind, mode, max_elev)

if nargin < 1
    radar = loadtestradar;
end

if nargin < 2
    year = radar.year;
    month = radar.month;
    
    wind_dir = '/Users/kwinn/Work/Matlab/cajun/data/NARR';
    
    wind_file = get_wind_file(radar,wind_dir);
    fprintf('The corresponding wind file is %s \n',wind_file);

    [u_wind v_wind] = read_narr_wind(wind_file);
end

if nargin < 4
    mode = 'nearest';
end

if nargin < 5
    max_elev = intmax;
end

%get the coordinates for the radar station
[x, y] = ll2xy(radar.lon, radar.lat);
[i, j] = xy2ij(x, y);

%Create a map of pressure levels and elevations
% pressure_elev = containers.Map('keyType','uint32','valueType','uint32');
% pressure_levels = [1000,975,950,925,900,875,850,825,800,775,750,725,700,650,600,550,500,450,400,350,300,275,250,225,200,175,150,125,100];
% elevations = [111,323,540,762,989,1220,1457,1700,1949,2204,2466,2735,3012,3591,4206,4865,5574,6344,7185,8117,9164,9741,10363,11037,11784,12631,13608,14765,16180];
% for i=1:size(pressure_levels),
%     pressure_elev(pressure_levels(i)) = elevations(i);
% end

%create height bins (translate heights to indices)
start_bin = height2level(radar.height);
end_bin = height2level(max_elev);

%init returns
%note there will be (end_bin-start_bin+1) total bins returned
u = zeros(end_bin-start_bin+1,1);
v = zeros(end_bin-start_bin+1,1);
windSpeed = zeros(end_bin-start_bin+1,1);
windDirection = zeros(end_bin-start_bin+1,1);
elev = zeros(end_bin-start_bin+1,1);

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
        for elev_index = (start_bin:end_bin)
            u(elev_index - start_bin + 1) = u_wind(elev_index,i,j);
            v(elev_index - start_bin + 1) = v_wind(elev_index,i,j);
            
            %convert to polar (measured in degrees)
            [theta, radius] = cart2pol(u(elev_index - start_bin + 1),v(elev_index - start_bin + 1));
            theta = pol2cmp(theta);
%             theta = wrapTo360(theta);
            
            %save to the return vals (index is adjusted to [1:N])
            windSpeed(elev_index - start_bin + 1) = radius;
            windDirection(elev_index - start_bin + 1) = theta;
            elev(elev_index - start_bin + 1) = level2height(elev_index);
        end
end

end
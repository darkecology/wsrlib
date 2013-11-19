function [ windSpeed, windDirection ] = calc_wind_avg(u_wind,v_wind,height,max_elev)
%Calculate the average wind speed and wind direction from the u_wind and
%v_wind components. 
%height is the height of the radar, and max_elev is the elevation till we
%want to average

%Create a map of pressure levels and elevations
pressure_elev = containers.Map('keyType','uint32','valueType','uint32');
pressure_levels = [1000,975,950,925,900,875,850,825,800,775,750,725,700,650,600,550,500,450,400,350,300,275,250,225,200,175,150,125,100];
elevations = [111,323,540,762,989,1220,1457,1700,1949,2204,2466,2735,3012,3591,4206,4865,5574,6344,7185,8117,9164,9741,10363,11037,11784,12631,13608,14765,16180];
for i=1:size(pressure_levels),
    pressure_elev(pressure_levels(i)) = elevations(i);
end

%Find out the start bin and end bin
start_bin = find(abs(height-elevations)==min(abs(height-elevations)));
end_bin = find(abs(max_elev-elevations)==min(abs(max_elev-elevations)));

u_wind = u_wind(start_bin:end_bin,:,:);    
v_wind = v_wind(start_bin:end_bin,:,:);

[s1,s2,s3] = size(u_wind);
u_avg = nanmean(reshape(u_wind,s1*s2*s3,1));
v_avg = nanmean(reshape(v_wind,s1*s2*s3,1));
windSpeed = sqrt(u_avg^2 + v_avg^2);
windDirection = rad2deg(atan(u_avg/v_avg));

end


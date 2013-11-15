radar_file = 'data/KBGM20110925_015712_V03.gz';
%radar_file = 'data/KDOX20090902_104018_V04.gz';  % Legacy resolution

%radar_file = 'data/KDIX20090902_103042_V03.gz';

% Parse the filename to get the station
scaninfo = wsr88d_scaninfo(radar_file);

% Construct options for rsl2mat
opt = struct();
opt.cartesian = false;
opt.max_elev = 100;
radar = rsl2mat(radar_file, scaninfo.station, opt);

rmax = 100000;
F = vol_interp(radar.dz, rmax, 'linear');

% Generate an (x,y,z) grid 
dim = 400;

clim = [-5 20];

phi = 0;
%for phi = -30:2:360
while true
    r = linspace (0, rmax, dim);

    xx = r.*cos(deg2rad(90-phi));
    yy = r.*sin(deg2rad(90-phi));
    zz = linspace(0, 5000, 100);

    m = length(zz);
    n = length(xx);

    x = repmat(xx, m, 1);
    y = repmat(yy, m, 1);
    z = repmat(zz', 1, n);

    % Map (x,y) coordinates to slant radius and azimuth
    %[x, y, z] = meshgrid(x, y, z);

    [az, range, elev] = xyz2radar(x, y, z);

    
    %%% PPI plot
    figure(1); clf();
    z = sweep2cart(radar.dz.sweeps(1), rmax, dim);
        
    h1 = imagesc([-rmax rmax], [-rmax rmax], z, clim);
    set(h1, 'alphadata', ~isnan(z));
    set(gca, 'color', 0*[1 1 1]);
    colormap(jet);

    hold on;    
    plot(xx, -yy, 'g', 'linewidth', 2);
    
    %%% Cross-section plot
    figure(2);
    clf();
    dz = F(range, az, elev);

    h2 = imagesc(r, zz, dz, clim);
    set(h2, 'alphadata', ~isnan(dz));    
    colormap(jet);
    axis xy;
    grid on;
    colorbar();

    figure(1);
    [a, b] = ginput(1);
    phi = 90 - rad2deg(atan2(-b, a));
    fprintf('a=%.4f, b=%.4f, phi=%.4f\n', a, b, phi);
    
    %    pause;
end

return

% Generate an (x,y) grid 
x1 = linspace (-rmax, rmax, dim);
y1 = -x1;


x0 =  76*0.5;
y0 = -97*0.5;
r = 40;

% Generate an (x,y) grid 
radius = 30000
x1 = linspace (-rmax, rmax, dim);
y1 = -x1;

% Map (x,y) coordinates to slant radius and azimuth
[x, y] = meshgrid(x1, y1);
[phi, s] = cart2pol(x, y);

% Azimuth is measured clockwise from north in degrees
phi = 90-rad2deg(phi); 
phi(phi > 360) = phi(phi > 360) - 360;
phi(phi < 0) = phi(phi < 0) + 360;

% Now get slant range of each pixel on this elevation
r = groundElev2slant(s, sweep.elev);




return

figure(1);
clf();

rmax = 150000;
dim = 600;
opt = displayopts();

for i=1:4

    z = sweep2cart(radar.dz.sweeps(i), rmax, dim);
    
    subplot(2, 4, i);
    h = imagesc(z);
    set(h, 'alphadata', ~isnan(z));
    set(gca, 'color', 0*[1 1 1]);
    colormap(opt.dzmap);
    freezeColors();

    
end

for i=1:4

    z = sweep2cart(radar.vr.sweeps(i), rmax, dim);
    
    subplot(2, 4, 4+i);
    h = imagesc(z);
    set(h, 'alphadata', ~isnan(z));
    set(gca, 'color', 0*[1 1 1]);
    colormap(opt.vrmap);
    freezeColors();

end


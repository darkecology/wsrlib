[radar_file, station] = sample_radar_file();

% Construct options for rsl2mat
radar = rsl2mat(radar_file, station);

rmax = 37500;

% Paramters for align_scan
F = vol_interp(radar, {'dz'}, 'nearest');
F = F{1};

% Generate an (x,y,z) grid 
dim = 100;

clim = [-5 35];

rdim = 200;
zdim = 100;
phi = 0;
%for phi = -30:2:360
while true
    r = linspace (0, rmax, rdim);

    xx = r.*cos(deg2rad(90-phi));
    yy = r.*sin(deg2rad(90-phi));
    zz = linspace(0, 5000, zdim);

    m = length(zz);
    n = length(xx);

    x = repmat(xx, m, 1);
    y = repmat(yy, m, 1);
    z = repmat(zz', 1, n);

    % Map (x,y) coordinates to slant radius and azimuth
    %[x, y, z] = meshgrid(x, y, z);

    [range, az, elev] = xyz2radar(x, y, z);
    
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
    
end

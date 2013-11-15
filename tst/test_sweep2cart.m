%radar_file = 'data/KBGM20110925_015712_V03.gz';
radar_file = 'data/KDOX20090902_104018_V04.gz';  % Legacy resolution

% Parse the filename to get the station
scaninfo = wsr88d_scaninfo(radar_file);

% Construct options for rsl2mat
opt = struct();
opt.cartesian = false;
opt.max_elev = 10;
radar = rsl2mat(radar_file, scaninfo.station, opt);

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


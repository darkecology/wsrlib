[radar_file, station] = sample_radar_file();

% Construct options for rsl2mat
radar = rsl2mat(radar_file, station);

figure(1);
clf();

rmax = 150000;
dim = 600;
opt = displayopts();

dzmap = jet(32);
vrmap = vrmap2(32);

for i=1:4

    [z, x, y] = sweep2cart(radar.dz.sweeps(i), rmax, dim);    
    
    subplot(2, 4, i);
    imagescnan(x, y, z);
    axis xy;
    set(gca, 'color', [0 0 0]);
    colormap(dzmap);
    freezeColors();
    
end

for i=1:4

    [z, x, y] = sweep2cart(radar.vr.sweeps(i), rmax, dim);
    
    subplot(2, 4, 4+i);
    imagescnan(x, y, z);
    axis xy;
    set(gca, 'color', [0 0 0]);
    colormap(vrmap);
    freezeColors();

end


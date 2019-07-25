key = 'KBGM20130412_022349'; % weather
key = 'KRTX20100510_062940'; % weather
key = 'KABX20170902_041920'; % mix
key = 'KRTX20150514_062414'; % clear

% Read scan from s3
info = aws_parse(key);
radar = rsl2mat_s3(key, info.station);

% Call mistnet
[PREDS, PROBS, classes, y, x, elevs] = mistnet( radar );

% Render radar data for comparison
data = radar2mat(radar, 'coords', 'cartesian', 'r_max', 150000, 'dim', 600);

% Display data and segmentation
figure(1); clf();

cmap = [0, 0.5, 1;
        1, 0.5, 0;
        1, 0, 0];
colormap(cmap);

plot_idx = 1;
for i = 1:5
    subplot(5,2, plot_idx);
    imagesc(x, y, data.dz(:,:,i), [-5, 35]);
    axis xy;
    colormap(gca, jet(32));
    c = colorbar();
    c.Label.String = 'dBZ';
    
    plot_idx = plot_idx + 1;

    subplot(5,2, plot_idx);
    image(x, y, PREDS(:,:,i));  
    axis xy;
    colormap(gca, cmap);
    colorbar('YTick', 1.5:3.5, 'YTickLabel', {'background', 'biology', 'rain'});
    
    plot_idx = plot_idx + 1;    
end

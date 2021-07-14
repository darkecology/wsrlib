% Retrieval and display of clutter and occultation masks in their polar
% coordinate systems. 
%
% Warning: clutter and occultation masks use different polar coordinate 
% systems. Conversion is required before comparing them.

station = 'KVTX';
year = 2020;

figure(1);
[MASK, range, az, elev] = occult_mask(station);
plot_mask(MASK, range, az, elev, 'Occultation');

figure(2);
[MASK, range, az, elev] = static_clutter_mask(station);
plot_mask(MASK, range, az, elev, 'Static clutter');

figure(3);
[MASK, range, az, elev] = yearly_clutter_mask(station, 2020, 'low');
plot_mask(MASK, range, az, elev, 'Clutter 2010');

function plot_mask(MASK, range, az, elev, name)
    rmax = 150000;
    num_elev = length(elev);
    for i = 1:num_elev
       subplot(num_elev, 1, i);       
       [im, x, y] = mat2cart(double(MASK(:,:,i)), az, range, 600, rmax, 'nearest');
       image(x, y, int32(im));
       title(sprintf('%s: %.2f degrees', name, elev(i)));
       colormap(lines(2));
    end
end
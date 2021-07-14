% Retrieval and display of clutter and occultation masks in common
% systems

station = 'KTYX';
station = 'KCXX';
station = 'KVTX';
station = 'KYUX';
station = 'KBBX';
%station = 'KDOX';
station = 'KAMX';

% Get occult and clutter masks and interpolants
[OCCULT_MASK, range, az, elev] = occult_mask(station);
F_occult = get_interpolant(OCCULT_MASK, range, az, elev);

[CLUTTER_MASK, range, az, elev] = static_clutter_mask(station);
F_clutter = get_interpolant(CLUTTER_MASK, range, az, elev);

% Get output coordinates
figure(1);

az = 1:360;
range = 1000:1000:150000;
elev = 0.5:4.5;
[RANGE, AZ, ELEV] = ndgrid(range, az, elev);

OCCULT = F_occult(RANGE, AZ, ELEV);
CLUTTER = F_clutter(RANGE, AZ, ELEV);

MASK = int32(zeros(size(AZ)));
MASK(CLUTTER > 0) = 1;
MASK(OCCULT > 0) = 2;
plot_masks(MASK, range, az, elev);

function plot_masks(MASK, y, x, elev)
    num_elev = length(elev);
    for i = 1:num_elev
        subplot(num_elev, 1, i);
        image(x, y, MASK(:,:,i));
        title(sprintf('%.2f degrees', elev(i)));
        colormap(lines(3));
        caxis([0 3]);
        colorbar('YTick', 0.5:3.5, 'YTickLabel', {'', 'normal', 'clutter', 'occult'});
    end
end

function F = get_interpolant(DATA, range, az, elev)
    az = [az(end)-360;  az(:);  az(1)+360 ];
    DATA = cat(2, DATA(:,end,:), DATA, DATA(:,1,:));
    F = griddedInterpolant({range, az, elev}, double(DATA), 'nearest');
end

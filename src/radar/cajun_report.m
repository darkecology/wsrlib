function cajun_report( result, filename, show_fig, cajun_rmax, vis_rmax )
%CAJUN_REPORT Produce diagnostic image of cajun workflow on a single scan 
%
% cajun_report(result, filename, show_fig)
% 
% Inputs: 
%    result     Output struct from CAJUN
%    filename   Filename to save image
%    show_fig   Whether to show report in figure window if running
%               interactively
%
% This function creates a multi-panel figure showing steps of the cajun 
% workflow after it is applied to a radar scan. It saves the figure to file
% as a .png file and/or displays it in a MATLAB figure window.
%
% See also: CAJUN

% Extract the variable used in the script
radar           = result.info.radar;
radar_dealiased = result.info.radar_dealiased;
DZ              = result.info.MASKED_DZ;
range           = result.info.range;
az              = result.info.az;
density         = result.profile.linear_eta;

direction = result.profile.direction;
height    = result.profile.height;

nvolumes_gr35_e1 = result.profile.nvolumes_gr35_e1;
nvolumes_gr35_e2 = result.profile.nvolumes_gr35_e2;

[~, name] = fileparts(result.params.radar_path);


% Colormaps
[DZMAP, dzlim] = dzmap_kyle;

VRMAP = vrmap2(32);
vrlim = [-20, 20];

% Create the figure (change visibility to 'off' for deployment)
position = [100 100 500 540];

if nargin < 3
    show_fig = ~isdeployed;
end

if nargin < 4
    cajun_rmax = 50000;
end

if nargin < 5
    vis_rmax = 115000;
end

if show_fig
    f = figure('InvertHardcopy', 'off', 'Position', position);
else
    f = figure('Visible', 'off', 'InvertHardcopy', 'off', 'Position', position);
end


% Segmentation mask out to 115km
subplot_tight(3,3,1,.01);
seg_mask_map = [0, 1, 0;
                0, 0.5, 1;
                1, 0.5, 0;
                1, 0, 0];
im = ind2rgb(uint8(result.info.SEG_MASK_CART(:,:,1)), seg_mask_map);
x = result.info.seg_x;
y = result.info.seg_y;
image(x, y, im);
axis xy;
axis square;
hold on;
set(gca,'YTick',[])
set(gca,'XTick',[])
xlim([-vis_rmax vis_rmax]);
ylim([-vis_rmax vis_rmax]);


% Unmasked DZ out to cajun_rmax
subplot_tight(3,3,2,.01, 'Color',[.5 .5 0]);
rmax = cajun_rmax;
dim = 600;
[data, x, y] = mat2cart(result.info.DZ(:,:,1), az, range, dim, rmax);
imagesc(x, y, data);
caxis(dzlim)
colormap(gca, DZMAP)
set(gca,'YTick',[])
set(gca,'XTick',[])
shading flat
axis xy;
axis square;
hold on;
set(gca,'color','black')
text(-36000,34000,num2str(nvolumes_gr35_e1(1)), 'color','white','fontsize',18)


% Full classification out to cajun_rmax
subplot_tight(3,3,3,.01);
CLASS_LABELS = double(result.info.CLASS_LABELS);
rmax = cajun_rmax;   % 37.5km
dim  = 600;     % 600 pixel image
class_names = fieldnames(result.info.labels);
class_names = cellfun(@(s) strrep(s, '_', ' '), class_names, 'UniformOutput', false);
n_classes = numel(class_names);
mask_map = lines(n_classes+1); % 0 to n_classes
[mask_im, x, y] = mat2cart(CLASS_LABELS(:,:,1), az, range, dim, rmax, 'nearest');
image(x, y, uint16(mask_im));
colormap(gca, mask_map);
set(gca,'YTick',[])
set(gca,'XTick',[])
shading flat
axis xy;
axis square;
hold on;
set(gca,'color','black')

do_colorbar = true;
if do_colorbar
    colorbar('location', 'east', 'Color', [1, 1, 1], ...,
        'YLim', [0, n_classes+1], ...
        'YTick', 0.5 + (0:n_classes), ...
        'YTickLabel', {'', class_names{:}});
end

% DZ to 115km
subplot_tight(3,3,4, .01);
set(gca,'color','black')
rmax = vis_rmax;   % 115km
dim  = 600;      % 600 pixel image
[data, x, y] = sweep2cart(radar.dz.sweeps(1), rmax, dim);
imagesc(x, y, data);
caxis(dzlim);
colormap(gca, DZMAP)
colorbar('location', 'east', 'Color', [1, 1, 1]);
axis xy;
axis square;
hold on;
set(gca,'YTick',[])
set(gca,'XTick',[])
xlim([-vis_rmax vis_rmax]);
ylim([-vis_rmax vis_rmax]);

% DZ to 37.5km --- 1st sweep
subplot_tight(3,3,5,.01, 'Color',[.5 .5 0]);
rmax = cajun_rmax;
dim = 600;
[data, x, y] = mat2cart(DZ(:,:,1), az, range, dim, rmax);
imagesc(x, y, data);
caxis(dzlim)
colormap(gca, DZMAP)
set(gca,'YTick',[])
set(gca,'XTick',[])
shading flat
axis xy;
axis square;
hold on;
set(gca,'color','black')
text(-36000,34000,num2str(nvolumes_gr35_e1(1)), 'color','white','fontsize',18)

% DZ to cajun_rmax --- 2nd sweep
subplot_tight(3,3,8,.01, 'Color',[.5 .5 0]);
rmax = cajun_rmax;
dim = 600;
[data, x, y] = mat2cart(DZ(:,:,2), az, range, dim, rmax);
imagesc(x, y, data);
caxis(dzlim)
colormap(gca, DZMAP)
set(gca,'YTick',[])
set(gca,'XTick',[])
shading flat
axis xy;
axis square;
hold on;
set(gca,'color','black')
text(-36000,34000,num2str(nvolumes_gr35_e2(1)), 'color','white','fontsize',18)

% VR to cajun_rmax
h = subplot_tight(3,3,6,.01);
rmax = cajun_rmax;   % 37.5km
dim  = 600;      % 600 pixel image
[data, x, y] = sweep2cart(radar_dealiased.vr.sweeps(1), rmax, dim);
imagesc(x, y, data);
colormap(h, VRMAP)
caxis(vrlim)
set(gca,'YTick',[])
set(gca,'XTick',[])
axis ('xy');
axis square;
xlim([-cajun_rmax cajun_rmax]);
ylim([-cajun_rmax cajun_rmax]);

% db(ETA) profile
subplot_tight(3,3,7,.1);
plot(db(density), height, 'o');
xlabel('db(Mean reflectivity (cm^2/km^3))');
ylabel('Height (m)');
xlim([-30,45]);
ylim([0,3001]);

subplot_tight(3,3,9,.1);
plot(direction, height, 'o');
xlabel('Track (degrees)');
set(gca,'YTick',[])
xlim([0,360]);
ylim([0,3001]);


set(gcf,'color','white')

title_str =  [name(1:4), '   ' name(9:10), '/', name(11:12),'/', name(5:8), '   '...
    name(14:15),':',  name(16:17),':', name(18:19)];


% Plot title
axes('Position', [0 0 1 1],...
    'Xlim', [0 1], ...
    'Ylim', [0 1], ...
    'Box', 'off', ...
    'Visible', 'off', ...
    'Units', 'normalized', ...
    'clipping' , 'off');

text(0.5, 1, title_str, ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'top');

if ~isempty(filename)
    print('-dpng', filename);
end

if ~show_fig
    close(f);
end
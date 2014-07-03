% Specify the location of the data set. 
dataSetName = '/Users/jeffrey/Documents/cajunTest/data';

%function [ ] = testAlignSweepsToFixedImagery( dataSetName )
%testAlignSweepsToFixedImagery Interactive Unit Test to visualize results
%before and after aligning sweeps.


tic
scans = getScans(dataSetName);      %get absolute paths of all scans in the dataset
log  = fopen('testAlignSweepsToFixedImageryLOG.txt','w+');  %test log file

if log == -1
    error('Could not create log file');
end

% parameters for the imagery
rmax = 150000;                           % no reason, we are most used to this!
dim  = 500;
figure(1);
clf();
set(gcf, 'Position', [200 200 1000 400]);

figure(2);
clf();

pause(0.01);

dzlim = [-5 30];
dzmap = jet(32);

vrlim = [-30 30];
vrmap = vrmap2(32);


for i=1:size(scans,1),
    radar_file = scans(i);
    
    % Parse the filename to get the station
    scaninfo = wsr88d_scaninfo(radar_file{1});
    
    % Construct options for rsl2mat
    opt = struct();
    opt.cartesian = false;
    opt.max_elev = 5;
    
    try
        radar = rsl2mat(radar_file{1}, scaninfo.station, opt);
        radar_aligned = align_scan(radar, true, 0.25, 250, 250000);
        
        % Note that the velocity sweeps are not dealiased
        
        fields = {    'dz',        'vr' };
        clims  = { [-5 30],    [-30 30] };
        cmaps  = { jet(32),  vrmap2(32) };
        
        numSweeps = {size(radar.dz.sweeps,1), size(radar.vr.sweeps,1)};
        fieldNames = {'Reflectivity' , 'Radial Velocity'};
        
        for fi=1:length(fields),
            
            field = fields{fi};
            numSweep = numSweeps{fi};
            clim = clims{fi};
            cmap = cmaps{fi};
            
            for j=1:numSweep,
                
                
                ORIG = radar.(field).sweeps(j);                
                im1 = sweep2cart(ORIG, rmax, dim, 'linear');
                
                NEW  = radar_aligned.(field).sweeps(j);
                im2 = sweep2cart(NEW, rmax, dim, 'linear');

                diff = abs(im2 - im1);
                
                figure(1);
                subplot(1,2,1);
                imagesc(im1, clim);
                colormap(cmap);
                axis off;
                titleString = [fieldNames{fi}, ': ', num2str(ORIG.elev) ,' Elevation Sweep '];
                title(titleString, 'FontSize', 18);
                colorbar
                
                subplot(1,2,2);
                imagesc(im2, clim);
                colormap(cmap);
                axis off;
                titleString = [fieldNames{fi}, ': ', num2str(NEW.elev) ,' Aligned Elevation Sweep '];
                title(titleString, 'FontSize', 18);
                colorbar
                
                figure(2);
                colormap(hot(32));
                imagesc(diff);
                colorbar();
                title('Difference', 'FontSize', 18);
                fprintf('% s : Maximum difference is: %.4f\n', radar_file{1} , max(abs(diff(:))));
                fprintf('RMSE = %.4f\n', sqrt(nanmean(diff(:).^2)));
                
                pause;
            end
        end
        
    catch err
        msg = sprintf('%s : %s \n', radar_file{1}, err.message);
        fprintf(msg);
        fprintf(log, msg);
    end
end
fprintf('Test : testAlignSweepsToFixedImagery completed.  \n');
toc

%end


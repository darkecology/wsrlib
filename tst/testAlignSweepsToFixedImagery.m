function [ ] = testAlignSweepsToFixedImagery( dataSetName )
%testAlignSweepsToFixedImagery Interactive Unit Test to visualize results
%before and after aligning sweeps. 


tic
scans = getScans(dataSetName);      %get absolute paths of all scans in the dataset
log  = fopen('testAlignSweepsToFixedImageryLOG.txt','w+');  %test log file

if log == -1
    error('Could not create log file');
end

% parameters for the imagery
rmax = 37500;                           % no reason, we are most used to this! 
dim  = 500; 
figure;
pause(0.01);
jf = get(gcf,'JavaFrame');
set(jf,'Maximized',1);


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
        radar_aligned = alignSweepsToFixed(radar,false);
        
        % Note that the velocity sweeps are not dealiased
        
        fields = {'dz','vr'};
        numSweeps = {size(radar.dz.sweeps,1), size(radar.vr.sweeps,1)};
        fieldNames = {'Reflectivity' , 'Radial Velocity'};
        
        for fi=1:length(fields),
            
            field = fields{fi};
            numSweep = numSweeps{fi};
            
            for j=1:numSweep,
                ORIG = radar.(field).sweeps(j);
                [ORIG_az, ORIG_range] = get_az_range(ORIG);
                % Convert from slant range to ground range
                ORIG_ground_range = slant2ground(ORIG_range, ORIG.elev);

                % Now convert to cartesian
                im1 = mat2cart(ORIG.data, ORIG_az, ORIG_ground_range, dim, rmax);          % sweep image before alignment
                             
                NEW  = radar_aligned.(field).sweeps(j);
                [NEW_az, NEW_range] = get_az_range(NEW);
                % Convert from slant range to ground range
                NEW_ground_range = slant2ground(NEW_range, NEW.elev);

                % Now convert to cartesian
                im2 = mat2cart(NEW.data, NEW_az, NEW_ground_range, dim, rmax);              % sweep image after alignment
                
                subplot(1,2,1);
                imagesc(im1);
                axis off;
                titleString = [fieldNames{fi}, ': ', num2str(ORIG.elev) ,' Elevation Sweep '];
                title(titleString, 'FontSize', 18);
                colorbar
                
                subplot(1,2,2);
                imagesc(im2);
                axis off;
                titleString = [fieldNames{fi}, ': ', num2str(NEW.elev) ,' Aligned Elevation Sweep '];
                title(titleString, 'FontSize', 18);
                colorbar
                
                pause;
            end
        end
                      
        catch err       
        fprintf(log,'%s : %s \n', radar_file{1}, err.message);
    end
end
fprintf('Test : testAlignSweepsToFixedImagery completed.  \n');
toc

end


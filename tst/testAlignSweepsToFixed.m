function [ ] = testAlignSweepsToFixed( dataSetName )
%testAlignSweepsToFixed Unit Test for the alignSweepsToFixed function. 
tic 
scans = getScans(dataSetName);      %get absolute paths of all scans in the dataset
log  = fopen('testAlignSweepsToFixedLOG.txt','w+');  %test log file

if log == -1
    error('Could not create log file');
end

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
        radar_aligned = alignSweepsToFixed(radar,true);
        fprintf(log,'%s : Aligned.  \n', radar_file{1});
    catch err       
        fprintf(log,'%s : %s \n', radar_file{1}, err.message);
    end
end

fclose(log);
fprintf('Test: testAlignSweepsToFixed completed.  \n');
toc
end


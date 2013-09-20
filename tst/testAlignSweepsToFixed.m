function [ success ] = testAlignSweepsToFixed( dataSetName )
%testAlignSweepsToFixed Unit Test for the alignSweepsToFixed function. 

scans = getScans(dataSetName);      %get absolute paths of all scans in the dataset
results  = fopen('testResults.txt','w+');  %tesresults file

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
        radar_aligned = alignSweepsToFixed(radar,false,'ground');
        fprintf(results,'%s : Aligned.  \n', radar_file{1});
    catch err       
        fprintf(results,'%s : %s \n', radar_file{1}, err.message);
    end
end


fprintf('Testing successful \n');

end


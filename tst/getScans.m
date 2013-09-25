function [ scans ] = getScans( dataSetFolder )
%getScans Return absoulte paths of scan files given a top level dataSet
%name. Utility function for unit tests for a new feature. 

if ~exist(dataSetFolder, 'dir')
    error('Folder does not exist: %s', dataSetFolder);
end

scans = [];

stations = listSubFolders(dataSetFolder);          %get all the stations
for i=1:size(stations,1),
    stationFolder = cellstr(cell2mat([dataSetFolder,'/',stations(i)]));
    months = listSubFolders(stationFolder{1});   %get all the months
    for j=1:size(months,1),
        monthFolder = [stationFolder,'/',months(j),'/'];
        scanFilter = cellstr(cell2mat([monthFolder,'*.gz']));
        listOfScans = dir(scanFilter{1});
        for k = 1:size(listOfScans,1),
            scans = [scans;cellstr(cell2mat([monthFolder,listOfScans(k).name]))];
        end
    end
end
        


end


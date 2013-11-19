function [ dataSetLocation ] = generateDataSet( scanListFileLocation, dataSetName )

%GENERATEDATASET Given location of a file containing a list of scans, this
%functon will copy all required data files and the corresponding wind files
%and output the location of the new data set which can be directly ingested
%by the cajun code base. This will be very handy when we need to experiment
%with smaller subsets of data - You don't have to manually select the
%appropriate wind files, create labels file, create the required folder
%structure.
%Note that this function will not check for avaialable disk space, disk
%permissions, etc. Make sure these are as required before callig this
%function. 
%
%INPUT :  scanListFileLocation : The disk location of the file which contains the
%                                list of scans. (String)
%         dataSetName          : The name of this data set. This will be the name of
%                                the top level folder. (String)
%OUTPUT : datasetLocation      : The disk location of the corresponding data
%                                set. (String)


%specify all constants
TOP_LEVEL_DATA_LOCATION = '/mnt/nfs/work1/sheldon/birdcast/';
COMPLETE_DATA_LOCATION = '/mnt/nfs/work1/sheldon/birdcast/radar/data';
COMPLETE_WIND_LOCATION = '/mnt/nfs/work1/sheldon/birdcast/NARR/data';

%headers
metaFileHeader = 'scan_id,station,year,sunset_month,sunset_day,scan_month,scan_day,scan_time,filename,vcp,minutes_after_sunset\n';
labelsFileHeader = 'Scan ID,andrew,benjamin\n';

%Create all required folders and files
dataSetLocation = strcat(TOP_LEVEL_DATA_LOCATION,dataSetName);
mkdir(dataSetLocation);
mkdir(strcat(dataSetLocation, '/data'));
mkdir(strcat(dataSetLocation, '/NARR'));
labels  = fopen(strcat(dataSetLocation,'/data/labels.csv'),'wt');
fprintf(labels,labelsFileHeader);

%Read the list of scans
scanList = fopen(scanListFileLocation);
if scanList == -1,
    fprintf('Cannot open the scan list file location %s \n.',scanListFileLocation);
    rmdir(dataSetLocation,'s');
    exit(1);
else
    currentScan = fgetl(scanList);
    while ischar(currentScan),
        
        %Print informative message
        fprintf('Processing %s  ... \n',currentScan);
        
        %Obtain basic meta data about this scan
        currentScanStation = currentScan(1:4);
        currentScanYear = currentScan(5:8);
        currentScanMonth = currentScan(9:10);
        
        %check if the required folders and files exist
        currentScanTopLevelFolder = strcat(dataSetLocation,'/data/',currentScanStation);
        currentScanMonthLevelFolder = strcat(currentScanTopLevelFolder,'/',currentScanStation,'-',currentScanYear,'-',currentScanMonth);
        if (exist(currentScanMonthLevelFolder,'dir')~=7),
            if(exist(currentScanTopLevelFolder,'dir')~=7),
                mkdir(currentScanTopLevelFolder);
            end
            mkdir(currentScanMonthLevelFolder);
            metaFile = fopen(strcat(currentScanMonthLevelFolder,'/meta.csv'),'w');
            fprintf(metaFile,metaFileHeader);
            fclose(metaFile);
        end
        
        %Get the entries for this scan from data/labels.csv and data/$station/$station-$year-$month/meta.csv
        metaFileGrepCommand = ['grep ', currentScan,' ' ,COMPLETE_DATA_LOCATION,'/',currentScanStation,'/',currentScanStation,'-',currentScanYear,'-',currentScanMonth,'/meta.csv'];
        [~,currentScanMetaEntry] = system(metaFileGrepCommand);
        currentScanMetaEntrySplit = strsplit(currentScanMetaEntry,',');
        currentScanId = currentScanMetaEntrySplit{1};
        labelsFileGrepCommand = ['grep ', currentScanId, ' ', COMPLETE_DATA_LOCATION,'/labels.csv'];
        [~, currentScanLabelsEntry] = system(labelsFileGrepCommand);
        
        %Copy the actual data file to its location in the new data set, and
        %add entries in meta file and labels file. 
        fileSource = strcat(COMPLETE_DATA_LOCATION,'/',currentScanStation,'/',currentScanStation,'-',currentScanYear,'-',currentScanMonth,'/',currentScan,'.gz');
        fileDestination = strcat(dataSetLocation,'/data/', currentScanStation,'/',currentScanStation,'-',currentScanYear,'-',currentScanMonth);
        copyfile(fileSource,fileDestination);
        fprintf(labels,currentScanLabelsEntry);        
        currentScanMetaFile = fopen(strcat(fileDestination,'/meta.csv'),'a');
        fprintf(currentScanMetaFile, currentScanMetaEntry);
        fclose(currentScanMetaFile);
        
        %Copy the appropriate wind file for this scan
        currentScanWindFolder = [dataSetLocation,'/NARR/',currentScanYear];
        if (exist(currentScanWindFolder,'dir')~=7),
            mkdir(currentScanWindFolder);
        end
        
        %Read in the radar file
        radar_file = [currentScanMonthLevelFolder,'/',currentScan,'.gz'];
        
        try
            % Parse the filename to get the station
            scaninfo = wsr88d_scaninfo(radar_file);

            % Construct options for rsl2mat                                                                                                                                                                                                       
            opt = struct();
            opt.cartesian = false;
            opt.max_elev = 5;
        
            radar = rsl2mat(radar_file, scaninfo.station, opt);

        catch err
            fprintf('Error with reading this radar file : %s \n',currentScan);
            exit(1);
        end
        
        currentScanWindFile = get_wind_file(radar,COMPLETE_WIND_LOCATION);
        
        
        %Copy the wind file to the appropriate folder
        
        
        windFileSource = [COMPLETE_WIND_LOCATION,'/',currentScanYear,'/',currentScanWindFile];
        windFileDestination = [dataSetLocation,'/NARR/',currentScanYear];
        copyfile(windFileSource,windFileDestination);
        
        %Check if the wind file has additional associated files
        if (exist([windFileSource,'.gbx'],'file')==2),
            copyfile([windFileSource,'.gbx'],windFileDestination);
        end
                    
        %Proceed to next scan
        currentScan = fgetl(scanList);
    end
end
        
%Cleanup and finish
fclose(labels);
fprintf('Data set created at %s \n.',dataSetLocation);
  
end


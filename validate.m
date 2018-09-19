validation_scans = fileread('/Users/kwinner/Work/Data/cajun/validation_scan_list.txt');
validation_scans = splitlines(validation_scans);

radar_dir = '/Users/kwinner/Work/Data/cajun';
seg_net_path = '/Users/kwinner/Work/multielev-seg.mat';

for iscan = 1:numel(validation_scans)
% for iscan = 1:5
    scan_key = validation_scans{iscan};
    station = scan_key(1:4);
    year    = scan_key(5:8);
    month   = scan_key(9:10);
    day     = scan_key(11:12);
    
    scan_path = sprintf('%s/%s/%s/%s/%s', ...
                         year, ...
                            month, ...
                                 day, ...
                                      station, ...
                                         validation_scans{iscan});
    local_path = fullfile(radar_dir, scan_path);
    if exist(local_path, 'file') ~= 2
        aws_get_scan(scan_path, local_path);
    end
    
    result = cajun(local_path, station, 'seg_net_path', seg_net_path, 'diagnostics', true, 'rmax_m', 150000, 'fringe', uint32(3));
    cajun_report(result, fullfile(radar_dir, 'reports', validation_scans{iscan}));
end
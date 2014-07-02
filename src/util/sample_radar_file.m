function [ path, station ] = sample_radar_file( )
%SAMPLE_RADAR_FILE Return path to sample NARR file

station = 'KBGM';
path = [wsrlib_root() '/data/KBGM20100911_012056_V03.gz'];

end


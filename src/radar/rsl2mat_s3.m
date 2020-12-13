function radar = rsl2mat_s3(key, varargin)
%RSL2MAT_S3 Ingest a radar file directly from s3
%
% radar = rsl2mat_s3(key, station)
% radar = rsl2mat_s3(key, station, params)
%
% This is a wrapper around rsl2mat that reads a file from s3 instead of
% reading it from the local disk.
%
% Inputs:
%   key      AWS key. Can be abbreviated as long as it includes the file
%            name portion (e.g. 'KBGM20170421_025222')
%
%   station  The station ID (e.g. 'KBGM')
%
% Ouputs:
%   radar   The radar struct
%
%   params  Struct containing parameters for rsl2mat. See documentation for
%           rsl2mat
%
% See also: RSL2MAT


    [~, aws_path, name] = aws_key(key);

    % s3 directory listing to find full name of scan
    cmd = sprintf('aws s3 ls s3://noaa-nexrad-level2/%s/%s', aws_path, name);
    [status, result] = system(cmd);
    if status
      error('command failed (exit status=%d)\n %s\n %s', status, cmd, result);
    end

    fields = strsplit(result);
    fullkey = fields{4};

    local_file = tempname();

    % Copy the scan
    cmd = sprintf('aws s3 cp s3://noaa-nexrad-level2/%s/%s %s', aws_path, fullkey, local_file);
    [status, result] = system(cmd);
    if status
      error('command failed (exit status=%d)\n %s\n %s', status, cmd, result);
    end

    radar = rsl2mat(local_file, varargin{:});

    delete(local_file);


    % This version is a bit slicker, but doesn't work properly on the swarm2 cluster
    % possibly due to a bug in the Mathworks implementation
    % 
    % function radar = rsl2matReader(file)
    %     radar = rsl2mat(file, varargin{:});
    % end
    %
    % fullkey = aws_key(key);
    % location = sprintf('s3://noaa-nexrad-level2/%s', fullkey);
    % fds = fileDatastore(location, 'ReadFcn', @rsl2matReader);
    % 
    % radar = read(fds);
end

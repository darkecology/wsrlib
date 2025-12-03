function [local_file, info] = aws_get_scan(key, dataroot, background, verbose)
%AWS_GET_SCAN Download a scan from AWS
%
%  local_path = aws_get_scan( key, dataroot )
%
%  This function is intended to download multiple radar files locally
%  stored in the same directory structure as the s3 bucket. If you just
%  want to process remote radar files and not save them for repeated
%  analysis, see rsl2mat_s3.
%
%  Inputs:
%    key           Any prefix of the filename part of key, e.g.,
%                  KABX20170902_041920 or KABX20170902_041920_V06
%
%    dataroot      Scan will be stored within this root directory following
%                  the same directory structure as the s3 bucket, i.e., 
%                  <year>/<month>/<day>/<station>/<scan>
%
%    background    If true, intiate download and return immediately
%
%    verbose       Print status messages
%
%  Output:
%    local_path  Path to downloaded file
%
% See also: RSL2MAT_S3

if nargin < 2
    error('dataroot is required. Files are not deleted automatically');
end

if nargin < 3
    background = false;
end

if nargin < 4
    verbose = false;
end

[~, aws_path, name] = aws_key(key);

info = aws_parse(name);

% If the scan exists locally, return path to it.
% TODO: this can return a false positive 
f = dir(sprintf('%s/%s/%s*', dataroot, aws_path, name));
pattern = sprintf('^%s(_V\\d\\d)?(.gz)?$', name);
for i=1:length(f)
    if regexp(f(i).name, pattern)
        if verbose
            fprintf('Already have %s\n', key);
        end
        local_file = sprintf('%s/%s/%s', dataroot, aws_path, f(i).name);
        return;
    end
end

if verbose
    fprintf('Downloading %s... ', key);
end

% Why do we need this?
ld_bk = getenv('LD_LIBRARY_PATH');
setenv('LD_LIBRARY_PATH', '');

% s3 directory listing to find full name of scan
cmd = sprintf('aws s3 ls s3://unidata-nexrad-level2/%s/%s', aws_path, name);

[status, result] = system(cmd);
if status
    setenv('LD_LIBRARY_PATH', ld_bk);
    error('command failed (exit status=%d)\n %s\n %s', status, cmd, result);
end

fields = strsplit(result);
fullkey = fields{4};

local_file = sprintf('%s/%s/%s', dataroot, aws_path, fullkey);

% Copy the scan
cmd = sprintf('aws s3 cp s3://unidata-nexrad-level2/%s/%s %s',...
    aws_path, fullkey, local_file);

if background
    cmd = [cmd ' &'];
end

[status, result] = system(cmd);
if status
    setenv('LD_LIBRARY_PATH', ld_bk);
    error('command failed (exit status=%d)\n %s\n %s', status, cmd, result);
end

if verbose
    fprintf('success\n');
end

end

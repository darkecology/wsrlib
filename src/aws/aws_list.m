function [ fileinfo ] = aws_list( station, year, month, day, hour )
%AWS_LIST Get a list of archive files 
%
% [ files ] = aws_list( year, month, day, station )
%

s3path = sprintf('%04d/%02d/%02d/%04s', ...
    year, month, day, station );

% If hour is specified, append timestamp to narrow selection to selected
% hour
if nargin >= 5
    s3path = sprintf('%s/%04s%04d%02d%02d_%02d', ...
        s3path, station, year, month, day, hour);
end


cmd = sprintf('aws s3api list-objects --bucket noaa-nexrad-level2 --prefix %s --query ''Contents[].{Key: Key, Size: Size}'' --output json', s3path);

[status, result] = system( cmd );
if status
    error('Something went wrong...');
end

if strcmp(strtrim(result), 'null')
    fileinfo = [];
else
    filedata = loadjson( result );
    fileinfo  = cellfun ( @(c) aws_parse( c.Key ), filedata, 'UniformOutput', true );
end

end

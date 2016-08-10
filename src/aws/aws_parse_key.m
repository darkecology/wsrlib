function [ info ] = aws_parse_key( key )
%AWS_PARSE_KEY Parse the aws key (filename) to get

% Example: 2016/08/01/KBOX/KBOX20160801_000401_V06
[path, name, ext] = fileparts( key );

tokens = regexp(name, '(\w{4})(\d{4}\d{2}\d{2}_\d{2}\d{2}\d{2})_(\w+)?', 'tokens', 'once');

[station, timestamp, v] = tokens{:};

info.station = station;
info.t = datetime(timestamp, 'InputFormat', 'yyyyMMdd_HHmmss');
info.version = v;
info.path = path;
info.name = [name ext];
info.key = key;

end


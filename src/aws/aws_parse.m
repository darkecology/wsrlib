function s = aws_parse(key)
%AWS_PARSE Parse AWS key into constituent parts
%
%  s = aws_parse(key)
%  
%  Inputs:
%    key     the name part of a key, e.g., KBGM20170421_025222 or
%            KBGM20170421_025222_V06 or KBGM20170421_025222_V06.gz
%
%  Outputs:
%    s       a struct with fields: station, year, month, day, hour, minute,
%            second. 
%
%  Note: the suffix (e.g., '_V06' or '_V06.gz') is deduced from the portion
%  of the key that is given and may not be the actual file suffix. 

[~, name, ext] = fileparts(key);

C = textscan(name, '%4c%4d%2d%2d_%2d%2d%2d%s');
[station, year, month, day, hour, minute, second, suffix] = C{:};

s = struct();
s.name = key;
s.station = station;
s.year = year;
s.month = month;
s.day = day;
s.hour = hour;
s.minute = minute;
s.second = second;
s.suffix = [suffix{:} ext];

end


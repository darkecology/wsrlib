function s = aws_parse(key)
%AWS_PARSE Parse AWS key into constituent parts
%
%  s = aws_parse(key)
%  
%  Inputs:
%    key     the name part of a key, e.g., KBGM20170421_025222 or
%            KBGM20170421_025222_V06
%
%  Outputs:
%    s       a struct with fields: station, year, month, day, hour, minute,
%            second. The suffix (e.g., '_V06') is not contained in the
%            struct

[~, name] = fileparts(key);

C = textscan(name, '%4c%4d%2d%2d_%2d%2d%2d%s');
[station, year, month, day, hour, minute, second] = C{:};

s = struct();
s.name = key;
s.station = station;
s.year = year;
s.month = month;
s.day = day;
s.hour = hour;
s.minute = minute;
s.second = second;

end


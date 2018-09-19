function s = aws_parse(key)
%AWS_PARSE_KEY Parse AWS key into constituent parts

[~, name] = fileparts(key);

C = textscan(name, '%4c%4d%2d%2d_%2d%2d%2d%s');
[station, year, month, day, hour, minute, second] = C{:};

s = struct();
s.station = station;
s.year = year;
s.month = month;
s.day = day;
s.hour = hour;
s.minute = minute;
s.second = second;

end


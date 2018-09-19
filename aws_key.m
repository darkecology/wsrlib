function [key, path, name] = aws_key(s, suffix)
%AWS_KEY Get key from scaninfo struct
%
%  [key, path, name] = aws_key(s, suffix)
%

if nargin < 2
    suffix = '';
end

if ischar(s)
    s = aws_parse(s);
end

path = sprintf('%4d/%02d/%02d/%s', s.year, s.month, s.day, s.station);
name = sprintf('%s%04d%02d%02d_%02d%02d%02d', s.station, s.year, s.month, s.day, s.hour, s.minute, s.second);

key = sprintf('%s/%s%s', path, name, suffix);

end


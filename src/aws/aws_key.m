function [key, path, name] = aws_key(s, suffix)
%AWS_KEY Get key from scaninfo struct

%  [key, path, name] = aws_key(s, suffix)
%
%  Outputs:
%     key      the full key, e.g., 2017/04/21/KBGM/KBGM20170421_025222
%     path     the path, e.g., 2017/04/21/KBGM
%     name     the name, e.g., KBGM20170421_025222
%  
%  Inputs:
%     s        the short name, e.g., KBGM20170421_025222. This can also be a
%              struct returned by AWS_PARSE
%     suffix   Optionally append this to the returned name and key

if nargin < 2
    suffix = '';
end

if ischar(s)
    s = aws_parse(s);
    if nargin < 2
        suffix = s.suffix;
    end
end

path = sprintf('%4d/%02d/%02d/%s', s.year, s.month, s.day, s.station);
name = sprintf('%s%04d%02d%02d_%02d%02d%02d', s.station, s.year, s.month, s.day, s.hour, s.minute, s.second);

key = sprintf('%s/%s%s', path, name, suffix);

end


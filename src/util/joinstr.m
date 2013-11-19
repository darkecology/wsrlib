function [ s ] = joinstr( strings, d )
%JOINSTR Join strings with a delimiter
%
%  s = joinstr( strings, d )

first = strings{1};
rest  = sprintf([d '%s'], strings{2:end});
s = [first rest];

end


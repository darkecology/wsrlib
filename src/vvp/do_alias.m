function [ x ] = do_alias( x, vmax )
%ALIAS Alias a value to within interval [-vmax, vmax]
%
% x = aliax(x, vmax);

x = mod(x + vmax, 2*vmax) - vmax;

end


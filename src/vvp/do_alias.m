function [ x ] = do_alias( x, vmax )
%DO_ALIAS Alias a value to within interval [-vmax, vmax]
%
% x = aliax(x, vmax);

x = mod(x + vmax, 2*vmax) - vmax;

end


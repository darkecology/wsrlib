function bearing = pol2cmp( thet )
% POL2CMP Convert from mathematical angle to compass bearing
%
%   bearing = cmp2pol( thet )
%
% thet        Angle measured in radians counter-clockwise from positive
%              x-axis
% bearing     Angle measured in degrees clockwise from north
%
% See also CMP2POL

bearing = rad2deg(pi/2 - thet);
bearing = mod(bearing, 360);

end
function thet = cmp2pol( bearing )
% CMP2POL Convert from compass bearing to mathematical angle
%
%   thet = cmp2pol( bearing )
%
% bearing     Angle measured in degrees clockwise from north
% thet        Angle measured in radians counter-clockwise from positive
%              x-axis
%
% See also POL2CMP

thet = deg2rad(90 - bearing);
thet = mod(thet, 2*pi);

end
function [ pressure ] = height2pressure( height )
%HEIGHT2PRESSURE Convert from height to atmospheric pressure
%
%  pressure  = height2pressure( height )
%
% (Height units: m, pressure uints: mbar)
%  
% Formula from http://www.srh.noaa.gov/images/epz/wxcalc/pressureAltitude.pdf
%
% height = (1 - (pressure / 1013.25)^0.190284) * 44307.693960

% Solving for pressure in terms of height gives the formula below
pressure = 1013.25 * (1 - height/44307.693960).^(1/0.190284);

end


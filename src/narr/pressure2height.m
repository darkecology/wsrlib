function [ height ] = pressure2height( pressure )
%PRESSURE2HEIGHT Convert from atmospheric pressure to height
%
%  height = pressure2height( pressure )
%
% (Height units: m, pressure uints: mbar)
%  
% Formula from http://www.srh.noaa.gov/images/epz/wxcalc/pressureAltitude.pdf
%
% height = (1 - (pressure / 1013.25)^0.190284) * 44307.693960

height = (1 - (pressure / 1013.25).^0.190284) * 44307.693960;

end

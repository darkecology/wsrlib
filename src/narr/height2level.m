function [ k ] = height2level( height )
%HEIGHT2LEVEL Convert from height to mbar level for NARR data
%
%   k = height2level( height )
%
% Input:
%   height - matrix of heights (units: m above mean sea level)
%
% Output:
%   k - vertical index into NARR 3D array
% 

% Columns (index, mbar)
levels = [
      1  1000
      2   975
      3   950
      4   925
      5   900
      6   875
      7   850
      8   825
      9   800
     10   775
     11   750
     12   725
     13   700
     14   650
     15   600
     16   550
     17   500
     18   450
     19   400
     20   350
     21   300
     22   275
     23   250
     24   225
     25   200
     26   175
     27   150
     28   125
     29   100
     ];

% Formula from http://www.srh.noaa.gov/images/epz/wxcalc/pressureAltitude.pdf
%
% height = (1 - (pressure / 1013.25)^0.190284) * 44307.693960
%
%  height units = m
%  pressure units = mbar
%
% Solving for pressure in terms of height gives the formula below
%

pressure = 1013.25 * (1 - height/44307.693960).^5.255302;

% Reverse indices so pressure levels are inreasing
pressure_levels = levels(end:-1:1, 2);   
mid = pressure_levels(1:end-1) + diff(pressure_levels)/2;
edges = [-inf; mid; inf];
[~, k] = histc(pressure, edges);

% Reverse indices again (29 <--> 1)
k = 30 - k;              

end


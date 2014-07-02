function [ k ] = narr_height2level( height )
%NARR_HEIGHT2LEVEL Convert from height to pressure index for NARR data
%
%   k = narr_height2level( height )
%
% Input:
%   height - matrix of heights (units: m above mean sea level)
%
% Output:
%   k - vertical index into NARR 3D array
% 
% See also NARR_LEVEL2HEIGHT, HEIGHT2PRESSURE

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

% Get atmospheric pressure at user-supplied heights
pressure = height2pressure(height);

% Get NARR pressure levels: reverse indices so pressure levels are inreasing
pressure_levels = levels(end:-1:1, 2);   

% Get edges between two pressure levels
edges = pressure_levels(1:end-1) + diff(pressure_levels)/2;
edges = [-inf; edges; inf];

% Assign input pressure values into bins based on these edges
[~, k] = histc(pressure, edges);

% Reverse indices again (29 <--> 1)
k = 30 - k;              

end


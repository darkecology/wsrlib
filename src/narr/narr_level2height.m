function [ height ] = narr_level2height( k )
%NARR_LEVEL2HEIGHT Convert from pressure index to height for NARR data
%
%   height = narr_level2height( k )
%
% Input:
%   k - vertical index into NARR 3D array
%
% Output:
%   height - matrix of heights (units: m above mean sea level)
% 
% See also NARR_HEIGHT2LEVEL, PRESSURE2HEIGHT

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
 
height = pressure2height(levels(k,2));

end


function [ height ] = level2height( k )
%level2height Convert from mbar level to height for NARR data
%
%   height = level2height( k )
%
% Input:
%   k - vertical index into NARR 3D array
%
% Output:
%   height - matrix of heights (units: m above mean sea level)
% 

% Columns (index, mbar, start_height)
%
%  - Mapping from mbar to height taken from Kevin F. Webb
%
%  - TODO: extend mapping to higher elevations (not necessary for many
%           bird migration apps)
%
levels = [
      1  1000   -inf
      2   975    217
      3   950    431
      4   925    652
      5   900    876
      6   875   1104
      7   850   1337 
      8   825   1577
      9   800   1823
     10   775   2076
     11   750   2334
     12   725   2599
     13   700   2872
     14   650   3227
     15   600   inf
     16   550   inf
     17   500   inf
     18   450   inf
     19   400   inf
     20   350   inf
     21   300   inf
     22   275   inf
     23   250   inf
     24   225   inf
     25   200   inf
     26   175   inf
     27   150   inf
     28   125   inf
     29   100   inf 
     ];

 height = levels(k,3);

end


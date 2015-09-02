function set=nj_setcache(cacheDir, persistMinutes, scourEveryMinutes)
%NJ_SETCACHE - Enables caching for aggregating datasets
%
% Usage:
%   set=nj_setcache(cacheDir, persistMinutes, scourEveryMinutes);
% where,
%   cacheDir - The full path name to the directory of the cache. Must be writeable.
%   persistMinutes - how old a file should be before deleting.
%   scourEveryMinutes - how often to run the scour process. If <= 0, don't scour.
%
% e.g.,
%   Cache every hour and delete stuff older than 30 days. 
%   nj_setcache('/home/rsignell/nj_cache', 60*24*30, 60));
%   nj_setcache('c:\rps\nj_cache', 60*24*30, 60));
%
%
%Sachin Kumar Bhate (skbhate@ngi.msstate.edu) (c) 2008
%Mississippi State University.

import ucar.nc2.ncml.Aggregation;
import ucar.nc2.util.DiskCache2;

if nargin < 3 
    help nj_setcache
    return
end
% Create the Disk Cache objet
cache = DiskCache2(cacheDir, false, persistMinutes, scourEveryMinutes);
% Enable Aggregation caching
Aggregation.setPersistenceCache( cache );
%keep this object for furthur use.
set=cache;



 
    
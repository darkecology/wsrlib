from datetime import datetime
from calendar import timegm
from nexrad_inventory import get_scans, id2key

# Get scans from specific stations
rows = get_scans(stations=['KRTX', 'KBGM'], 
                start = datetime(2016,1,1,0,0,0),
                end   = datetime(2017,12,31,23,59,59))

print(len(rows))


# Get scans from all station
rows = get_scans(start = datetime(2017,4,1,0,0,0),
                 end   = datetime(2017,4,1,0,2,0))

print(rows[:10])

# Map id to AWS key
key = id2key('KHTX20170401_000004')
print(key)


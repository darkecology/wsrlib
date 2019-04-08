from datetime import datetime, timedelta
from collections import defaultdict

import boto3
import botocore
import re
import os.path
import errno    
import os
import sys

import numpy as np

from sunset_util import get_next_sunset_sunrise_time

####################################
# Helpers
####################################
def datetime_range(start=None, end=None, delta=timedelta(minutes=1), inclusive=False):
    """Construct a generator for a range of dates
    
    Args:
        from_date (datetime): start time
        to_date (datetime): end time
        delta (timedelta): time increment
        inclusive (bool): whether to include the 
    
    Returns:
        Generator object
    """
    t = start or datetime.now()
    
    if inclusive:
        keep_going = lambda s, e: s <= e
    else:
        keep_going = lambda s, e: s < e

    while keep_going(t, end):
        yield t
        t = t + delta
    return

def s3_key(t, station):
    """Construct (prefix of) s3 key for NEXRAD file
   
    Args:
        t (datetime): timestamp of file
        station (string): station identifier

    Returns:
        string: s3 key, excluding version string suffic
        
    Example format:
            s3 key: 2015/05/02/KMPX/KMPX20150502_021525_V06.gz
        return val: 2015/05/02/KMPX/KMPX20150502_021525
    """
    
    key = '%04d/%02d/%02d/%04s/%04s%04d%02d%02d_%02d%02d%02d' % (
        t.year, 
        t.month, 
        t.day, 
        station, 
        station,
        t.year,
        t.month,
        t.day,
        t.hour,
        t.minute,
        t.second
    )
    
    return key

def s3_prefix(t, station=None):
        
    prefix = '%04d/%02d/%02d' % (
        t.year, 
        t.month, 
        t.day
    )

    if not station is None:
        prefix = prefix + '/%04s/%04s' % ( station, station )
    
    return prefix
    

def parse_key( key ):
    path, key = os.path.split( key )
    vals = re.match('(\w{4})(\d{4}\d{2}\d{2}_\d{2}\d{2}\d{2})(\.?\w+)', key)
    (station, timestamp, suffix) = vals.groups()
    t = datetime.strptime(timestamp, '%Y%m%d_%H%M%S')
    return t, station    

def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc:  # Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else:
            raise

#start_time = datetime(2015, 5, 2,  0,  0,  0)
#end_time   = datetime(2015, 5, 2,  0, 29, 59)    
#stations = ['KLIX', 'KLCH', 'KLIX']

####################################
# AWS setup
####################################

# Get s3 Bucket resource
bucket = boto3.resource('s3', region_name='us-east-2').Bucket('noaa-nexrad-level2');
darkecology_bucket = boto3.resource('s3', region_name='us-east-2').Bucket('cajun-batch-test')
def get_scans(start_time, end_time, stations,
              select_by_time=False, time_increment=None, with_station=False,
              stride_in_minutes = 10, thresh_in_minutes = 20):
    #################
    # First get a list of all keys that are within the desired time period
    # and divide by station 
    #################

    all_keys = [];
    keys_by_station = { s: [] for s in stations }
    
    if not time_increment:
        time_increment = timedelta(days=1)
    
    for station in stations:
        for t in datetime_range( start_time, end_time, time_increment, inclusive=True ):
                    
            # Set filter
            prefix = s3_prefix(t, station)
            #print prefix
                    
            start_key = s3_key(start_time, station)
            end_key   = s3_key(  end_time, station)
            
            # Get s3 objects for this day
            objects = bucket.objects.filter(Prefix=prefix)
            
            # Select keys that fall between our start and end time
            keys = [o.key for o in objects
                    if  o.key >= start_key
                    and o.key <= end_key ]
            
            # Add to running lists
            all_keys.extend(keys)
            keys_by_station[station].extend(keys)

    #################
    # Now iterate by time and select the appropriate scan for each station
    #################

    time_thresh = timedelta( minutes = thresh_in_minutes )

    times = list( datetime_range( start_time, end_time, timedelta( minutes = stride_in_minutes) ) )

    current             = { s:  0    for s in stations }
    selected_by_time    = { t: set() for t in times }
    #selected_by_station = { s: set() for s in stations }
    selected_keys       = []
    
    for t in times:
        for station in stations:

            keys = keys_by_station[station]
            i = current[station]

            if keys:
                
                t_current, _ = parse_key(keys[i])

                while i + 1 < len( keys ) :
                    t_next, _ = parse_key(keys[i + 1])
                    if abs( t_current - t ) < abs( t_next - t ):
                        break 
                    t_current = t_next
                    i = i + 1

                current[station] = i

                k = keys[i]

                if abs( t_current - t ) <= time_thresh :
                    if select_by_time:
                        selected_by_time[t].add(k)
                    #selected_by_station[station].add(k)
                    if with_station:
                        selected_keys.append("%s;%s"%(k,station))
                    else:
                        selected_keys.append(k)
    return selected_keys if not select_by_time else selected_by_time


def get_overnight_scans(start_date, end_date, stations, 
                        start_offset = -timedelta(0), start_offset_from = 'sunset',
                        end_offset   =  timedelta(0), end_offset_from   = 'sunrise',
                        max_scan_frequency = timedelta.resolution,
                        with_station = False):
    #start_date, end_date should be datetime objects
    #
    #scans will begin at sunset on start_date and end at sunrise on end_date (or thereabouts)
    #  i.e. only "full" nights will be returned, and not the "half" night at the beginning or end of the range

    all_keys = [];
    #iterate over stations (necessary since sunrise/sunset time vary by station)
    for station in stations:
        #iterate over days in range (excluding the last date, since we will be considering the night beginning on each day and continuing into the next and so are naturally "inclusive")
        for day in datetime_range(start_date, end_date, timedelta(days=1), inclusive = False):
            sunset_today, sunrise_tomorrow = get_next_sunset_sunrise_time(station, day.date())

            # compute start and end times
            if  (start_offset_from == 'sunset'):
                start_time = sunset_today     + start_offset
            elif(start_offset_from == 'sunrise'):
                start_time = sunrise_tomorrow + start_offset
            else:
                start_time = sunset_today

            if  (end_offset_from == 'sunset'):
                end_time = sunset_today     + end_offset
            elif(end_offset_from == 'sunrise'):
                end_time = sunrise_tomorrow + end_offset
            else:
                end_time = sunrise_tomorrow

            # also construct a dummy start_key and end_key to simplify comparison with AWS keys
            start_key = s3_key(start_time, station)
            end_key   = s3_key(end_time,   station)

            # list all scans between start_time and end_time
            if start_time.day == end_time.day:
                # if both times are on the same day, then this is easier, but that's uncommon
                prefix = s3_prefix(start_time, station)
                keys   = [o.key for o in bucket.objects.filter(Prefix=prefix)]
            else:
                prefix_startday = s3_prefix(start_time, station)
                keys_startday   = [o.key for o in bucket.objects.filter(Prefix=prefix_startday)]

                prefix_endday   = s3_prefix(end_time, station)
                keys_endday     = [o.key for o in bucket.objects.filter(Prefix=prefix_endday)]

                # union the two sets of keys
                keys = list(set().union(keys_startday, keys_endday))

            # select keys between start_key and end_key
            keys = [key for key in keys if (key >= start_key and key <= end_key)]
            keys.sort()

            # if a scan frequency is specified, then subsample to that frequency
            if max_scan_frequency:
                filtered_keys = []
                for key in keys:
                    # parse the key (to get the timestamp)
                    t, _ = parse_key(key)

                    if filtered_keys == []:
                        # append if list empty
                        filtered_keys.append(key)
                        latest_time = t
                    else:
                        # otherwise compare with the time of the last key added to the list
                        # since the keys are sorted, this is also the last time
                        if abs(t - latest_time) >= max_scan_frequency:
                            # and add if they are sufficiently far apart
                            filtered_keys.append(key)
                            latest_time = t
                keys = filtered_keys

            # optionally append the station identifier to each key
            if with_station:
                keys = ["%s;%s"%(key, station) for key in keys]

            all_keys = all_keys + keys

    return(all_keys)




def download_scans(keys, data_dir):
    #################
    # Download files into hierarchy
    #################
    for key in keys: 
        # Download files
        local_file = '%s/%s' % (data_dir, key)
        local_path, filename = os.path.split( local_file )
        mkdir_p(local_path)  
    
        # Download file if we don't already have it
        if not os.path.isfile(local_file):
            bucket.download_file(key, local_file)

def download_cajun_out_profiles(scan_keys, out_dir):
    out_files = ['profile.csv', 'scan.csv']
    for scan in scan_keys:
        for out_file in out_files:
            key = '%s/%s'%(scan,out_file)
            
            #Download files
            url = 'dark_ecology/cajun/north_east_aug_dec_2010/%s'%key
            local_file = '%s/%s'%(out_dir,key)
            local_path, filename = os.path.split( local_file )
            #Check if file exists, if yes then download it
            try:
                #Make a HEAD request to quickly check if file exists. Ref - https://stackoverflow.com/a/33843019/1026535
                #If file doesn't exists this call will fail with 404
                darkecology_bucket.Object(url).load()
                #If we reach here, then file exists
                print("Downloading %s"%url)
                mkdir_p(local_path)      
                # Download file if we don't already have it
                if not os.path.isfile(local_file):
                    darkecology_bucket.download_file(url, local_file)
            except botocore.exceptions.ClientError:
                #Just move to the next file
                pass



def test():
    start_time = datetime(2016, 4, 15)
    end_time = datetime(2016, 5, 15)
    date_range = [(start_time, end_time)]
    import nexrad_util
    stations = nexrad_util.get_stations('all')
    s = get_scans_by_station_time(date_range, stations)
    return s

if __name__ == '__main__':
    keys = get_overnight_scans(datetime(2010, 9, 1), datetime(2010, 9, 30), ['KBGM', 'KDOX'],
                        start_offset = -timedelta(minutes=15),
                        end_offset   =  timedelta(hours=3), end_offset_from='sunset')

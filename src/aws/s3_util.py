from datetime import datetime, timedelta
from collections import defaultdict
from glob import glob

import boto3
import botocore
import re
import os.path
import errno    
import os
import sys
import shutil
import numpy as np


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

stride_in_minutes  = 10 # in minutes
thresh_in_minutes  = 20

####################################
# AWS setup
####################################

# Get s3 Bucket resource
bucket = boto3.resource('s3', region_name='us-east-2').Bucket('noaa-nexrad-level2');
darkecology_bucket = boto3.resource('s3', region_name='us-east-2').Bucket('darkeco-cajun')
def get_scans(start_time, end_time, stations, select_by_time=False, time_increment=None, with_station=True):
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

def download_cajun_out_profiles(scan_keys, out_dir, exp_tag):
    out_files = ['profile.csv', 'scan.csv']
    for scan in scan_keys:
        for out_file in out_files:
            key = '%s/%s'%(scan,out_file)
            
            #Download files
            url = '%s/%s'%(exp_tag,key)
            local_file = '%s/%s'%(out_dir,key)
            local_path, filename = os.path.split( local_file )
            #Check if file exists, if yes then download it
            try:
                #Make a HEAD request to quickly check if file exists. Ref - https://stackoverflow.com/a/33843019/1026535
                #If file doesn't exists this call will fail with 404
                darkecology_bucket.Object(url).load()
                #If we reach here, then file exists
                print "Downloading %s"%url
                mkdir_p(local_path)      
                # Download file if we don't already have it
                if not os.path.isfile(local_file):
                    darkecology_bucket.download_file(url, local_file)
            except botocore.exceptions.ClientError:
                #Just move to the next file
                pass

def copy_cajun_out_profiles(scan_keys, out_dir, exp_tag, src_dir):
    for scan in scan_keys:
        bname = os.path.basename(scan)
        dest_path = '%s/%s'%(out_dir,bname)
        src_path = scan
        print('Copying %s to %s'%(src_path, dest_path))
        shutil.copytree(src_path, dest_path)

def get_local_profiles(sunrise, sunset, current_date, station, src_dir):    
    res = []
    
    day1_profiles = profiles(current_date, station, src_dir, sunset, True)
    res.extend(day1_profiles)

    day2_profiles = profiles(current_date+timedelta(days=1), station, src_dir, sunrise, False)
    res.extend(day2_profiles)
    
    return res
    
def profiles(date, station, src_dir, time_limit=None, limit_after=True):
    date_str_ar = date.strftime("%Y-%m-%d").split("-")
    year = date_str_ar[0]
    month = date_str_ar[1]
    day = date_str_ar[2]
    
    src_path = '%s/%s/%s/%s/%s'%(src_dir, year, month, day, station)
    #print(src_path)
    profiles = glob('%s/*/'%src_path)
    profiles = [profile[:-1] for profile in profiles] #remove trailing slash
    
    #print(profiles)
    
    if time_limit:
        profiles = [profile for profile in profiles if key_in_time(profile, time_limit, limit_after)]
    
    #print(profiles, time_limit.strftime('%Y%m%d_%H%M%S'))
    
    return profiles

def key_in_time(key, time_limit, limit_after=True):
    #print(key)
    bname = os.path.basename(key)
    bname = bname[4:] #ignore station code
    
    key_time = datetime.strptime(bname[:15], '%Y%m%d_%H%M%S')
    
    return key_time >= time_limit if limit_after else key_time <= time_limit 
    
def yield_failed_scans(scan_keys, exp_tag):
    out_file = 'scan.csv'
    processed_scans = []
    for scan in scan_keys:
        key = '%s/%s'%(scan, out_file)
        url = 'dark_ecology/%s/%s'%(exp_tag,key)
        try:
            #Check if file exists, if yes then add to processed_scans
            #If file doesn't exists this call will fail with 404. Ref - https://stackoverflow.com/a/33843019/1026535
            darkecology_bucket.Object(url).load()
            #If we reach here, then file exists
            processed_scans.append(scan)
        except botocore.exceptions.ClientError:
            #A failed scan, yield right of computation
            yield scan
            
def test():
    start_time = datetime(2016, 04, 15)
    end_time = datetime(2016, 05, 15)
    date_range = [(start_time, end_time)]
    import nexrad_util
    stations = nexrad_util.get_stations('all')
    s = get_scans_by_station_time(date_range, stations)
    return s

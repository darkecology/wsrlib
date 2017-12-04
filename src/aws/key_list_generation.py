from collections import defaultdict
from datetime import timedelta
from datetime import datetime
import boto3
import numpy as np
import astral
import pytz
import warnings

from s3_util import datetime_range
from s3_util import s3_prefix
from s3_util import s3_key

bucket = boto3.resource('s3', region_name='us-east-2').Bucket('noaa-nexrad-level2');
darkecology_bucket = boto3.resource('s3', region_name='us-east-2').Bucket('cajun-batch-test')


def get_focused_scans_by_station_time(date_ranges, NEXRAD_LOCATIONS):

    keys = defaultdict(lambda: [list() for _ in range(len(date_ranges))])

    for station in NEXRAD_LOCATIONS:
        for d, date_range in enumerate(date_ranges):

            extended_start_time = date_range[0] - timedelta(days=2)
            extended_end_time = date_range[1] + timedelta(days=2)
            for t in datetime_range(extended_start_time,
                                    extended_end_time,
                                    timedelta(days=1),
                                    inclusive=True):
                # Set filter
                prefix = s3_prefix(t, station)

                start_key = s3_key(extended_start_time, station)
                end_key = s3_key(extended_end_time, station)

                # Get s3 objects for this day
                objects = bucket.objects.filter(Prefix=prefix)

                # Select keys that fall between our start and end time
                cur_keys = [o.key for o in objects if start_key <= o.key <= end_key]

                # Add to running lists
                keys[station][d].extend(cur_keys)

    selected_keys = defaultdict(lambda: [list() for _ in range(len(date_ranges))])

    a = astral.Astral()
    for station, station_keys in keys.items():

        for d, date_range_keys in enumerate(station_keys):

            # compile date times of all scans in this station/daterange combo
            key_datetimes = []
            for key in date_range_keys:
                filename = key.split('/')[-1]

                year = int(filename[4:8])
                month = int(filename[8:10])
                day = int(filename[10:12])
                hour = int(filename[13:15])
                minute = int(filename[15:17])
                second = int(filename[17:19])

                key_datetimes.append(datetime(year, month, day, hour, minute, second, tzinfo=pytz.UTC))

            # for every day in this date range, pick out the required scans
            # one during day
            # one during night (e.g. sunset the previous day to sunrise this day)
            # one at sunset +3 hours
            date_range = date_ranges[d]
            for day in datetime_range(date_range[0], date_range[1], timedelta(days=1), inclusive=True):

                yesterday_sunset_datetime = a.sunset_utc(day - timedelta(days=1), NEXRAD_LOCATIONS[station]['lat'], NEXRAD_LOCATIONS[station]['lon'])
                today_sunrise_datetime = a.sunrise_utc(day, NEXRAD_LOCATIONS[station]['lat'], NEXRAD_LOCATIONS[station]['lon'])
                today_sunset_datetime = a.sunset_utc(day, NEXRAD_LOCATIONS[station]['lat'], NEXRAD_LOCATIONS[station]['lon'])

                # night time scan
                indices_of_datetimes_during_night = [i for i, kd in enumerate(key_datetimes) if yesterday_sunset_datetime < kd < today_sunrise_datetime]
                nighttime_scan_index = np.random.choice(indices_of_datetimes_during_night)
                nighttime_scan = date_range_keys[nighttime_scan_index]
                selected_keys[station][d].append(nighttime_scan)

                # day time scan
                indices_of_datetimes_during_day = [i for i, kd in enumerate(key_datetimes) if today_sunrise_datetime < kd < today_sunset_datetime]
                daytime_scan_index = np.random.choice(indices_of_datetimes_during_day)
                daytime_scan = date_range_keys[daytime_scan_index]
                selected_keys[station][d].append(daytime_scan)

                # scan +3 hours after sunset
                target_datetime = today_sunset_datetime + timedelta(hours=3)  # want scans 3 hours after sunset
                closest_datetime = min(key_datetimes, key=lambda d: abs(d - target_datetime))
                if abs(target_datetime - closest_datetime) < timedelta(hours=1):

                    closest_key_ind = key_datetimes.index(closest_datetime)
                    closest_key = date_range_keys[closest_key_ind]
                    selected_keys[station][d].append(closest_key)

                else:  # skip scan
                    msg = 'Matched %s scan is more than an hour away! (%s)\n\tTarget: %s\n\tClosest: %s' \
                          % (station, abs(target_datetime - closest_datetime), target_datetime, closest_datetime)
                    warnings.warn(msg)

    return selected_keys

def get_random_scans_by_station_time(date_ranges, NEXRAD_LOCATIONS, time_increment=None, max_count=None):
    #################
    # First get a list of all keys that are within the desired time period
    # and divide by station
    #################

    keys_by_station_time = defaultdict(lambda: defaultdict(list))

    if not time_increment:
        time_increment = timedelta(days=1)

    for tup in date_ranges:
        start_time = tup[0]
        end_time = tup[1]

        for station in NEXRAD_LOCATIONS:
            print('Processing for station %s' % station)

            for t in datetime_range(start_time, end_time, time_increment, inclusive=True):

                # Set filter
                prefix = s3_prefix(t, station)

                start_key = s3_key(start_time, station)
                end_key = s3_key(end_time, station)

                # Get s3 objects for this day
                objects = bucket.objects.filter(Prefix=prefix)

                # Select keys that fall between our start and end time
                keys = [o.key for o in objects
                        if start_key <= o.key <= end_key]

                if len(keys) > 0:

                    if max_count is not None:
                        indices = np.arange(len(keys))
                        random_sample = sorted(np.random.choice(indices, min(max_count, len(indices)), replace=False))
                        keys = [keys[i] for i in random_sample]

                    keys_by_station_time[station][t].extend(keys)

    # convert back to regular dict so we can pickle
    for station in keys_by_station_time:
        keys_by_station_time[station] = dict(keys_by_station_time[station])
    keys_by_station_time = dict(keys_by_station_time)

    return keys_by_station_time
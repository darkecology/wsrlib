import os, sys
import getopt

import inventory.nexrad_inventory as ni
import nexrad_util
from datetime import timedelta, datetime

WINDOWS = ['night', 'day', 'sunrise', 'sunset', 'all']
SEASONS = ['spring', 'fall', 'migration', 'all']
GROUPS  = ['station', 'year', 'stationyear', 'none']

BATCH_PREFIX = ''
BATCH_EXTENSION = '.batch'

def get_usage_string(prog):
    usage_str = \
    "Usage:\n\
  %s -s <start_year> -e <end_year> -r <radar_region> [-b <batch_size> -f <frequency> -n <season> -w <time_window> -o <offset> -t <tag> -i <index> -g <group> -d <dir> --silent]\n\
  %s -h | --help\n" %(prog, prog)
    return usage_str            

def get_help_string(prog):
    help_string =  \
    "%s\
Options:\n\
  -h --help     Show this help\n\
  -s --start    Specify a scan start year (\"yyyy\")\n\
  -e --end      Specify a scan end year   (\"yyyy\")\n\
  -r --region   Specify a named region to process (see nexrad_util.py for region definitions)\n\
  -b --batch    Specify how many scans to put in each batch\n\
  -f --freq     The resolution of temporal downsampling in minutes (eg. -f 30 gets one scan every 30m)\n\
  -n --season   What season should be selected from each year, from %s\n\
  -w --window   What part of each day should be selected, from %s\n\
  -o --offset   The amount of time before/after sunset/sunrise to add to this batch (in minutes)\n\
  -t --tag      A tag (name) to add to all files in this batch\n\
  -i --index    The batch index to start from (typically 0 unless this is a subroutine)\n\
  -g --group    Groups scans into batches for portability, but may result in more underfull batches\n\
  -d --dir      Output directory for batch files\n\
  --silent      Suppresses console output"(get_usage_string(prog), SEASONS, WINDOWS)

    return help_string

def batch_name(station, year, tag, i_batch, group):
    name = BATCH_PREFIX
    if tag != '':
        name = name + tag + '_'
    if   group == 'station':
        name = name + '%s_%d'   % (station, i_batch)
    elif group == 'year':
        name = name + '%d_%d'   % (year, i_batch)
    elif group == 'stationyear':
        name = name + '%s%d_%d' % (station, year, i_batch)
    elif group == 'none':
        name = name + '%09d'    % (i_batch)

    return name

def get_scans(station, year, season, window, offset, freq):
    if   window == 'all':
        # getting all scans means we'll use get_scans instead of 
        # get_scans_overnight, which needs no offsets
        None
    elif window == 'night':
        start_offset_from = 'sunset'
        end_offset_from   = 'sunrise'
    elif window == 'day':
        start_offset_from = 'sunrise'
        end_offset_from   = 'sunset'
    elif window == 'sunrise':
        start_offset_from = 'sunrise'
        end_offset_from   = 'sunrise'
    elif window == 'sunset':
        start_offset_from = 'sunset'
        end_offset_from   = 'sunset'

    # compile the start/end dates for each year (possibly multiple)
    ranges = []
    if season == 'all':
        ranges.append([datetime(year=year, month=1, day=1), datetime(year=year, month=12, day=31)])
    if season == 'spring' or season == 'migration':
        ranges.append([datetime(year=year, month=3, day=1), datetime(year=year, month=6, day=15)])
    if season == 'fall'   or season == 'migration':
        ranges.append([datetime(year=year, month=8, day=1), datetime(year=year, month=11, day=15)])

    scans = []
    for range in ranges:
        if window == 'all':
            scans = scans + ni.get_scans([station], range[0], range[1], aligned_scan_frequency = freq, do_sort = True)
        elif window == 'night':
            scans = scans + ni.get_scans_overnight([station], range[0], range[1],
                                                   start_offset = -offset, start_offset_from = start_offset_from,
                                                   end_offset   = offset,  end_offset_from   = end_offset_from,
                                                   aligned_scan_frequency = freq)
        else:
            scans = scans + ni.get_scans_daytime([station], range[0], range[1],
                                                 start_offset=-offset, start_offset_from=start_offset_from,
                                                 end_offset=offset, end_offset_from=end_offset_from,
                                                 aligned_scan_frequency=freq)

    return scans

def write_batch(scans, dir, name):
    try:
        with open(os.path.join(dir, name + BATCH_EXTENSION), 'w') as outfile:
            outfile.write('\n'.join(scan[1] for scan in scans))
    except Exception as e:
        print(e)
        sys.exit(15)


def main(argv):
    prog = sys.argv[0]
    
    if len(argv) == 0:
        print("ERROR: No Arguments given")
        print(get_usage_string(prog))
        sys.exit(1)

    # default arguments
    opts       = {}
    start_time = ""
    end_time   = ""
    region     = ""
    stations   = []
    batch_size = 100
    freq       = 30
    season     = "migration"
    window     = "night"
    offset     = 0
    i_batch    = 0
    tag        = ""
    group      = "stationyear"
    silent     = False
    output_dir = "batchfiles"

    try:
        opts,args = getopt.getopt(argv, "hs:e:r:b:f:n:w:o:t:i:g:d:", ["help", "start=", "end=", "region=", "batch=", "freq=", "season=", "window=", "offset=", "tag=", "index=", "dir=", "silent"])
    except getopt.GetoptError:
        print("ERROR: Invalid Arguments")
        print(get_usage_string(prog))
        sys.exit(2)

    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print(get_help_string(prog))
            sys.exit(0)
        elif opt in ("-s", "--start"):
            start_year =  arg
        elif opt in ("-e", "--end"):
            end_year = arg
        elif opt in ("-r", "--region"):
            region = arg
        elif opt in ("-b", "--batch"):
            batch_size = arg
        elif opt in ("-f", "--freq"):
            freq = arg
        elif opt in ("-n", "--season"):
            season = arg
        elif opt in ("-w", "--window"):
            window = arg
        elif opt in ("-o", "--offset"):
            offset = arg
        elif opt in ("-t", "--tag"):
            tag = arg
        elif opt in ("-i", "--index"):
            i_batch = arg
        elif opt in ("-g", "--group"):
            group = arg
        elif opt in ("-d", "--dir"):
            output_dir = arg
        elif opt in ("--silent"):
            silent = True

    if start_year == "" or end_year == "" or region == "":
        print("ERROR: start time, end time and region are required")
        print(get_usage_string(prog))
        sys.exit(3)

    try:
        start_year = int(start_year)
    except ValueError:
        print("ERROR: Invalid format for start year, must be an integer.")
        sys.exit(4)

    try:
        end_year = int(end_year)
    except ValueError:
        print("ERROR: Invalid format for end year, must be an integer.")
        sys.exit(5)
    
    try:
        stations = nexrad_util.get_stations(region)
        print(stations)
    except ValueError:
        print("ERROR: Invalid region name. See nexrad_util.py for valid region names.")
        sys.exit(6)

    try:
        batch_size = int(batch_size)
        if batch_size <= 0:
            raise Exception()
    except Exception:
        print("ERROR: Batch size must be a strictly positive integer.")
        sys.exit(7)

    try:
        freq = int(freq)
        if freq <= 0:
            raise Exception()
        freq = timedelta(minutes=freq)
    except Exception:
        print("ERROR: frequency must be a strictly positive integer.")
        sys.exit(8)

    if season not in SEASONS:
        print("ERROR: Invalid season name. Valid names are %s" % SEASONS)
        sys.exit(9)

    if window not in WINDOWS:
        print("ERROR: Invalid window name. Valid names are %s" % WINDOWS)
        sys.exit(10)

    try:
        offset = int(offset)
        if offset < 0:
            raise Exception()
        offset = timedelta(minutes=offset)
    except Exception:
        print("ERROR: offset must be a nonnegative integer.")
        sys.exit(11)

    try:
        i_batch = int(i_batch)
        if i_batch < 0:
            raise Exception()
    except Exception:
        print("ERROR: index must be a nonnegative integer.")
        sys.exit(12)

    if group not in GROUPS:
        print("ERROR: Invalid group pattern. Valid patterns are %s" % GROUPS)
        sys.exit(13)

    if group is not "none" and i_batch > 0:
        print("WARNING: nonzero index is only meaningful if group is 'none'")
        i_batch = 0

    # breaking the code at this point after command line parameters have been processed
    # so that other scripts can build batchfiles
    build_batches(start_year, end_year, region, i_batch, batch_size,
                  freq, season, window, offset, group, tag, output_dir, silent)


def build_batches(start_year, end_year, region, i_batch, batch_size,
                  freq, season, window, offset, group, tag, output_dir, silent):
    if os.path.isfile(output_dir):
        print("ERROR: output directory already exists, is not a directory")
        sys.exit(14)
    elif not os.path.isdir(output_dir):
        try:
            os.makedirs(output_dir)
        except Exception:
            print("WARNING: output directory already exists or cannot be created")

    stations = nexrad_util.get_stations(region)

    # write this batch definition
    if tag:
        with open(os.path.join(output_dir, '_' + tag + '.def'), 'w') as batch_def_file:
            batch_def_file.write('start:      %d\n' % start_year)
            batch_def_file.write('end:        %d\n' % end_year)
            batch_def_file.write('region:     %s\n' % region)
            batch_def_file.write('batch_size: %d\n' % batch_size)
            batch_def_file.write('freq:       %d\n' % (freq.total_seconds() / 60))
            batch_def_file.write('season:     %s\n' % season)
            batch_def_file.write('window:     %s\n' % window)
            batch_def_file.write('offset:     %d\n' % (offset.total_seconds() / 60))
            batch_def_file.write('group:      %s'   % group)

    # build batches
    # for organization purposes, I've added a batch grouping scheme
    # where all scans from one station/year/both are grouped together
    # if grouping by stations only, then the order of iteration switches
    n_years    = end_year - start_year + 1
    n_stations = len(stations)
    n_stationyears = n_years * n_stations

    scan_buffer = []
    if group != 'station':
        for year in range(start_year, end_year+1):
            i_year = year - start_year
            if not silent:
                print('%d year #%d/%d' % (year, i_year + 1, n_years))
            for station in stations:
                i_station = stations.index(station)
                if not silent:
                    print('   %s station #%d/%d (%d%%)' % (station, i_station + 1, n_stations, 100 * (i_year * n_stations + i_station) / n_stationyears))

                # get scans and add them to the scan_buffer
                scan_buffer = scan_buffer + get_scans(station, year, season, window, offset, freq)

                while len(scan_buffer) > batch_size:
                    # flush the buffer
                    write_batch(scan_buffer[0:batch_size], output_dir, batch_name(station, year, tag, i_batch, group))
                    scan_buffer = scan_buffer[batch_size:]
                    i_batch = i_batch + 1

                if group == "stationyear":
                    # flush the buffer, reset the index
                    while len(scan_buffer) > 0:
                        # flush the buffer
                        write_batch(scan_buffer[0:batch_size], output_dir,
                                    batch_name(station, year, tag, i_batch, group))
                        scan_buffer = scan_buffer[batch_size:]
                        i_batch = i_batch + 1
                    i_batch = 0

            if group == "year":
                # flush the buffer, reset the index
                while len(scan_buffer) > 0:
                    # flush the buffer
                    write_batch(scan_buffer[0:batch_size], output_dir,
                                batch_name(station, year, tag, i_batch, group))
                    scan_buffer = scan_buffer[batch_size:]
                    i_batch = i_batch + 1
                i_batch = 0
    elif group == 'station':
        None


if __name__ == "__main__":
    main(sys.argv[1:])

# start_time = date(1996, 1, 1)
# end_time = today()
# aligned_scan_frequency = timedelta(minutes=30)

# for station in NEXRAD_LOCATIONS:
# 	scans = ni.get_scans(station, start_time)

# 	t = datetime_range(start_time, end_time, aligned_scan_frequency, inclusive=True)

#     scan_times = [scan[2] for scan in scans]

#     subsampled_scans = [None] * len(t)
#     time_diffs       = [None] * len(t)

#     min_scan_times = 0
#     for i_t in range(len(t)):
#         for i_scan_times in range(min_scan_times, len(scan_times)):
#             time_diff = scan_times[i_scan_times] - t[i_t]

#             # if we found a closer scan, then record it, but stop it from being matched to another i_t
#             if (subsampled_scans[i_t] is None) or (time_diff < time_diffs[i_t]):
#                 subsampled_scans[i_t] = scans[i_scan_times]
#                 time_diffs[i_t]       = time_diff
                
#                 min_scan_times = i_scan_times + 1

#             # regardless, if time_diff is positive then we've found the first scan after t
#             # and so there is no point in continuing to search
#             if time_diff > timedelta(0):
#                 break

#     n_scans = n_scans + len(subsampled_scans)
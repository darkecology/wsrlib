import boto3
import os
import sys
import re
import gspread
from oauth2client.service_account import ServiceAccountCredentials
import csv

bucket = boto3.resource('s3', region_name='us-east-1').Bucket('cajun-batch-test');
stat_files = bucket.objects.filter(Prefix="dark_ecology/cajun/north_east_aug_dec_2010/stats_")

stats_dir = "stats"
JSON_KEYFILE     = "CajunissueBot-2d3372661941.json"
SPREADSHEET_NAME = "Cajun Issues - NorthEast Aug-Dec 2010"
NEW_WORKSHEET    = "Stats"
CSV_FILE = "stats.csv"

def init_gspread():
    scope = ['https://spreadsheets.google.com/feeds']
    credentials = ServiceAccountCredentials.from_json_keyfile_name(JSON_KEYFILE, scope)
    gc = gspread.authorize(credentials)
    return gc, credentials

def get_worksheet(gc):
    wks = gc.open(SPREADSHEET_NAME)
    wks = wks.add_worksheet(title=NEW_WORKSHEET, rows="5000", cols="20")
    
    return wks
    

'''
for obj in stat_files:
    _, filename = os.path.split(obj.key)
    local_file = "%s/%s"%(stats_dir, filename)
    bucket.download_file(obj.key, local_file)
'''

#gc, cred = init_gspread()
#wks = get_worksheet(gc)
    
sum_script_time = 0.0
sum_total_runtime = 0.0


csv_file = open(CSV_FILE, 'w')
writer = csv.writer(csv_file, quoting=csv.QUOTE_MINIMAL)    

ct = 1
'''wks.update_cell(ct, 1, "Batch Number")
wks.update_cell(ct, 2, "Script Time")
wks.update_cell(ct, 3, "Total Runtime")
wks.update_cell(ct, 4, "Job submitted at")
wks.update_cell(ct, 5, "Job started at")
wks.update_cell(ct, 6, "Job completed at")
wks.update_cell(ct, 7, "Scans")'''
writer.writerow([ "Batch Number", "Script Time", "Total Runtime", "Job submitted at", "Job started at", "Job completed at", "Scans" ])

ct+= 1
    
for i in range(1, len(sys.argv)):
    filename = sys.argv[i]
    print "Reading %s" %(filename)
    
    lines = []
    with open(filename, "r") as f:
        lines = f.readlines()
    
    batch_num_pattern = r"stats/stats_(\d+).txt"
    mch = re.match(batch_num_pattern, filename)
    batch_num = int(mch.group(1))
    print "Processing Batch %d"%batch_num
    #wks.update_cell(ct, 1, batch_num)
    
    scans_pattern = r"^Scans - (.+)$"
    mch = re.match(scans_pattern, lines[1])
    scans = mch.group(1)
    print "Scans %s"%scans
    #wks.update_cell(ct, 7, scans)
    
    script_time_pattern = r"^Script Time - (.+) ms$"
    mch = re.match(script_time_pattern, lines[2])
    script_time = float(mch.group(1))
    print "Script Time %s ms"%script_time
    sum_script_time += script_time
    #wks.update_cell(ct, 2, script_time)
            
    total_runtime_pattern = r"^Total Runtime - (.+) ms$"
    mch = re.match(total_runtime_pattern, lines[3])
    total_runtime = float(mch.group(1))
    print "Total Runtime %s ms"%total_runtime
    sum_total_runtime += total_runtime
    #wks.update_cell(ct, 3, total_runtime)
    
    job_submitted_at_pattern = r"^Job submitted at - (.+)$"
    mch = re.match(job_submitted_at_pattern, lines[4])
    job_submitted_at = mch.group(1)
    print "Job submitted at %s"%job_submitted_at
    #wks.update_cell(ct, 4, job_submitted_at)
    
    job_started_at_pattern = r"^Job started at - (.+)$"
    mch = re.match(job_started_at_pattern, lines[5])
    job_started_at = mch.group(1)
    print "Job started at %s"%job_started_at
    #wks.update_cell(ct, 5, job_started_at)
    
    job_completed_at_pattern = r"^Job completed at - (.+)$"
    mch = re.match(job_completed_at_pattern, lines[6])
    job_completed_at = mch.group(1)
    print "Job completed at %s"%job_completed_at
    #wks.update_cell(ct, 6, job_completed_at)
    
    writer.writerow([batch_num, script_time, total_runtime, job_submitted_at, job_started_at, job_completed_at, scans])
    
    ct += 1
    
    '''if ct%800 == 0:
        gc.login()
        wks = gc.open(SPREADSHEET_NAME)
        wks = wks.worksheet(NEW_WORKSHEET)
    '''
ct += 1

num_batches = len(sys.argv) - 1
proc_string = "Processed %d batches" %num_batches
print proc_string
#wks.update_cell(ct, 1, proc_string)
writer.writerow([proc_string])
ct += 1

avg_script_time = sum_script_time/num_batches
avg_total_runtime = sum_total_runtime/num_batches

avg_st_string = "Avg Script Time %d ms"%avg_script_time
print avg_st_string
#wks.update_cell(ct, 2, avg_st_string)
writer.writerow([avg_st_string])
ct += 1

avg_trt_string = "Avg Total Runtime %d ms"%avg_total_runtime
print avg_trt_string
writer.writerow([avg_trt_string])
#wks.update_cell(ct, 1, avg_trt_string)    

csv_file.close()

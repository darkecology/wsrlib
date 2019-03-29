import os
import sys
import getopt
# import s3_util #export PYTHONPATH=$PYTHONPATH:../lib/
# import nexrad_util
# import aws_util
from datetime import datetime, timedelta
# import pickle
# import time # for measuring runtime of job submission
import boto3

JOB_REGION = 'us-east-2'
JOB_PREFIX = 'cajun_batch_job'
JOB_QUEUE  = 'cajun_batch_spot'
JOB_DEFN   = 'cajun_batch_jd'

def submit_batch(scans, name, result_dir):
    boto3.setup_default_session(region_name = JOB_REGION)
    client = boto3.client('batch')

    #Get submit time (milliseconds upto 3 precision)
    submit_time = datetime.strftime(datetime.utcnow(), '%Y-%m-%d_%H:%M:%S:%f')[:-3]
    command =  [",".join(scans), result_dir, name, 'kyjun/multielev.mat', '/kyjun/clutter_masks', 'diagnostics', 'false', 'stats', 'true', 'submit_time', submit_time]

    job_desc = {
        'jobName' : '%s_%s' % (JOB_PREFIX, name),
        'jobQueue' : JOB_QUEUE,
        'jobDefinition' : JOB_DEFN,
        'containerOverrides' : {
            'command' : command
        }
    }

    print(job_desc['containerOverrides']['command'])
    response = client.submit_job(**job_desc)
    job_id = response['jobId']
    print('Submitted Job %s at %s' %(job_id, submit_time))

    return job_id


def get_usage_string(prog):
    usage_str = \
    "Usage:\n\
  %s batchfile [-d <s3_dir>]\n\
  %s -h | --help\n" %(prog, prog)
    return usage_str            


def get_help_string(prog):
    help_string =  \
    "%s\n\
batchfile (may be a single file or directory of batchfiles)\n\
Options:\n\
  -h --help     Show this help\n\
  -d --dir      Specify an s3 directory for the results of these jobs.\n"%(get_usage_string(prog))
    return help_string


def main(argv):
    prog = sys.argv[0]
    
    if len(argv) < 1:
        print("ERROR: Not enough arguments given")
        print(get_usage_string(prog))
        sys.exit(1)

    opts = {}
    result_dir = 'default'
    batchpath = argv[0]
    
    try:
        opts,args = getopt.getopt(argv[1:], "h:d:", ["help", "dir="])
    except getopt.GetoptError:
        print("ERROR: Invalid Arguments")
        print(get_usage_string(prog))
        sys.exit(2)    

    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print(get_help_string(prog))
            sys.exit(0)
        elif opt in ("-d", "--dir"):
            result_dir = arg
        
    if not (os.path.isfile(batchpath) or os.path.isdir(batchpath)):
        print("ERROR: The path %s does not exist."%batchpath)
        sys.exit(3)

    batches = []
    job_ids = {}
    if os.path.isfile(batchpath):
        batches = [batchpath]
    else:
        batches = [os.path.join(batchpath, file) for file in os.listdir(batchpath) if file.endswith('.batch')]

    for batch in batches:
        with open(batch, 'r') as batchfile:
            scans = [line.strip() for line in batchfile.readlines()]

            job_id = submit_batch(scans, os.path.splitext(os.path.basename(batch))[0], result_dir)
            job_ids[job_id] = batch

    if os.path.isfile(batchpath):
        jobids_path = os.path.splitext(batchpath) + '.ids'
    else:
        jobids_path = os.path.join(batchpath, 'jobs.ids')

    with open(jobids_path, 'w') as jobids_file:
        jobids_file.write('\n'.join('%s: %s' % (job_id, job_ids[job_id]) for job_id in job_ids))

    print('Done. Submitted %d jobs. Details in %s' % (len(job_ids), jobids_path))
               
if __name__ == "__main__":
    main(sys.argv[1:])

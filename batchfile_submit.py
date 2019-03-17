import os
import sys
import getopt
import s3_util #export PYTHONPATH=$PYTHONPATH:../lib/
import nexrad_util
import aws_util
from datetime import datetime, timedelta
import pickle
import time # for measuring runtime of job submission
import boto3

def submit_batches(batches, exp_tag, name, batch_num=None):
    batch_id = batch_num if batch_num else 1
    boto3.setup_default_session(region_name='us-east-2')
    client = boto3.client('batch')
    job_id_command_list = []
        
    for batch in  batches:
        #Get submit time (milliseconds upto 3 precision)
        submit_time = datetime.strftime(datetime.utcnow(), '%Y-%m-%d_%H:%M:%S:%f')[:-3]
        command =  [",".join(batch), exp_tag, str(batch_id), 'kyjun/multielev.mat', '/kyjun/clutter_masks', 'diagnostics', 'false', 'stats', 'true', 'submit_time', submit_time]
	#command =  [",".join(batch), exp_tag, str(batch_id), '', '/kyjun/clutter_masks', 'diagnostics', 'false', 'stats', 'true', 'submit_time', submit_time]

        exp_tag_un = exp_tag.replace('/','_')
        job_desc = {
            'jobName' : 'kyjun_batch_job_%s_%s'%(name,batch_id),
            'jobQueue' : 'cajun_batch',
            'jobDefinition' : 'cajun_batch_jd:8',
            'containerOverrides' : {
                'command' : command
            }
        }
        #print('batch_num is %s'%batch_num)
        batch_id  = batch_id + 1
        #print('batch_id is %s'%batch_id)
        print(job_desc['containerOverrides']['command'])
        response = client.submit_job(**job_desc)
        job_id = response['jobId']
        print('Submitted Job %s at %s' %(job_id, submit_time))
        #job_ids.append(job_id)
        job_id_command_list.append((job_id, command))
       
    return job_id_command_list



def get_usage_string(prog):
    usage_str = \
    "Usage:\n\
  %s batchfile [-b <batch_size> -t <tag> -n <name>]\n\
  %s -h | --help\n" %(prog, prog)
    return usage_str            

def get_help_string(prog):
    help_string =  \
    "%s\
Options:\n\
  -h --help     Show this help\n\
  -b --batch    Specify how many scans to put in each batch\n\
  -t --tag      Specify a tag for this experiment (default value is \"default\").\n\
  -n --name     Specify a name for this AWS job (default=tag).\n"%(get_usage_string(prog))
    return help_string

def batch_split(scans, batch_size=100):
    batches = []
    num_scans = len(scans)
    count = 0
    
    while count + batch_size < num_scans :
        batch = scans[count:count+batch_size]
        batches.append(batch)
        count += batch_size
    batch = scans[count:]
    batches.append(batch)
    
    return batches    
               
def main(argv):
    prog = sys.argv[0]
    
    if len(argv) < 1:
        print("ERROR: Not enough arguments given")
        print(get_usage_string(prog))
        sys.exit(1)

    opts = {}
    batch_size = 100
    exp_tag = "default"
    name = ""
    batchfile = argv[0]
    
    try:
        opts,args = getopt.getopt(argv[1:], "h:b:t:n:", ["help", "batch=", "tag=", "name="])
    except getopt.GetoptError:
        print("ERROR: Invalid Arguments")
        print(get_usage_string(prog))
        sys.exit(2)    

    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print(get_help_string(prog))
            sys.exit(0)
        elif opt in ("-b", "--batch"):
            batch_size = arg
        elif opt in ("-t", "--tag"):
            exp_tag = arg
        elif opt in ("-n", "--name"):
            name = arg

    if not name:
        name = exp_tag

    try:
        #print "seg is %s"%seg
        batch_size = int(batch_size)
        if batch_size <= 0:
            raise Exception()
    except Exception:
        print("ERROR: Batch size must be a strictly positive integer value.")
        #print get_usage_string(prog)                            
        sys.exit(3)
        
    if not os.path.isfile(batchfile):
        print("ERROR: The path %s does not exist or is not a directory"%batchfile)
        sys.exit(7)

    scans = []
    with open(batchfile) as batchfile:
        scans = [line.strip() for line in batchfile.readlines()]

    #s3_util.download_scans(scans, scan_dir)
    batches = batch_split(scans, batch_size=batch_size)
    #print batches
    job_id_command_list = submit_batches(batches, exp_tag, name)
    
    name_un = name.replace('/','_')
    fname = '%s.pkl'%(name_un)
    if os.path.isfile(fname):
        with open(fname, 'rb') as f:
            lst = pickle.load(f)
            job_id_command_list.extend(lst)
    with open(fname, 'wb') as f:
        pickle.dump(job_id_command_list, f)
            
    print('Done. Saved job details to %s'%(fname))
               
if __name__ == "__main__":
    main(sys.argv[1:])

import boto3
import pickle
import os

exp_tag = 'kyle'
job_id_file = '%s.pkl'%exp_tag

job_id_command_list = []
with open(job_id_file, 'rb') as f:
    job_id_command_list = pickle.load(f)

boto3.setup_default_session(region_name='us-east-2')
client = boto3.client('batch')

job_id_status_list = []
for i in range(0, len(job_id_command_list), 100):
    job_ids = [x[0] for x in job_id_command_list[i:i+100]]
    res = client.describe_jobs(jobs=job_ids)
    res_jobs = res['jobs']
    for i in range(len(job_ids)):
        job_id = job_ids[i]
        if i < len(res_jobs):
            job_res = res_jobs[i]
            job_status = job_res['status']
            job_status_reason = job_res['statusReason'] if 'statusReason' in job_res else ""
            job_id_status_list.append((job_id, job_status, job_status_reason))

status_file = '%s_status.pkl'%exp_tag

if os.path.isfile(status_file):
    with open(status_file, 'rb') as f:
        lst = pickle.load(f)
        job_id_status_list.extend(lst)

with open(status_file, 'wb') as f:
    pickle.dump(job_id_status_list, f)

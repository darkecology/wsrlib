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

for entry in job_id_command_list:
    job_id =entry[0]
    res = client.cancel_job(jobId=job_id, reason="No Reason")
    print(res)

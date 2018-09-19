import boto3
from datetime import datetime

#Submit a batch of jobs to AWS
#exp_tag is the experiment tag i.e. destination path in the output bucket
#batch_num is an ID used to give a unique name to each job
#seg is the segmenation type (0 - no segmenation, 1 single_elevation, 2 - multi elevation
def submit_cajun_batches(batches, exp_tag, batch_num=None, seg=0,):
    batch_id = batch_num if batch_num else 1
    boto3.setup_default_session(region_name='us-east-2')
    client = boto3.client('batch')
    job_id_command_list = []
    
    seg_arg_list = ''
    if seg == 1:
        seg_arg_list = ['seg_net_path', 'cajun/fcn8s_imagenet.mat']
    elif seg == 2:
        seg_arg_list = ['seg_net_path', 'cajun/multielevtest.mat']
    
    for batch in  batches:
        #Get submit time (milliseconds upto 3 precision)
        submit_time = datetime.strftime(datetime.utcnow(), '%Y-%m-%d_%H:%M:%S:%f')[:-3]
        command =  [",".join(batch), exp_tag, str(batch_id), 'diagnostics', 'true', 'stats', 'true', 'submit_time', submit_time]
        command.extend(seg_arg_list)
        
        exp_tag_un = exp_tag.replace('/','_')
        job_desc = {
            'jobName' : 'cajun_batch_job_%s_%s'%(exp_tag_un,batch_id),
            'jobQueue' : 'cajun_batch',
            'jobDefinition' : 'cajun_batch_jd:4',
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

def submit_mosaic_batches(batches, exp_tag):
    batch_id = 1
    client = boto3.client('batch')
    job_ids = []
    
    for time in  batches.keys():
        #Get submit time (milliseconds upto 3 precision)
        submit_time = datetime.strftime(datetime.utcnow(), '%Y-%m-%d_%H:%M:%S:%f')[:-3]
        
        job_desc = {
            'jobName' : 'mosaic_batch_job',
            'jobQueue' : 'mosaic_batch_queue',
            'jobDefinition' : 'mosaic_batch_r2016a:3',
            'containerOverrides' : {
                'command' : [ ",".join(batches[time]), time, exp_tag, submit_time, str(batch_id) ]
            }
        }
        batch_id += 1
        print(job_desc['containerOverrides']['command'])
        response = client.submit_job(**job_desc)
        print('Submitted Job %s at %s' %(response['jobId'], submit_time))
        job_ids.append(response['jobId'])
       
    return job_ids

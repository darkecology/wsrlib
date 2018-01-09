import os

from s3_util import download_scans

def main():

    root_data_dir = '/data/radarscans/'

    in_files = ['focused_dataset.txt', 'random_dataset.txt']
    out_subdirs = ['focused/', 'random/']

    for in_file, out_subdir in zip(in_files, out_subdirs):

        print 'Downloading for %s' % in_file

        out_dir = root_data_dir + out_subdir
        if not os.path.isdir(out_dir):
            os.makedirs(out_dir)

        with open(in_file, 'r') as f:
            keys = f.read().split('\n')

        download_scans(keys, out_dir)

        print '\t[Done]'




if __name__ == '__main__':
    main()
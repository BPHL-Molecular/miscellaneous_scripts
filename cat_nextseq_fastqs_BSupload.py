#!/usr/bin/env python3

#Author: Sarah Schmedes
#Email: sarah.schmedes@flhealth.gov

import os
import sys
import subprocess
import argparse
import fnmatch
import re

#Parse arguments, get path for fastqs
parser = argparse.ArgumentParser(usage='cat_nextseq_fastqs_BSupload.py --input <fastq_input_dir> --project <BS_project_name> --deliminator <fastq_name_delim>')
parser.add_argument('--input', help='path to dir with raw fastqs')
parser.add_argument('--project', help='basespace project name')
parser.add_argument('--deliminator', help='specify fastq name deliminator, (e.g., _, -, etc)')

if len(sys.argv[1:]) == 0:
    parser.print_help()
    parser.exit()

args = parser.parse_args()

input_dir = args.input
project = args.project + '_cat'
delim = args.deliminator

if input_dir[-1] != '/':
    input_dir = input_dir + '/'

output_dir = 'combined_fastqs/'
subprocess.run('mkdir -p ' + output_dir, shell=True, check=True) #make output directory

#Get sample names
samples = []
fastqs  = []

for f in os.listdir(input_dir):
    if fnmatch.fnmatch(f, '*.fastq.gz'):
        fastqs.append(f)
        sn = f.split(delim)
        sn = sn[0]
        samples.append(sn)
unique = set(samples)
samples = list(unique)
samples.sort()
fastqs.sort()

#Get Lane,R1 name minus sample name
for s in samples:
    for f in fastqs:
        if fnmatch.fnmatch(f, s + delim + '*L001_R1_001.fastq.gz'):
            pattern = delim + '.*'
            b = re.search(pattern, f)
            base_name = b.group(0)
            middle = base_name.split('L001_R1_001.fastq.gz')[0]
    sample_prefix = input_dir + s + middle
    sample_prefix_out = output_dir + s + middle


    #Concatenate all four lanes per read per sample
    #R1
    subprocess.run('zcat ' + sample_prefix + 'L001_R1_001.fastq.gz ' + sample_prefix + 'L002_R1_001.fastq.gz ' + sample_prefix + 'L003_R1_001.fastq.gz ' + sample_prefix + 'L004_R1_001.fastq.gz > ' + sample_prefix_out + 'L001_R1_001.fastq', shell=True, check=True)
    subprocess.run('gzip ' + sample_prefix_out + 'L001_R1_001.fastq', shell=True, check=True)

    #R2
    subprocess.run('zcat ' + sample_prefix + 'L001_R2_001.fastq.gz ' + sample_prefix + 'L002_R2_001.fastq.gz ' + sample_prefix + 'L003_R2_001.fastq.gz ' + sample_prefix + 'L004_R2_001.fastq.gz > ' + sample_prefix_out + 'L001_R2_001.fastq', shell=True, check=True)
    subprocess.run('gzip ' + sample_prefix_out + 'L001_R2_001.fastq', shell=True, check=True)

#Create new project
subprocess.run('bs create project -n ' + project, shell=True, check=True)

#Get new project id
proc = subprocess.run('bs list project --filter-term=' + project + ' --template=\'{{.Id}}\'', shell=True, check=True, capture_output=True, text=True)
project_id = proc.stdout.rstrip()

#Upload cat fastqs to basespace in new project folder
subprocess.run('bs upload dataset -p ' + project_id + ' --recursive ' + output_dir, shell=True, check=True)

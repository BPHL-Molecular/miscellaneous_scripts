#!/usr/bin/bash
#SBATCH --account=bphl-umbrella
#SBATCH --qos=bphl-umbrella
#SBATCH --job-name=nextseq_fastq
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ENTER EMAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4gb
#SBATCH --time=48:00:00
#SBATCH --output=nextseq_fastq.%j.out
#SBATCH --error=nextseq_fastq.%j.err


python cat_nextseq_fastqs_BSupload.py --input raw_fastqs/ --project <BS project name> --deliminator -

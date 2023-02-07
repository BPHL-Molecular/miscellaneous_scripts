#!/usr/bin/bash
#SBATCH --account=bphl-umbrella
#SBATCH --qos=bphl-umbrella
#SBATCH --job-name=PlasmidFinder
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ENTER EMAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=30gb
#SBATCH --time=04:00:00
#SBATCH --output=plasmidfinder_%j.out
#SBATCH --error=plasmidfinder_%j.err

module load abricate

module load ncbi_blast/2.2.31

abricate --setupdb

abricate --db plasmidfinder  *.fastq.gz > plasmidfinder_results

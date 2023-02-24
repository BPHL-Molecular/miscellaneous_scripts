#!/usr/bin/bash
#SBATCH --account=bphl-umbrella
#SBATCH --qos=bphl-umbrella
#SBATCH --job-name=MobileElementFinder
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ENTER EMAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=30gb
#SBATCH --time=04:00:00
#SBATCH --output=MobileElementFinder_%j.out
#SBATCH --error=MobileElementFinder_%j.err

module load kma/20230106

module load ncbi_blast/2.10.1


  for f in `ls -1 *.fasta | sed 's/\.fasta//'`; do mefinder find --contig /path/to/$f\.fasta $f\_mef_results; done


#!/usr/bin/bash
#SBATCH --account=bphl-umbrella
#SBATCH --qos=bphl-umbrella
#SBATCH --job-name=shigatyper
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ENTER EMAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=30gb
#SBATCH --time=04:00:00
#SBATCH --output=shigatyper_%j.out
#SBATCH --error=shigatyper_%j.err

module load apptainer

mkdir -p shigatyper_out

for f in $(cat samples.txt)
do
    singularity exec -B $(pwd):/data /apps/staphb-toolkit/containers/shigatyper_2.0.1.sif shigatyper --R1 ${f}_1.fastq.gz --R2 ${f}_2.fastq.gz
    mv *tsv shigatyper_out 
done

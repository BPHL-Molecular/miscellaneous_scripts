#!/usr/bin/bash
#SBATCH --account=bphl-umbrella
#SBATCH --qos=bphl-umbrella
#SBATCH --job-name=kraken
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ENTER EMAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=48gb
#SBATCH --time=04:00:00
#SBATCH --output=kraken_%j.out
#SBATCH --error=kraken_%j.err

module load apptainer

mkdir kraken_out_broad

for f in $(cat samples.txt)
do
#    singularity exec -B $(pwd):/data --pwd /data --cleanenv /apps/staphb-toolkit/containers/kraken2_2.1.2-no-db.sif kraken2 --db /blue/bphl-florida/share/kraken_databases/k2_viral_20210517/ --threads $SLURM_CPUS_ON_NODE --use-names --report kraken_out/${f}.report --output kraken_out/${f}_kraken.out --paired ${f}_1.fastq.gz ${f}_2.fastq.gz
    singularity exec -B $(pwd):/data --pwd /data --cleanenv /apps/staphb-toolkit/containers/kraken2_2.1.2-no-db.sif kraken2 --db /blue/bphl-florida/share/kraken_databases/kraken2-broad-custom_other-20200411/ --threads $SLURM_CPUS_ON_NODE --use-names --report kraken_out_broad/${f}.report --output kraken_out_broad/${f}_kraken.out --paired ${f}_1.fastq.gz ${f}_2.fastq.gz
done

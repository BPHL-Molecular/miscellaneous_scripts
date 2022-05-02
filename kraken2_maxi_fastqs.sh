#!/usr/bin/bash
#SBATCH --account=bphl-umbrella
#SBATCH --qos=bphl-umbrella
#SBATCH --job-name=kraken
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ENTER EMAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=50
#SBATCH --mem=160gb
#SBATCH --time=04:00:00
#SBATCH --output=kraken_%j.out
#SBATCH --error=kraken_%j.err

mkdir kraken_out_maxi

for f in $(cat samples.txt)
do
    singularity exec -B $(pwd):/data /apps/staphb-toolkit/containers/kraken2_2.1.2-no-db.sif kraken2 --db /blue/bphl-florida/share/kraken_databases/maxikraken2_1903_140GB/ --threads $SLURM_CPUS_ON_NODE --use-names --report kraken_out_maxi/${f}.report --output kraken_out_maxi/${f}_kraken.out --paired ${f}_1.fastq.gz ${f}_2.fastq.gz
done

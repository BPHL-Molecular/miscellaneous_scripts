#!/usr/bin/bash
#SBATCH --account=bphl-umbrella
#SBATCH --qos=bphl-umbrella
#SBATCH --job-name=bs_download                     # Job name
#SBATCH --mail-type=END,FAIL                       # Mail events
#SBATCH --mail-user=sarah.schmedes@flhealth.gov    # Where to send mail
#SBATCH --ntasks=1                                 # Run on a single CPU
#SBATCH --mem=3gb                                  # Job memory request
#SBATCH --time=24:00:00                            # Time limit hrs:min:sec
#SBATCH --output=bs_download_%j.out                # Standard output log
#SBATCH --error=bs_download_%j.err                 # Standard error log

##Script runs every 24 hours to download new fastqs from basespace projects

today=$(date '+%Y%m%d')
datapath="/blue/bphl-florida/share/bphl_data/basespace/"

#list current projects older than 4 days (time to allow for analysis) in basespace on current date and save to file
cp_personal="${datapath}download_logs/${today}_projects_personal.txt"
cp_flhealth="${datapath}download_logs/${today}_projects_flhealth.txt"
cp_miami="${datapath}download_logs/${today}_projects_miami.txt"
cp_tampa="${datapath}download_logs/${today}_projects_tampa.txt"

/home/schmedess/bin/bs list project --template='{{.Name}}' --newer-than=60d --older-than=4d > $cp_personal
/home/schmedess/bin/bs -c Flhealth list project --template='{{.Name}}' --newer-than=60d --older-than=4d > $cp_flhealth
/home/schmedess/bin/bs -c miami list project --template='{{.Name}}' --newer-than=60d --older-than=4d > $cp_miami
/home/schmedess/bin/bs -c tampa list project --template='{{.Name}}' --newer-than=60d --older-than=4d > $cp_tampa

#Download fastqs in project-named directories, personal
while read line
do
    name=$(echo ${line} | sed 's/ /\ /g')
    mkdir -p ${datapath}personal/"${name}"
    /home/schmedess/bin/bs download project -n "${name}" --extension=fastq.gz -o ${datapath}personal/"${name}"/
    /home/schmedess/bin/bs list datasets --project-name="${name}" -F Name -F Id -F Project.Name -F DateModified -f csv > ${datapath}personal/"${name}"/"${name}"_datasets.csv
done < ${cp_personal}

#Download fastqs in project-named directories, Flhealth
while read line
do
    name=$(echo ${line} | sed 's/ /\ /g')
    mkdir -p ${datapath}Flhealth/"${name}"
    /home/schmedess/bin/bs -c Flhealth download project -n "${name}" --extension=fastq.gz -o ${datapath}Flhealth/"${name}"/
    /home/schmedess/bin/bs -c Flhealth list datasets --project-name="${name}" -F Name -F Id -F Project.Name -F DateModified -f csv > ${datapath}Flhealth/"${name}"/"${name}"_datasets.csv
done < ${cp_flhealth}

#Download fastqs in project-named directories, Miami
while read line
do
    name=$(echo ${line} | sed 's/ /\ /g')
    mkdir -p ${datapath}miami/"${name}"
    /home/schmedess/bin/bs -c miami download project -n "${name}" --extension=fastq.gz -o ${datapath}miami/"${name}"/
    /home/schmedess/bin/bs -c miami list datasets --project-name="${name}" -F Name -F Id -F Project.Name -F DateModified -f csv > ${datapath}miami/"${name}"/"${name}"_datasets.csv
done < ${cp_miami} 

#Download fastqs in project-named directories, Tampa
while read line
do
    name=$(echo ${line} | sed 's/ /\ /g')
    mkdir -p ${datapath}tampa/"${name}"
    /home/schmedess/bin/bs -c tampa download project -n "${name}" --extension=fastq.gz -o ${datapath}tampa/"${name}"/
    /home/schmedess/bin/bs -c tampa list datasets --project-name="${name}" -F Name -F Id -F Project.Name -F DateModified -f csv > ${datapath}tampa/"${name}"/"${name}"_datasets.csv
done < ${cp_tampa}

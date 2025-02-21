#!/bin/bash

#script to align reads to reference using HISAT2. 
#usage
#  sbatch <slurm_array-options> align_hisat2.sh <read location><reference><sam path><other hisat flags in quoted string>
#  sbatch --partition=xxxx --array=1-35 --ntasks=1 --cpus-per-task=4 --mem-per-cpu=4g --time=10:00:00 filter_transcript_reads_hisat2.sh
in_path="../data/fastq_raw"
samples=($in_path/*q.gz)
read1=${samples[(($SLURM_ARRAY_TASK_ID * 2 - 2))]}
read2=${samples[(($SLURM_ARRAY_TASK_ID * 2 - 1))]}
ref="../data/genome/genome_tran"
bam_path="../results/hisat2/initial_alignment"
fq_out_path="../results/hisat2/fastq_out"
fq_trim_path="../results/hisat2/fastq_out_trim"
out=$(basename $read1 | perl -ne 'chomp; s/\_R1.fastq.gz$//; print')

echo $read1
echo $read2
echo "ref $ref"
echo "output ${bam_path}/${out}.bam"

mkdir -p $bam_path
mkdir -p $fq_out_path
mkdir -p $fq_trim_path

# step 1: do an alignment, reporting only mappings to transcripts; filter and create bam file

module load hisat2/2.2.1 samtools/1.14

hisat2 -p 4 -x $ref -1 $read1 -2 $read2 --upto 20000000 --tmo | samtools view --threads 4 -h -F 4 - | \
    samtools sort --threads 4 -O bam -o ${bam_path}/${out}.bam

# step 2: output concordant pairs to named files

samtools fastq --threads 4 -f 2 -1 $fq_out_path/${out}_R1.fastq.gz -2 $fq_out_path/${out}_R2.fastq.gz ${bam_path}/${out}.bam

module unload hisat2 samtools

# step 3: adapter and quality filtering

module load trimgalore/0.6.6

trim_galore -q 30 --cores 4 --output_dir $fq_trim_path --paired $fq_out_path/${out}_R1.fastq.gz $fq_out_path/${out}_R2.fastq.gz


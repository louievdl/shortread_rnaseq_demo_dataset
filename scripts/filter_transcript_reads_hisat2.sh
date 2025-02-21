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
fq_out_path="../results/hisat2/fastq_out"
fq_trim_path="../results/hisat2/fastq_out_trim"
out=$(basename $read1 | perl -ne 'chomp; s/\_R1.fastq.gz$//; print')

echo $read1
echo $read2
echo "ref $ref"

mkdir -p $fq_out_path
mkdir -p $fq_trim_path


# step 1: filtering all in one go, discard alignments

module load hisat2/2.2.1

hisat2 -p 4 -x $ref -1 $read1 -2 $read2 --upto 20000000 --tmo --al-conc-gz $fq_out_path/${out}_R%.fastq.gz > /dev/null

module unload hisat2 samtools



# step 2: adapter and quality filtering

module load trimgalore/0.6.6

trim_galore -q 30 --cores 4 --output_dir $fq_trim_path --paired $fq_out_path/${out}_R1.fastq.gz $fq_out_path/${out}_R2.fastq.gz


#!/bin/bash
set -e

#set base path
base_path="/Users/galongo/Developer/labfiles/ATACseq/genome_indices"
star_output_dir="${base_path}/STAR_output"
star_sorted_dir="${base_path}/STAR_sorted_bam"
mkdir -p ${star_sorted_dir} ${star_output_dir}

#align mm10 genome subset to itself to test the index
STAR --genomeDir ${base_path}/STAR_index/mm10 \
    --runThreadN 6 \
    --readFilesIn ${base_path}/sim_mm10_R1.fastq \
    --outFileNamePrefix ${star_output_dir}/mm10_test_ \
    --outSAMtype BAM Unsorted

#sort bam file
samtools sort -@ 6 ${star_output_dir}/mm10_test_Aligned.out.bam -o ${star_sorted_dir}/mm10_test_Aligned.sorted.bam
#index bam file
samtools index ${star_sorted_dir}/mm10_test_Aligned.sorted.bam
#run flagstat to get alignment stats
samtools flagstat ${star_sorted_dir}/mm10_test_Aligned.sorted.bam

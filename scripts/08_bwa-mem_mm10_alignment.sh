#!/bin/bash
set -e

base_path="/Users/galongo/Developer/labfiles/ATACseq/genome_indices"
bwa_output_dir="${base_path}/bwa-mem_output"
mkdir -p "${bwa_output_dir}"

#align mm10 subset with bwa-mem to mm10 genome to check index
bwa mem -t 8 \
    ${base_path}/bwa_index/mm10 \
    ${base_path}/sim_mm10_R1.fastq \
    2> ${bwa_output_dir}/mm10_bwa_Aligned.log \
    | samtools view -@ 8 -b - \
    | samtools sort -@ 8 -o ${bwa_output_dir}/mm10_bwa_Aligned.sorted.bam
#index bam file
samtools index "${bwa_output_dir}/mm10_bwa_Aligned.sorted.bam"
#run flagstat to get alignment statistics and write to file
samtools flagstat "${bwa_output_dir}/mm10_bwa_Aligned.sorted.bam" > "${bwa_output_dir}/mm10_bwa-mem_flagstat.txt"
cat "${bwa_output_dir}/mm10_bwa-mem_flagstat.txt"

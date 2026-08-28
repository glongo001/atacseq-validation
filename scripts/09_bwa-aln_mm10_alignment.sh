#!/bin/bash
set -e

base_path="/Users/galongo/Developer/labfiles/ATACseq/genome_indices"
bwa_output_dir="${base_path}/bwa_output"
mkdir -p "${bwa_output_dir}"

#align mm10 subset with bwa to mm10 genome to check index
bwa aln -t 8 \
    ${base_path}/bwa_index/mm10 \
    ${base_path}/sim_mm10_R1.fastq \
    > ${bwa_output_dir}/mm10_bwaaln_Aligned.sai \
    2> ${bwa_output_dir}/mm10_bwaaln_Aligned.log

bwa_index="${base_path}/bwa_index/mm10"

bwa samse ${bwa_index} \
    ${bwa_output_dir}/mm10_bwaaln_Aligned.sai \
    ${base_path}/sim_mm10_R1.fastq \
    2>> ${bwa_output_dir}/mm10_bwaaln.log \
    | samtools view -@ 8 -b - \
    | samtools sort -@ 8 -o ${bwa_output_dir}/mm10_bwaaln.sorted.bam

#index bam file
#run flagstat to get alignment statistics
samtools index "${bwa_output_dir}/mm10_bwaaln.sorted.bam"
samtools flagstat "${bwa_output_dir}/mm10_bwaaln.sorted.bam" > "${bwa_output_dir}/mm10_bwaaln_flagstat.txt"
cat "${bwa_output_dir}/mm10_bwaaln_flagstat.txt"

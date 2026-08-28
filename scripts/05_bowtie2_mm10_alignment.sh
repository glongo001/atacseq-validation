#!/bin/bash
set -e

base_path="/Users/galongo/Developer/labfiles/ATACseq/genome_indices"
bowtie2_output="${base_path}/bowtie2_output"
mkdir -p "${bowtie2_output}"

#align simulated mm10 reads to index with bowtie2
#use samtools to convert to bam, sort and index
bowtie2 -p 10 \
        --mm \
        --very-sensitive \
        -x ${base_path}/bowtie2_index/mm10 \
        -U ${base_path}/sim_mm10_R1.fastq \
        2> ${bowtie2_output}/mm10_bowtie2_Aligned.log \
    | samtools view -@ 10 -b - | \
    samtools sort -@ 10 -o ${bowtie2_output}/mm10_bowtie2_Aligned.sorted.bam
samtools index ${bowtie2_output}/mm10_bowtie2_Aligned.sorted.bam

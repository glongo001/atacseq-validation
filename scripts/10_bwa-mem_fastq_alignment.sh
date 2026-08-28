#!/bin/bash
set -e

%%bash
base_path="/Users/galongo/Developer/labfiles/ATACseq/genome_indices"
fastq_path='/Users/galongo/Developer/labfiles/ATACseq/fastq/merged_fastq'
bwa_output_dir="${base_path}/bwa-mem_output"

#process each sample
for fastq in ${fastq_path}/*_merged.fastq.gz; do
    if [[ ! -f "$fastq" ]]; then
        echo "No FASTQ files found in ${fastq_path}"
        continue
    fi
    
    #extract sample name
    sample=$(basename "$fastq" _merged.fastq.gz)
    echo "Processing sample: $sample"
    
    #align samples with bwa-mem, samtools to convert to bam, sort and index
    bwa mem -t 10 \
        ${base_path}/bwa_index/mm10 \
        ${fastq} \
        2> ${bwa_output_dir}/${sample}_bwa-mem_Aligned.log \
        | samtools view -@ 10 -b - \
        | samtools sort -@ 10 -o ${bwa_output_dir}/${sample}_bwa-mem.sorted.bam
    #index bam file
    samtools index ${bwa_output_dir}/${sample}_bwa-mem.sorted.bam
    #run flagstat to get alignment statistics
    samtools flagstat ${bwa_output_dir}/${sample}_bwa-mem.sorted.bam
done

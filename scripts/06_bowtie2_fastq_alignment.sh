#!/bin/bash
set -e

base_path="/Users/galongo/Developer/labfiles/ATACseq/genome_indices"
fastq_path='/Users/galongo/Developer/labfiles/ATACseq/fastq/merged_fastq'
bowtie2_index="${base_path}/bowtie2_index/mm10"
bowtie2_output_dir="${base_path}/bowtie2_output"

#process each sample
for fastq in ${fastq_path}/*_merged.fastq.gz; do
    if [[ ! -f "$fastq" ]]; then
        echo "No FASTQ files found in ${fastq_path}"
        continue
    fi
    
    sample=$(basename "$fastq" _merged.fastq.gz)
    echo "Processing sample: $sample"
    #align with bowtie2, samtools to convert to bam, sort and index
    bowtie2 -p 10 \
            --phred33 \
            --mm \
            --very-sensitive \
            -x ${bowtie2_index} \
            -U "$fastq" \
            2> ${bowtie2_output_dir}/${sample}_bowtie2.log \
        | samtools view -@ 10 -b - \
        | samtools sort -@ 10 -o ${bowtie2_output_dir}/${sample}_bowtie2.sorted.bam
    samtools index ${bowtie2_output_dir}/${sample}_bowtie2.sorted.bam
done

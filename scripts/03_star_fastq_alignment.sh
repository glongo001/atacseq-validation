#!/bin/bash
set -e

#set directory paths
base_path="/Users/galongo/Developer/labfiles/ATACseq/genome_indices"
fastq_path='/Users/galongo/Developer/labfiles/ATACseq/fastq/merged_fastq'
index_path="${base_path}/STAR_index/mm10"
sample_list="${fastq_path}/samplestest.txt"
star_output_dir="${base_path}/STAR_output"
star_sorted_dir="${base_path}/STAR_sorted_bam"
mkdir -p "${star_output_dir}" "${star_sorted_dir}"

#define sample index
i=0

#get sample name
sample=$(sed -n "$((i + 1))p" "${sample_list}" | cut -f1)

#process each sample
while read -r sample; do
    #skip empty lines
    if [[ -z "$sample" ]]; then
        continue
    fi
    
    echo "Processing sample: ${sample}"
    
    #create sample directory
    sample_dir="${star_output_dir}/${sample}"
    mkdir -p "${sample_dir}"
    
    #run on merged fastq
    infile="${fastq_path}/${sample}_merged.fastq.gz"
    sorted_bam_path="${star_sorted_dir}/${sample}_Aligned.sorted.bam"

    #skip if already exists
    if [[ -f "${sorted_bam_path}" ]]; then
        echo "${sample} already processed. Skipping..."
        continue
    fi

    #create temporary directory for each file
    outTmpDir="${sample_dir}/STARtmp_${sample}"
    #remove if it exists to prevent conflicts
    rm -rf "${outTmpDir}"
        
    #align with star
    STAR --genomeDir "${index_path}" \
        --runThreadN 6 \
        --readFilesCommand gunzip -c \
        --alignIntronMax 1 \
        --alignEndsType EndToEnd \
        --outFilterMultimapNmax 20 \
        --outSAMmultNmax 1 \
        --outFilterMismatchNoverLmax 0.10 \
        --outFilterScoreMinOverLread 0.66 \
        --outFilterMatchNminOverLread 0.66 \
        --readFilesIn "${infile}" \
        --outFileNamePrefix "${sample_dir}/${sample}_" \
        --outSAMtype BAM Unsorted \
        --outTmpDir "${outTmpDir}" || { echo "STAR failed for ${sample}"; exit 1;}

    #filter for uniquely mapped reads
    samtools view -b -q 255 "${sample_dir}/${sample}_Aligned.out.bam" > "${sample_dir}/${sample}_Aligned.filtered.bam"
    #sort bam file
    samtools sort -@ 6 "${sample_dir}/${sample}_Aligned.filtered.bam" -o "${sorted_bam_path}" || exit 1
    #index bam file
    samtools index "${sorted_bam_path}"
done < "${sample_list}"

echo "All samples processed"

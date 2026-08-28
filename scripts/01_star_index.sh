#!/bin/bash
set -e

base_path="/Users/galongo/Developer/labfiles/ATACseq/genome_indices"
cd $base_path
mkdir -p ${base_path}/STAR_index/mm10

echo "Creating mm10 STAR index"

#generate genome index with star
STAR --runThreadN 8 \
    --runMode genomeGenerate \
    --genomeDir ${base_path}/STAR_index/mm10 \
    --genomeFastaFiles ${base_path}/mm10_reference_files/GRCm38.primary_assembly.genome.fa \
    --sjdbGTFfile ${base_path}/mm10_reference_files/gencode.vM10.primary_assembly.annotation.gtf \
    --sjdbOverhang 149

echo "Index creation complete"

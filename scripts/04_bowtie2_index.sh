#!/bin/bash
set -e

base_path="/Users/galongo/Developer/labfiles/ATACseq/genome_indices"
mkdir -p ${base_path}/bowtie2_index

#generate index with bowtie2
bowtie2-build --threads 10 \
    ${base_path}/mm10_reference_files/GRCm38.primary_assembly.genome.fa \
    ${base_path}/bowtie2_index/mm10

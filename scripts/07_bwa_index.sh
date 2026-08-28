#!/bin/bash
set -e

base_path="/Users/galongo/Developer/labfiles/ATACseq/genome_indices"
mkdir -p ${base_path}/bwa_index

#generate index with bwa
bwa index -p ${base_path}/bwa_index/mm10 \
    ${base_path}/mm10_reference_files/GRCm38.primary_assembly.genome.fa

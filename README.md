# atacseq-validation
Validation of ATACseq alignments using STAR, bowtie2 and BWA on the mm10 genome

## STAR
- Used version 2.7.11b
- Created STAR index
- Used wgsim to generate a fastq file of 100,000 singl-end simulated reads from the mm10 genome
- Aligned the simulated mm10 reads to the index and checked alignment
- Aligned 4 samples

## Bowtie2
- Used version 2.5.5
- Created bowtie2 index
- Used the simulated mm10 reads to align to index
- Aligned 4 samples

## BWA
- Used version 0.7.19
- Created bwa index
- Used the simulated mm10 reads to align to index with bwa-mem and bwa-aln
- Generated flagstat output file to view alignment rates
- Aligned 4 samples with bwa-mem and bwa-aln
- Generated flagstat output file to view alignment rates
#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=05:00:00
#SBATCH --job-name=samtools
#SBATCH --output=/data/users/fgribi/transcriptome_assembly/output/output_samtools_%j.o
#SBATCH --error=/data/users/fgribi/transcriptome_assembly/output/error_samtools_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/fgribi/transcriptome_assembly
OUTDIR=$WORKDIR/output/samtools
MODULE=SAMtools/1.13-GCC-10.3.0 
ASSEMBLY=$WORKDIR/data/assemblies/assembly.flye.fasta

module load $MODULE

mkdir -p $OUTDIR
touch $OUTDIR/flye.fai

samtools faidx $ASSEMBLY --fai-idx $OUTDIR/flye.fai
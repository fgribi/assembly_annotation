#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --job-name=fastp
#SBATCH --output=/data/users/fgribi/genome_assembly/output_fastp_%j.o
#SBATCH --error=/data/users/fgribi/genome_assembly/error_fastp_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/fgribi/genome_assembly
OUTDIR=$WORKDIR/read_QC/fastp

mkdir -p $OUTDIR

module load fastp/0.23.4-GCC-10.3.0

fastp -i $WORKDIR/Hiroshima/*  -o $OUTDIR/pacbio_trimmed.fastq.gz -h $OUTDIR/pacbio.html
fastp -i $WORKDIR/RNAseq_Sha/*1* -I $WORKDIR/RNAseq_Sha/*2*  -o $OUTDIR/short_1.fastq.gz -O $OUTDIR/short_2.fastq.gz -q 20 -h $OUTDIR/short.html


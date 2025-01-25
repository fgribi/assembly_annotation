#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --job-name=fastqc
#SBATCH --output=/data/users/fgribi/output_fastqc_%j.o
#SBATCH --error=/data/users/fgribi/error_fastqc_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/fgribi/genome_assembly/
OUTDIR=$WORKDIR/read_QC/fastqc

mkdir -p $OUTDIR

module load FastQC/0.11.9-Java-11

fastqc -o $OUTDIR --extract $WORKDIR/Hiroshima/* $WORKDIR/RNAseq_Sha/*


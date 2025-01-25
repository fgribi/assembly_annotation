#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=02:00:00
#SBATCH --job-name=TEage
#SBATCH --output=/data/users/fgribi/transcriptome_assembly/output/output_TEage_%j.o
#SBATCH --error=/data/users/fgribi/transcriptome_assembly/output/error_TEage_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/fgribi/transcriptome_assembly
OUTFILE=$WORKDIR/output/EDTA_annotation/assembly.flye.fasta.mod.EDTA.anno/assembly.flye.fasta.mod.out
SCRIPT=/data/courses/assembly-annotation-course/CDS_annotation/scripts/04-parseRM.pl

module load BioPerl/1.7.8-GCCcore-10.3.0
perl $SCRIPT -i $OUTFILE -l 50,1 -v 

#!/usr/bin/env bash

#SBATCH --time=04:00:00
#SBATCH --mem=10G
#SBATCH --cpus-per-task=10
#SBATCH --job-name=sequence_homology
#SBATCH --output=/data/users/fgribi/transcriptome_assembly/output/output_sequence_homology_%j.o
#SBATCH --error=/data/users/fgribi/transcriptome_assembly/output/error_sequence_homology_%j.e
#SBATCH --partition=pibu_el8

module load BLAST+/2.15.0-gompi-2021a

OUTDIR=/data/users/fgribi/transcriptome_assembly/output/homology
PROTEINS=/data/users/fgribi/transcriptome_assembly/output/busco/protein.renamed.longest.fasta
DB=/data/courses/assembly-annotation-course/CDS_annotation/data/uniprot/uniprot_viridiplantae_reviewed.fa

mkdir -p $OUTDIR
cd $OUTDIR

blastp -query $PROTEINS -db $DB -num_threads 10 -outfmt 6 -evalue 1e-10 -out blastp_output
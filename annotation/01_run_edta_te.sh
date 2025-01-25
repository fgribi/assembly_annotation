#!/usr/bin/env bash

#SBATCH --cpus-per-task=20
#SBATCH --mem=40G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=edta
#SBATCH --output=/data/users/fgribi/transcriptome_assembly/output/output_edta_%j.o
#SBATCH --error=/data/users/fgribi/transcriptome_assembly/output/error_edta_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/fgribi/transcriptome_assembly
OUTDIR=$WORKDIR/output/EDTA_annotation
IMAGE=/data/courses/assembly-annotation-course/containers2/EDTA_v1.9.6.sif
CDS="/data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10_cds_20110103_representative_gene_model_updated"
ASSEMBLY=$WORKDIR/data/assemblies/assembly.flye.fasta

mkdir -p $OUTDIR
cd $OUTDIR

apptainer exec -C -H $WORKDIR -H ${pwd}:/work \
 --writable-tmpfs -u $IMAGE EDTA.pl \
 --genome $ASSEMBLY \
 --species others \
 --step all \
 --cds $CDS \
 --anno 1 \
 --threads 20
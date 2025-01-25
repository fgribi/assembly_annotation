#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=05:00:00
#SBATCH --job-name=clades
#SBATCH --output=/data/users/fgribi/transcriptome_assembly/output/output_clades_%j.o
#SBATCH --error=/data/users/fgribi/transcriptome_assembly/output/error_clades_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/fgribi/transcriptome_assembly
OUTDIR=$WORKDIR/output/EDTA_annotation/assembly.flye.fasta.mod.EDTA.raw/LTR
IMAGE=/data/courses/assembly-annotation-course/containers2/TEsorter_1.3.0.sif
ASSEMBLY=$WORKDIR/data/assemblies/assembly.flye.fasta
DUSTED=$OUTDIR/assembly.flye.fasta.mod.LTR.intact.fa.ori.dusted

cd $OUTDIR

apptainer exec -C -H $WORKDIR -H ${pwd}:/work \
 --writable-tmpfs -u $IMAGE TEsorter $DUSTED -db rexdb-plant

#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=05:00:00
#SBATCH --job-name=TEsorter
#SBATCH --output=/data/users/fgribi/transcriptome_assembly/output/output_TEsorter_%j.o
#SBATCH --error=/data/users/fgribi/transcriptome_assembly/output/error_TEsorter_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/fgribi/transcriptome_assembly
OUTDIR=$WORKDIR/output/TEsorter
MODULE=SeqKit/2.6.1
IMAGE=/data/courses/assembly-annotation-course/containers2/TEsorter_1.3.0.sif
EDTA=$WORKDIR/output/EDTA_annotation/assembly.flye.fasta.mod.EDTA.TElib.fa

module load $MODULE

mkdir -p $OUTDIR
cd $OUTDIR

seqkit grep -r -p "Copia" $EDTA > Copia_sequences.fa
seqkit grep -r -p "Gypsy" $EDTA > Gypsy_sequences.fa

apptainer exec -C -H $WORKDIR -H ${pwd}:/work --writable-tmpfs -u $IMAGE \
 TEsorter Copia_sequences.fa -db rexdb-plant

apptainer exec -C -H $WORKDIR -H ${pwd}:/work --writable-tmpfs -u $IMAGE \
 TEsorter Gypsy_sequences.fa -db rexdb-plant

#!/usr/bin/env bash

#SBATCH --time=05:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=8
#SBATCH --job-name=mummerplot
#SBATCH --output=/data/users/fgribi/genome_assembly/output_mummerplot%j.o
#SBATCH --error=/data/users/fgribi/genome_assembly/error_mummerplot%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/fgribi/genome_assembly
OUTDIR=$WORKDIR/mummerplot
REFERENCE=/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
ASSEMBLIES=$WORKDIR/assembly/primary_assemblies
LJA=$ASSEMBLIES/assembly.fasta
FLYE=$ASSEMBLIES/assembly.flye.fasta
HIFIASM=$ASSEMBLIES/hiroshima.asm.p_ctg.fa
LJA_DELTA=$WORKDIR/nucmer/lja.delta
FLYE_DELTA=$WORKDIR/nucmer/flye.delta
HIFIASM_DELTA=$WORKDIR/nucmer/hifiasm.delta

mkdir -p $OUTDIR

cd $OUTDIR

apptainer exec\
 --bind $WORKDIR\
  /containers/apptainer/mummer4_gnuplot.sif\
  mummerplot -R $REFERENCE\
  -Q $LJA \
  --fat \
  --layout \
  --filter \
  -breaklen 1000\
  -t png\
  --large \
  -p lja \
  $LJA_DELTA
 
apptainer exec\
 --bind $WORKDIR\
  /containers/apptainer/mummer4_gnuplot.sif\
  mummerplot -R $REFERENCE\
  -Q $FLYE \
  --fat \
  --layout \
  --filter \
  -breaklen 1000\
  -t png\
  --large \
  -p flye \
  $FLYE_DELTA

apptainer exec\
 --bind $WORKDIR\
  /containers/apptainer/mummer4_gnuplot.sif\
  mummerplot -R $REFERENCE\
  -Q $HIFIASM \
  --fat \
  --layout \
  --filter \
  -breaklen 1000\
  -t png\
  --large \
  -p hifiasm \
  $HIFIASM_DELTA
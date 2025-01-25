#!/usr/bin/env bash

#SBATCH --time=05:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=8
#SBATCH --job-name=nucmer
#SBATCH --output=/data/users/fgribi/genome_assembly/output_nucmer%j.o
#SBATCH --error=/data/users/fgribi/genome_assembly/error_nucmer%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/fgribi/genome_assembly
OUTDIR=$WORKDIR/nucmer
REFERENCE=/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
ASSEMBLIES=$WORKDIR/assembly/primary_assemblies
LJA=$ASSEMBLIES/assembly.fasta
FLYE=$ASSEMBLIES/assembly.flye.fasta
HIFIASM=$ASSEMBLIES/hiroshima.asm.p_ctg.fa

mkdir -p $OUTDIR

cd $OUTDIR

apptainer exec --bind $WORKDIR /containers/apptainer/mummer4_gnuplot.sif nucmer -p lja -b 1000 -c 1000 $REFERENCE $LJA

apptainer exec --bind $WORKDIR /containers/apptainer/mummer4_gnuplot.sif nucmer -p flye -b 1000 -c 1000 $REFERENCE $FLYE

apptainer exec --bind $WORKDIR /containers/apptainer/mummer4_gnuplot.sif nucmer -p hifiasm -b 1000 -c 1000 $REFERENCE $HIFIASM
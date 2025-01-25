#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=quast
#SBATCH --output=/data/users/fgribi/genome_assembly/output_quast%j.o
#SBATCH --error=/data/users/fgribi/genome_assembly/error_quast%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/fgribi/genome_assembly
ASSEMBLYDIR=$WORKDIR/assembly/primary_assemblies
REFERENCE=/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz
ANNOTATION=/data/courses/assembly-annotation-course/references/TAIR10_GFF3_genes.gff
OUTDIR1=$WORKDIR/assembly_qc/quast_reference
OUTDIR2=$WORKDIR/assembly_qc/quast_no_reference

mkdir -p $OUTDIR1 $OUTDIR2

apptainer exec \
--bind $WORKDIR \
/containers/apptainer/quast_5.2.0.sif \
quast.py \
$ASSEMBLYDIR/assembly.fasta \
$ASSEMBLYDIR/assembly.flye.fasta \
$ASSEMBLYDIR/hiroshima.asm.p_ctg.fa \
-r $REFERENCE \
-e \
--large \
--threads 4 \
-l lja,flye,hifiasm \
--features $ANNOTATION \
--pacbio $WORKDIR/Hiroshima/*.fastq.gz \
--no-sv \
-o $OUTDIR1

apptainer exec \
--bind $WORKDIR \
/containers/apptainer/quast_5.2.0.sif \
quast.py \
$ASSEMBLYDIR/assembly.fasta \
$ASSEMBLYDIR/assembly.flye.fasta \
$ASSEMBLYDIR/hiroshima.asm.p_ctg.fa \
-e \
--large \
--threads 4 \
-l lja,flye,hifiasm \
--pacbio $WORKDIR/Hiroshima/*.fastq.gz \
--no-sv \
--est-ref-size 135000000 \
-o $OUTDIR2


#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=merqury
#SBATCH --output=/data/users/fgribi/genome_assembly/output_merqury%j.o
#SBATCH --error=/data/users/fgribi/genome_assembly/error_merqury%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/fgribi/genome_assembly
OUTDIR=$WORKDIR/assembly_qc/merqury/
ASSEMBLYDIR=$WORKDIR/assembly/primary_assemblies

export MERQURY="/usr/local/share/merqury"

mkdir -p $OUTDIR

#apptainer exec --bind $WORKDIR /containers/apptainer/merqury_1.3.sif $MERQURY/best_k.sh 135000000
# best k-mers size: 18

# uncomment for constructing meryl database
# apptainer exec --bind $WORKDIR /containers/apptainer/merqury_1.3.sif meryl k=18 count /data/users/fgribi/genome_assembly/Hiroshima/ERR11437318.fastq.gz output $OUTDIR/genome.meryl \

# apptainer exec --bind $WORKDIR /containers/apptainer/merqury_1.3.sif merqury.sh /data/users/fgribi/genome_assembly/assembly_qc/merqury/genome.meryl /data/users/fgribi/genome_assembly/assembly/primary_assemblies/assembly.fasta lja
# apptainer exec --bind $WORKDIR /containers/apptainer/merqury_1.3.sif merqury.sh /data/users/fgribi/genome_assembly/assembly_qc/merqury/genome.meryl /data/users/fgribi/genome_assembly/assembly/primary_assemblies/assembly.flye.fasta flye
apptainer exec --bind $WORKDIR /containers/apptainer/merqury_1.3.sif merqury.sh /data/users/fgribi/genome_assembly/assembly_qc/merqury/genome.meryl /data/users/fgribi/genome_assembly/assembly/primary_assemblies/assembly.hifiasm.fasta hifiasm
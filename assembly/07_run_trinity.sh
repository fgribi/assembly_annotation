#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=trinity
#SBATCH --output=/data/users/fgribi/genome_assembly/output_trinity_%j.o
#SBATCH --error=/data/users/fgribi/genome_assembly/error_trinity_%j.e
#SBATCH --mail-user=fabian.gribi@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/fgribi/genome_assembly
OUTDIR=$WORKDIR/assembly/trinity

mkdir -p $OUTDIR

module load Trinity/2.15.1-foss-2021a

Trinity \
--seqType fq \
--max_memory 50G \
--left  $WORKDIR/read_QC/fastp/short_1.fastq.gz \
--right $WORKDIR/read_QC/fastp/short_2.fastq.gz \
--CPU 16 \
--output $OUTDIR



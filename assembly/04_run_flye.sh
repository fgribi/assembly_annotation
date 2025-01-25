#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=flye
#SBATCH --output=/data/users/fgribi/genome_assembly/output_flye_%j.o
#SBATCH --error=/data/users/fgribi/genome_assembly/error_flye_%j.e
#SBATCH --mail-user=fabian.gribi@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/fgribi/genome_assembly
OUTDIR=$WORKDIR/assembly/flye

mkdir -p $OUTDIR

apptainer exec \
--bind $WORKDIR \
/containers/apptainer/flye_2.9.5.sif \
flye \
--pacbio-hifi $WORKDIR/Hiroshima/* \
--out-dir $OUTDIR \
--threads 4 \
--genome-size 144m
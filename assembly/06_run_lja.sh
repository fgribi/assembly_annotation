#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=lja
#SBATCH --output=/data/users/fgribi/genome_assembly/output_lja_%j.o
#SBATCH --error=/data/users/fgribi/genome_assembly/error_lja_%j.e
#SBATCH --mail-user=fabian.gribi@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/fgribi/genome_assembly
OUTDIR=$WORKDIR/assembly/lja

mkdir -p $OUTDIR

apptainer exec \
--bind $WORKDIR \
/containers/apptainer/lja-0.2.sif \
lja \
-o $OUTDIR \
--reads $WORKDIR/Hiroshima/ERR11437318.fastq.gz \
--diploid
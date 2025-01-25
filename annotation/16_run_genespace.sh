#!/bin/bash
#SBATCH --time=1-0
#SBATCH --mem=64G
#SBATCH -p pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --job-name=genespace
#SBATCH --output=/data/users/fgribi/transcriptome_assembly/output/output_genespace_%j.o
#SBATCH --error=/data/users/fgribi/transcriptome_assembly/output/error_genespace_%j.e

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/fgribi/transcriptome_assembly"

apptainer exec \
    --bind $COURSEDIR \
    --bind $WORKDIR \
    --bind $SCRATCH:/temp \
    $COURSEDIR/containers/genespace_latest.sif Rscript $WORKDIR/scripts/15_genespace.R $WORKDIR/output/GENESPACE/genespace
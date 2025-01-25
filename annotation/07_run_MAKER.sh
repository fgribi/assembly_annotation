#!/usr/bin/env bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=50
#SBATCH --mem=64G
#SBATCH --time=4-0
#SBATCH --job-name=MAKER
#SBATCH --output=/data/users/fgribi/transcriptome_assembly/output/output_MAKER_%j.o
#SBATCH --error=/data/users/fgribi/transcriptome_assembly/output/error_MAKER_%j.e
#SBATCH --partition=pibu_el8

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR=/data/users/fgribi/transcriptome_assembly/output/MAKER
REPEATMASKER_DIR="/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker"
export PATH=$PATH:"/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker"

cd $WORKDIR
module load OpenMPI/4.1.1-GCC-10.3.0
module load AUGUSTUS/3.4.0-foss-2021a

mpiexec --oversubscribe -n 50 apptainer exec \
 --bind $SCRATCH:/TMP --bind $COURSEDIR --bind $AUGUSTUS_CONFIG_PATH --bind $REPEATMASKER_DIR \
 ${COURSEDIR}/containers/MAKER_3.01.03.sif \
 maker -mpi --ignore_nfs_tmp -TMP /TMP maker_opts.ctl maker_bopts.ctl maker_evm.ctl maker_exe.ctl
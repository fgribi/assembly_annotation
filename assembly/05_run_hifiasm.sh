#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=hifiasm
#SBATCH --output=/data/users/fgribi/genome_assembly/output_hifiasm_%j.o
#SBATCH --error=/data/users/fgribi/genome_assembly/error_hifiasm_%j.e
#SBATCH --mail-user=fabian.gribi@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/fgribi/genome_assembly
OUTDIR=$WORKDIR/assembly/hifiasm

mkdir -p $OUTDIR

apptainer exec \
--bind $WORKDIR \
/containers/apptainer/hifiasm_0.19.8.sif \
hifiasm \
-o $OUTDIR/hiroshima.asm \
-t16 \
$WORKDIR/Hiroshima/ERR11437318.fastq.gz

cd $OUTDIR
awk '/^S/{print ">"$2;print $3}' hiroshima.asm.bp.p_ctg.gfa > hiroshima.asm.p_ctg.fa

#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=busco
#SBATCH --output=/data/users/fgribi/genome_assembly/output_busco%j.o
#SBATCH --error=/data/users/fgribi/genome_assembly/error_busco%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/fgribi/genome_assembly
ASSEMBLYDIR=$WORKDIR/assembly/primary_assemblies
ASSEMBLIES=(
    "$WORKDIR/assembly/flye/assembly.flye.fasta"
    "$WORKDIR/assembly/hifiasm/hiroshima.asm.p_ctg.fa"
    "$WORKDIR/assembly/lja/assembly.fasta"
)
OUTDIR1=$WORKDIR/assembly_qc/busco_genomes
OUTDIR2=$WORKDIR/assembly_qc/busco_transcriptome

mkdir -p $ASSEMBLYDIR $OUTDIR1 $OUTDIR2

for file in "${ASSEMBLIES[@]}"; do
    ln -s $file $ASSEMBLYDIR
done

module load BUSCO/5.4.2-foss-2021a

busco \
-f \
-i $ASSEMBLYDIR \
-m genome \
-l brassicales_odb10 \
-c 12 \
-o $OUTDIR1 \

busco \
-f \
-i $WORKDIR/assembly/trinity.Trinity.fasta \
-m transcriptome \
-l brassicales_odb10 \
-c 4 \
-o $OUTDIR2
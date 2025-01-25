#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --job-name=jellyfish
#SBATCH --output=/data/users/fgribi/genome_assembly/output_jellyfish_%j.o
#SBATCH --error=/data/users/fgribi/genome_assembly/error_jellyfish_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/fgribi/genome_assembly
OUTDIR=$WORKDIR/kmer/

mkdir -p $OUTDIR

module load Jellyfish/2.3.0-GCC-10.3.0

jellyfish count -C -m 21 -s 5G  -t 4\
	<(zcat	$WORKDIR/Hiroshima/*.fastq.gz)\
       	-o $OUTDIR/pacbio.jf

jellyfish histo -t 10 $OUTDIR/pacbio.jf > pacbio.histo

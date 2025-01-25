#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=busco
#SBATCH --output=/data/users/fgribi/transcriptome_assembly/output/output_busco_%j.o
#SBATCH --error=/data/users/fgribi/transcriptome_assembly/output/error_busco_%j.e
#SBATCH --partition=pibu_el8
WORKDIR=/data/users/fgribi/transcriptome_assembly
OUTDIR=$WORKDIR/output/busco
PROTEINS=$WORKDIR/output/MAKER/final/assembly.all.maker.proteins.fasta.renamed.fasta
TRANSCIPTS=$WORKDIR/output/MAKER/final/assembly.all.maker.transcripts.fasta.renamed.fasta

mkdir -p $OUTDIR

module load BUSCO/5.4.2-foss-2021a
module load SeqKit/2.6.1

# Filter for longest isoforms
seqkit fx2tab $PROTEINS | \
awk -F '\t' '{
    # Extract the gene ID (assumes format: geneID-isoformID)
    split($1, a, "-"); 
    gene = a[1];
    
    # Check if the current sequence is the longest for this gene
    if (length($2) > max[gene]) {
        seq[gene] = $0;            # Store the entire line (header and sequence)
        max[gene] = length($2);    # Store the length of the sequence
    }
} END {
    # Print the longest sequence for each gene
    for (gene in seq) {
        print seq[gene];
    }
}' | \
# Convert the tabular format back to FASTA
seqkit tab2fx -o $OUTDIR/protein.renamed.longest.fasta


seqkit fx2tab $TRANSCIPTS | \
awk -F '\t' '{
    # Extract the gene ID (assumes format: geneID-isoformID)
    split($1, a, "-"); 
    gene = a[1];
    
    # Check if the current sequence is the longest for this gene
    if (length($2) > max[gene]) {
        seq[gene] = $0;            # Store the entire line (header and sequence)
        max[gene] = length($2);    # Store the length of the sequence
    }
} END {
    # Print the longest sequence for each gene
    for (gene in seq) {
        print seq[gene];
    }
}' | \
# Convert the tabular format back to FASTA
seqkit tab2fx -o $OUTDIR/transcript.renamed.longest.fasta

cd $OUTDIR

# Run BUSCO
busco -i $OUTDIR/protein.renamed.longest.fasta -l brassicales_odb10 -o protein -m proteins
busco -i $OUTDIR/transcript.renamed.longest.fasta -l brassicales_odb10 -o transcript -m transcriptome
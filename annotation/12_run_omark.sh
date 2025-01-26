#!/usr/bin/env bash

#SBATCH --time=05:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=8
#SBATCH --job-name=omark
#SBATCH --output=/data/users/fgribi/transcriptome_assembly/output/output_omark_%j.o
#SBATCH --error=/data/users/fgribi/transcriptome_assembly/output/error_omark_%j.e
#SBATCH --partition=pibu_el8
WORKDIR=/data/users/fgribi/transcriptome_assembly
DATADIR=$WORKDIR/data/db/
OUTDIR=$WORKDIR/output/omamer
QUERY=$WORKDIR/output/MAKER/final/assembly.all.maker.proteins.fasta.renamed.fasta

conda init bash
conda activate OMArk
module load SeqKit/2.6.1

cd $OUTDIR

omamer search --db $DATADIR/LUCA.h5 --query $QUERY --out assembly.all.maker.proteins.renamed.fasta.omamer

seqkit fx2tab $QUERY | \
awk -F '\t' '{
    # Extract the gene ID (assumes format: geneID-isoformID)
    split($1, b, " ")
    isoform_name = b[1]

    split(isoform_name, a, "-"); 
    gene = a[1];

    # Accumulate isoform names for each gene, separated by ;
    if (isoforms[gene] == "") {
        isoforms[gene] = isoform_name;  # Initialize with the first isoform
    } else {
        isoforms[gene] = isoforms[gene] ";" isoform_name;  # Append with ;
    }
} END {
    # Print all isoforms for each gene
    for (gene in isoforms) {
        print isoforms[gene];
    }
}' > $OUTDIR/protein_isoforms_list.txt

omark -f assembly.all.maker.proteins.renamed.fasta.omamer -of $QUERY -i protein_isoforms_list.txt -d $DATADIR/LUCA.h5 -o omark_output
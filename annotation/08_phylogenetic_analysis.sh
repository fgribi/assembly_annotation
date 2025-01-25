#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=05:00:00
#SBATCH --job-name=phylogeny
#SBATCH --output=/data/users/fgribi/transcriptome_assembly/output/output_phylogeny_%j.o
#SBATCH --error=/data/users/fgribi/transcriptome_assembly/output/error_phylogeny_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/fgribi/transcriptome_assembly
TEOUTPUT=$WORKDIR/output/TEsorter
IMAGE=/data/courses/assembly-annotation-course/containers2/TEsorter_1.3.0.sif
BRASS=/data/courses/assembly-annotation-course/CDS_annotation/data/Brassicaceae_repbase_all_march2019.fasta
OUTDIR=$WORKDIR/output/phylogeny

mkdir -p $OUTDIR


module load SeqKit/2.6.1
cd $TEOUTPUT

grep Ty3-RT Gypsy_sequences.fa.rexdb-plant.dom.faa > gypsy_list
sed -i 's/>//' gypsy_list
sed -i 's/ .\+//' gypsy_list 
seqkit grep -f gypsy_list Gypsy_sequences.fa.rexdb-plant.dom.faa -o Gypsy_RT.fasta

grep Ty1-RT Copia_sequences.fa.rexdb-plant.dom.faa > copia_list
sed -i 's/>//' copia_list
sed -i 's/ .\+//' copia_list 
seqkit grep -f copia_list Copia_sequences.fa.rexdb-plant.dom.faa -o Copia_RT.fasta

seqkit grep -r -p "Copia" $BRASS > $TEOUTPUT/Copia_brass_sequences.fa
seqkit grep -r -p "Gypsy" $BRASS > $TEOUTPUT/Gypsy_brass_sequences.fa

apptainer exec -C -H $WORKDIR -H ${pwd}:/work --writable-tmpfs -u $IMAGE \
 TEsorter Copia_brass_sequences.fa -db rexdb-plant

apptainer exec -C -H $WORKDIR -H ${pwd}:/work --writable-tmpfs -u $IMAGE \
 TEsorter Gypsy_brass_sequences.fa -db rexdb-plant

grep Ty3-RT Gypsy_brass_sequences.fa.rexdb-plant.dom.faa > gypsy_brass_list
sed -i 's/>//' gypsy_brass_list
sed -i 's/ .\+//' gypsy_brass_list 
seqkit grep -f gypsy_brass_list Gypsy_brass_sequences.fa.rexdb-plant.dom.faa -o Gypsy_brass_RT.fasta

grep Ty1-RT Copia_brass_sequences.fa.rexdb-plant.dom.faa > copia_brass_list
sed -i 's/>//' copia_brass_list
sed -i 's/ .\+//' copia_brass_list 
seqkit grep -f copia_brass_list Copia_brass_sequences.fa.rexdb-plant.dom.faa -o Copia_brass_RT.fasta

cat Gypsy_RT.fasta Gypsy_brass_RT.fasta > Gypsy_all_RT.fasta
cat Copia_RT.fasta Copia_brass_RT.fasta > Copia_all_RT.fasta

sed -i 's/#.\+//' Gypsy_all_RT.fasta
sed -i 's/:/_/g' Gypsy_all_RT.fasta
sed -i 's/|.\+//' Gypsy_all_RT.fasta


sed -i 's/#.\+//' Copia_all_RT.fasta
sed -i 's/:/_/g' Copia_all_RT.fasta
sed -i 's/|.\+//' Copia_all_RT.fasta

module load Clustal-Omega/1.2.4-GCC-10.3.0
clustalo  -i Gypsy_all_RT.fasta --force -o $OUTDIR/Gypsy_protein_alignment.fasta 
clustalo -i Copia_all_RT.fasta --force -o $OUTDIR/Copia_protein_alignment.fasta 

module load FastTree/2.1.11-GCCcore-10.3.0
FastTree -out $OUTDIR/Gypsy.tree $OUTDIR/Gypsy_protein_alignment.fasta
FastTree -out $OUTDIR/Copia.tree $OUTDIR/Copia_protein_alignment.fasta
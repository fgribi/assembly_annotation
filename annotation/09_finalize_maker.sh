#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem=10G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=fm
#SBATCH --output=/data/users/fgribi/transcriptome_assembly/output/output_fm_%j.o
#SBATCH --error=/data/users/fgribi/transcriptome_assembly/output/error_fm_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/fgribi/transcriptome_assembly
MAKEROUTPUT="/data/users/fgribi/transcriptome_assembly/output/MAKER"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin"
cd $MAKEROUTPUT
# $MAKERBIN/gff3_merge -s -d assembly.flye.maker.output/assembly.flye_master_datastore_index.log > assembly.all.maker.gff
# $MAKERBIN/gff3_merge -n -s -d assembly.flye.maker.output/assembly.flye_master_datastore_index.log > assembly.all.maker.noseq.gff
# $MAKERBIN/fasta_merge -d assembly.flye.maker.output/assembly.flye_master_datastore_index.log -o assembly

mkdir -p final
protein="assembly.all.maker.proteins.fasta"
transcript="assembly.all.maker.transcripts.fasta"
gff="assembly.all.maker.noseq.gff"

# cp $gff final/${gff}.renamed.gff
# cp $protein final/${protein}.renamed.fasta
# cp $transcript final/${transcript}.renamed.fasta
cd final
 
prefix="hiro"
 
# $MAKERBIN/maker_map_ids --prefix $prefix --justify 7 ${gff}.renamed.gff > id.map
# $MAKERBIN/map_gff_ids id.map ${gff}.renamed.gff
# $MAKERBIN/map_fasta_ids id.map ${protein}.renamed.fasta
# $MAKERBIN/map_fasta_ids id.map ${transcript}.renamed.fasta
# 
#  apptainer exec \
#      --bind $COURSEDIR/data/interproscan-5.70-102.0/data:/opt/interproscan/data \
#      --bind $WORKDIR \
#      --bind $COURSEDIR \
#      --bind $SCRATCH:/temp \
#      $COURSEDIR/containers/interproscan_latest.sif \
#      /opt/interproscan/interproscan.sh \
#      -appl pfam --disable-precalc -f TSV \
#      --goterms --iprlookup --seqtype p \
#      -i ${protein}.renamed.fasta -o output.iprscan

$MAKERBIN/ipr_update_gff ${gff}.renamed.gff output.iprscan > ${gff}.renamed.iprscan.gff
# perl $MAKERBIN/AED_cdf_generator.pl -b 0.025 ${gff}.renamed.gff > assembly.all.maker.renamed.gff.AED.txt

# Filter the gff file based on AED values and Pfam domains

perl $MAKERBIN/quality_filter.pl -a 0.5 ${gff}.renamed.iprscan.gff > ${gff}_iprscan_quality_filtered.gff

# In the above command: -s  Prints transcripts with an AED <1 and/or Pfam domain if in gff3 
## Note: When you do QC of your gene models, you will see that AED <1 is not sufficient. We should rather have a script with AED <0.5


# The gff also contains other features like Repeats, and match hints from different sources of evidence
# Let's see what are the different types of features in the gff file
cut -f3 ${gff}_iprscan_quality_filtered.gff | sort | uniq

# We only want to keep gene features in the third column of the gff file
grep -P "\tgene\t|\tCDS\t|\texon\t|\tfive_prime_UTR\t|\tthree_prime_UTR\t|\tmRNA\t" ${gff}_iprscan_quality_filtered.gff > filtered.genes.renamed.gff3
cut -f3 filtered.genes.renamed.gff3 | sort | uniq

# We need to add back the gff3 header to the filtered gff file so that it can be used by other tools
grep "^#" ${gff}_iprscan_quality_filtered.gff > header.txt
cat header.txt filtered.genes.renamed.gff3 > filtered.genes.renamed.final.gff3

module load UCSC-Utils/448-foss-2021a
# Get the names of remaining mRNAs and extract them from the transcript and and their proteins from the protein files
grep -P "\tmRNA\t" filtered.genes.renamed.final.gff3 | awk '{print $9}' | cut -d ';' -f1 | sed 's/ID=//g' >mRNA_list.txt
faSomeRecords ${transcript}.renamed.fasta mRNA_list.txt ${transcript}.renamed.filtered.fasta
faSomeRecords ${protein}.renamed.fasta mRNA_list.txt ${protein}.renamed.filtered.fasta
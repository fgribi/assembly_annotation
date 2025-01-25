library(circlize)
library(ape)
library(tidyr)
library(dbplyr)
library(RColorBrewer)


# setwd("path/to/data")


gff_name <- "assembly.flye.fasta.mod.EDTA.TEanno.gff3"
fai_name <- "flye.fai"
TEoutput <- "assembly.flye.fasta.mod.LTR.intact.fa.ori.dusted.rexdb-plant.cls.tsv"


df <- read.gff(gff_name, GFF3 = TRUE)
type_occurence <- sort(table(df$type), decreasing=TRUE)
names_top_te <- names(type_occurence[1:6])
tesorter_data <- read.csv2(TEoutput, header=T, sep = "\t")
clade_data <- tesorter_data[, c("X.TE", "Clade", "Superfamily")]
colnames(clade_data) <- c("ID", "Clade", "Superfamily")
clade_data$ID <- sub("#.*$", "", clade_data$ID)

crm <- clade_data %>%
  separate(ID, into = c("seqid", "position"), sep = ":") %>%  # Split by ":"
  separate(position, into = c("start", "stop"), sep = "\\.\\.") %>%
  dplyr::filter(Clade == "CRM")
  

# Convert start and stop to numeric if needed
crm$start <- as.numeric(crm$start)
crm$stop <- as.numeric(crm$stop)


fai_data <- read.table(fai_name, header = FALSE, sep = "\t")

top_scaffolds <- fai_data %>%
  dplyr::arrange(desc(V2)) %>%  
  head(15)    

ideogram_data <- data.frame(
  scaffold = top_scaffolds$V1,
  start = rep(0, nrow(top_scaffolds)),
  end = top_scaffolds$V2
)

circos.genomicInitialize(ideogram_data)

colors <- brewer.pal(6, "Set3")

te_density_data <- crm[, c("seqid", "start", "stop")]
circos.genomicDensity(te_density_data, track.height = 0.1, col  =  colors[1], window.size = 1e6)

i = 2
for (sf in names_top_te[2:6]) {
  te_data_sf <- df %>% dplyr::filter(type == sf)
  
  te_density_data <- te_data_sf[, c("seqid", "start", "end")]
  
  circos.genomicDensity(te_density_data, track.height = 0.1, col  =  colors[i], window.size = 1e6)
  i = i + 1
}
legend("bottomleft", legend = c("CRM", names_top_te[2:6]), fill = colors[1:6], 
       title = "TE Superfamilies", cex = 0.6, bty = "n")


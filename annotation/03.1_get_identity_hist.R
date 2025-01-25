library(dplyr)
library(tidyr)
library(ggplot2)

# setwd("path/to/data")

TEoutput <- "assembly.flye.fasta.mod.LTR.intact.fa.ori.dusted.rexdb-plant.cls.tsv"
LTRgff <- "assembly.flye.fasta.mod.LTR.intact.gff3"
  
tesorter_data <- read.csv2(TEoutput, header=T, sep = "\t")
clade_data <- tesorter_data[, c("X.TE", "Clade", "Superfamily")]
colnames(clade_data) <- c("ID", "Clade", "Superfamily")
clade_data$ID <- sub("#.*$", "", clade_data$ID)

gff_data <- read.table(LTRgff, header = FALSE, comment.char = "#", stringsAsFactors = FALSE)
gff_relevant <- gff_data %>%
  filter(V3 == "repeat_region") %>%  # Filter for repeat_region entries
  mutate(
    # Extract the ID from the attributes column (V9)
    ID = sub(".*?Name=([^;]+);.*", "\\1", V9),  # Extract Name for ID
    Classification = sub(".*?Classification=([^;]+);.*", "\\1", V9),  # Extract Classification
    ltr_identity = sub(".*?ltr_identity=([^;]+);.*", "\\1", V9)  # Extract ltr_identity
  ) %>%
  # Select only the columns we need
  select(ID, Classification, ltr_identity)

combined_data <- merge(clade_data, gff_relevant, by = "ID", all.x = TRUE)
combined_data$ltr_identity <- as.numeric(combined_data$ltr_identity)

ggplot(combined_data, aes(x = ltr_identity, fill = Superfamily)) +
  geom_histogram(binwidth = 0.005, color = "black", alpha = 0.7) +
  facet_wrap(~ Clade) +  # Facet by clade, allowing each plot to have its own y-axis scale
  labs(title = "Distribution of LTR Identity by Clade",
       x = "LTR Identity",
       y = "Frequency") +
  theme_minimal()

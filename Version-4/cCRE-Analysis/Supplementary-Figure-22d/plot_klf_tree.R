rm(list=ls())
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggtree)
library(ape)
library(treeio)
library(stringr)
library(tidytree)

metadata <- read.table("~/Desktop/241-mammals-metadata.txt", 
                       col.names = c("species", "common_name", "order"),
                       sep = "\t",
                       stringsAsFactors = F)

metadata <- rbind(metadata, data.frame(
  species = "Homo_sapiens",
  common_name = "Human",
  order = "PRIMATES",
  stringsAsFactors = FALSE
))

species <- metadata %>% pull(species)
species
aa_df = read.table("Downloads/KLF1-241mammals-amino-acid.txt", 
                   sep="\t",
                   stringsAsFactors = F,
                   header = F, col.names = c("species", "codon", "aa", "nuc1", "nuc2", "nuc3"))


nrow(metadata)
nrow(aa_df)

df <- metadata %>%
  left_join(aa_df, by = "species")

df <- df[!duplicated(df),]

df["codon"][is.na(df["codon"])] <- "NNN"
df["aa"][is.na(df["aa"])] <- "Unaligned"
df["nuc1"][is.na(df["nuc1"])] <- "N"
df["nuc2"][is.na(df["nuc2"])] <- "N"
df["nuc3"][is.na(df["nuc3"])] <- "N"

df %>% nrow()
tree <- read.tree("~/Downloads/241-mammalian-2020v2.phast-242.nh")
tree <- ggtree::groupOTU(tree, split(df$species, df$aa))

tree = rename_taxa(tree, df, species, common_name)


p <- ggtree(tree, layout = "circular") +
  geom_tiplab(size = 1)
  
p

p <- ggtree(tree, aes(color = group), layout="circular") +  # Add metadata to tree
  geom_tiplab(size = 2, align = T)  + 
  scale_color_discrete("Amino acid")


p

ggsave("~/Desktop/KLF-tree.pdf", width = 12, height = 12, units = "in")

colors <- c('#008000', '#0000FF', '#FFA600', '#FF0000', '#000000')
names(colors) <- c("A", "C", "G", "T", "N")

heatmap_df <- df %>% select(c(common_name, nuc1, nuc2, nuc3))
rownames(heatmap_df) <- heatmap_df$common_name
heatmap_df$common_name <- NULL
heatmap_df %>% head()

p <- ggtree(tree, aes(color = group), layout = "circular") +  # Add metadata to tree
  scale_color_discrete("Amino acid")

p <- gheatmap(p, heatmap_df, offset = 1, color=NULL, 
         colnames_position="top", width = .25,
         colnames_angle=90, colnames_offset_y = 1, 
         hjust=0, font.size=2) + 
  scale_fill_manual(values = colors)

p
# , breaks=c("A", "C", "G", "T", "N")
ggsave("~/Desktop/KLF-tree-w-nucleotides.pdf", width = 12, height = 12, units = "in")
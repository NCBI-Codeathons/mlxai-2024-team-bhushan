## This code is for the NCBI/NLM Codeathon 2024 to identify genes that are expressed in the human gut, categorize them into groups,
## and compare their expression between healthy and colons isolated from IBD patients

library(Matrix)

##Load gene expression matrix across patients
df <- read.csv("/Users/sura2/Desktop/GC_application/NCBI Codeathon/human_gene_exp_IBD.csv")
genes.list <- df$X
rownames(df) <- genes.list
write.csv(df, "/Users/sura2/Desktop/GC_application/NCBI Codeathon/human_gene_exp_IBD.csv")
rownames(df) <- df$X.1
df <- df[, -(1:2)]

##Load the metadata
meta <- read.csv("/Users/sura2/Desktop/GC_application/NCBI Codeathon/human_IBD_patient_metadata.csv")

##Now change the column names of the dataframe from patient IDs to IBD vs nonIBD
new_column_names <- sapply(colnames(df), function (id){
  col_ids <- meta[which(meta$Participant_ID == id), "Diagnosis"]
  return(col_ids)
})

##Convert the list to a character vector
new_column_names <- unlist(new_column_names)

#Replace column names of dataframe
colnames(df) <- new_column_names

##Save new dataframe
write.csv(df, "/Users/sura2/Desktop/GC_application/NCBI Codeathon/human_gene_exp_IBD_new.csv")

##Calculate mean expression for the 3 categories
##Isolate the three datasets to calculate the mean expression for each category
df.cd <- df[, which(colnames(df) == "CD")]
df.uc <- df[, which(colnames(df) == "UC")]
df.nonibd <- df[, which(colnames(df) == "nonIBD")]

##Calculate mean
df.cd$mean.exp <- rowMeans(df.cd)
df.uc$mean.exp <- rowMeans(df.uc)
df.nonibd$mean.exp <- rowMeans(df.nonibd)

##Now cbind the mean expression columns
dx <- cbind(df.cd$mean.exp, cbind(df.uc$mean.exp, df.nonibd$mean.exp))
rownames(dx) <- rownames(df)
colnames(dx) <- c("CD", "UC", "nonIBD")

##Now use this dataframe to make dotplots for specific sets of transporter genes
##Set the genes for which I will plot dotplots
abc.transporters <- grep("ABC", rownames(df), value = T)
slc.transporters <- grep("SLC", rownames(df), value = T)
aqp.transporters <- grep("AQP", rownames(df), value = T)
cyp.genes <- grep("CYP", rownames(df), value = T)
kcn.genes <- grep("KCN", rownames(df), value = T)
trpv.genes <- grep("TRPV", rownames(df), value = T)

##Now plot dotplots
##Write a function to plot the dotplot
##ABC transporters - Multidrug resistance
dx.sub <- dx[trpv.genes, ]

gene_expression_data <- dx.sub

# Transpose the dataframe for heatmap plotting
gene_expression_data <- t(gene_expression_data)

# Plot the heatmap
library(gplots)
pdf("/Users/sura2/Desktop/GC_application/NCBI Codeathon/plots/TRPV_channels_transporter_heatmap.pdf", width = 24, height = 24)
heatmap.2(as.matrix(gene_expression_data),
          dendrogram = "none",      # Add dendrogram for rows
          trace = "none",          # Remove trace
          margins = c(10,10),      # Add margins
          col = hcl.colors(256, palette = "viridis"),  # Color scheme
          main = "Gene Expression Heatmap",
          xlab = "Genes",
          ylab = "Conditions")
dev.off()

library(pheatmap)
pheatmap(as.matrix(gene_expression_data), color = , cluster_rows = F, 
         cluster_cols = F)

##Plot Table 1 genes
dx.sub <- dx[c("SLC10A2", "SLC15A1", "SLC16A1", "SLC22A1", "SLC22A2", 
               "SLC22A3", "SLC22A4", "SLC22A5", "SLC22A6", "SLC22A7", "SLC22A8", "SLC28A2", "SLC29A1", "SLC29A2", "SLC51A", 
               "SLC51B", "SLCO2B1"), ]

gene_expression_data <- dx.sub

# Transpose the dataframe for heatmap plotting
gene_expression_data <- t(gene_expression_data)

# Plot the heatmap
library(gplots)
pdf("/Users/sura2/Desktop/GC_application/NCBI Codeathon/plots/Table1_SLC_transporters_heatmap.pdf", width = 24, height = 24)
heatmap.2(as.matrix(gene_expression_data),
          dendrogram = "none",      # Add dendrogram for rows
          trace = "none",          # Remove trace
          margins = c(10,10),      # Add margins
          col = hcl.colors(256, palette = "viridis"),  # Color scheme
          main = "Gene Expression Heatmap",
          xlab = "Genes",
          ylab = "Conditions")
dev.off()

##Do a significance test to get only a few genes for each category
# Perform t-test for each gene

# Perform t-test for each gene for UC patient data
p_value_uc <- data.frame("pvalue" = sapply(rownames(gene_expression_data), function(gene) 
  t.test(gene_expression_data$nonIBD, gene_expression_data$UC)$p.value), row.names = rownames(gene_expression_data))

# Apply Bonferroni correction
num_tests <- nrow(p_value_uc)  # Number of tests (number of genes)

# Apply Bonferroni correction to the p-values
p_values_corrected <- p.adjust(p_value_uc$pvalue, method = "bonferroni", n = num_tests)

# Add the corrected p-values to the dataframe
p_values_df$corrected_p_value <- p_values_corrected

# Identify significant genes based on corrected p-values (e.g., corrected p < 0.05)
significant_genes_uc <- rownames(p_values_df)[p_values_df$corrected_p_value < 0.05]


# Perform t-test for each gene for CD patient data
p_value_cd <- data.frame("pvalue" = sapply(rownames(gene_expression_data), function(gene) 
  t.test(gene_expression_data$nonIBD, gene_expression_data$CD, paired = T)$p.value), row.names = rownames(gene_expression_data))

# Apply Bonferroni correction
num_tests <- nrow(p_value_cd)  # Number of tests (number of genes)

# Apply Bonferroni correction to the p-values
p_values_corrected <- p.adjust(p_value_cd$pvalue, method = "bonferroni", n = num_tests)

# Add the corrected p-values to the dataframe
p_values_df$corrected_p_value <- p_values_corrected

# Identify significant genes based on corrected p-values (e.g., corrected p < 0.05)
significant_genes_cd <- rownames(p_values_df)[p_values_df$corrected_p_value < 0.05]

##Get genes shared between the two conditions
gene.list <- intersect(significant_genes_cd, significant_genes_uc)


 




  

  






# ---------------------------------------------------------

# Melbourne Bioinformatics Training Program

# This exercise IS to assess your familiarity with R and git. Please follow
# the instructions on the README page and link to your repo in your application.
# If you do not link to your repo, your application will be automatically denied.

# Leave all code you used in this R script with comments as appropriate.
# Let us know if you have any questions!


# You can use the resources available on our training website for help:
# Intro to R: https://mbite.org/intro-to-r
# Version Control with Git: https://mbite.org/intro-to-git/

# ----------------------------------------------------------

# Load libraries -------------------
# You may use base R or tidyverse for this exercise

# ex. library(tidyverse)

library(tidyverse)

# Load data here ----------------------
# Load each file with a meaningful variable name.

expression <- read.csv("data/GSE60450_GeneLevel_Normalized(CPM.and.TMM)_data.csv")
metadata <- read.csv("data/GSE60450_filtered_metadata.csv")

# Inspect the data -------------------------

# What are the dimensions of each data set? (How many rows/columns in each?)
# Keep the code here for each file.

## Expression data

dim(expression)

#23735 Rows and 14 Columns

## Metadata

dim(metadata)
#12 Rows and 4 Columns

# Prepare/combine the data for plotting ------------------------
# How can you combine this data into one data.frame?

colnames(expression)[-(1:2)]
metadata$X

all(colnames(expression)[-(1:2)] %in% metadata$X)

#12 of the columns in the expression dataset match the 12 rows in metadata
#(metadata contains extra information on each of the samples in expression)
#We can merge my sample name e.g. GSM1480291 

expr_samples <- colnames(expression)[-(1:2)]  # excluding columns X and gene_symbol

#Reshaping the data
expression_long <- expression %>%
  pivot_longer(
    cols = all_of(expr_samples),
    names_to = "sample",
    values_to = "expression"
  )

combined_data <- expression_long %>%
  left_join(metadata, by = c("sample" = "X"))

# Plot the data --------------------------
## Plot the expression by cell type
## Can use boxplot() or geom_boxplot() in ggplot2

plot <- ggplot(combined_data, aes(x = immunophenotype, y = expression)) +
  geom_boxplot() +
  theme_minimal() +
  labs(
    title = "Gene Expression by Cell Type",
    x = "Cell Type",
    y = "Expression"
  )

# Display plot
print(plot)

## Save the plot
### Show code for saving the plot with ggsave() or a similar function

ggsave(
  filename = "results/expression_by_cell_type.png",
  plot = plot,
  width = 8,
  height = 6
)
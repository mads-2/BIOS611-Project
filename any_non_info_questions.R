#!/usr/bin/env Rscript

# Load libraries
library(readr)
library(dplyr)
library(tidyr)

# Load cleaned dataset
raw <- read_csv("derived_data/01_clean_data.csv")

# Check for columns where all responses are identical (ignoring NAs)
invariant_columns <- raw %>%
  summarise(across(everything(), ~ {
    vals <- unique(na.omit(.))
    if (length(vals) == 1) vals else NA
  })) %>%
  pivot_longer(cols = everything(),
               names_to = "Column",
               values_to = "ConstantResponse") %>%
  filter(!is.na(ConstantResponse))

# Print results
if (nrow(invariant_columns) == 0) {
  cat("All columns show variability in responses.\n")
} else {
  cat("The following columns have identical responses across all participants:\n")
  print(invariant_columns)
}
#The age description question has all responses '18 and more' so we can remove this question from our data set 

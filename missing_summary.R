# Load libraries
library(readr)
library(dplyr)
library(tidyr)

# Load cleaned dataset
raw <- read_csv("derived_data/01_clean_data.csv")

# Define what counts as "missing"
missing_tokens <- c(NA, "", "?", "Nil", "nil", "NIL")

# Convert everything to character for uniform checking
raw_char <- raw %>% mutate(across(everything(), as.character))

# Count missing per column
missing_summary <- raw_char %>%
  summarise(across(everything(), ~ sum(. %in% missing_tokens))) %>%
  pivot_longer(cols = everything(),
               names_to = "Column",
               values_to = "MissingCount") %>%
  arrange(desc(MissingCount))

# Print results
cat("Missing value summary per column:\n")
print(missing_summary)

# Save results to CSV for inspection
write_csv(missing_summary, "derived_data/missing_summary.csv")
cat("Summary written to derived_data/missing_summary.csv\n")

# 95 responses have missing ethnicity
# 95 responses have misisng relation (the person who submitted the survey)
# 2 responses have missing age
library(readr)
library(dplyr)

# Read normally, trimming whitespace
raw <- read_csv("source_data/Adult_Autism_Screening_UCI.csv", trim_ws = TRUE)

# Remove completely empty columns (like ...22???...41)
raw <- raw %>% select(where(~ !all(is.na(.) | . == "")))

# Replace "?" and blank strings with NA
raw <- raw %>%
  mutate(across(everything(), ~ na_if(., "?"))) %>%
  mutate(across(everything(), ~ na_if(., "")))

# Count how many rows have at least one missing value
missing_rows <- raw %>%
  mutate(row_missing = if_any(everything(), is.na)) %>%
  summarise(
    total_missing = sum(row_missing),
    total_rows = n(),
    percent_missing = 100 * total_missing / total_rows
  )

print(missing_rows)

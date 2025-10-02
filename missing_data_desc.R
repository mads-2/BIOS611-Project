library(readr)
library(dplyr)
library(janitor)
library(ggplot2)
library(tidyr)

# Load the cleaned dataset
raw <- read_csv("derived_data/01_clean_data.csv")

# summarize missing values per column
na_summary <- raw %>%
  summarise(across(everything(), ~ sum(is.na(.)))) %>%
  pivot_longer(cols = everything(),
               names_to = "column",
               values_to = "na_count") %>%
  arrange(desc(na_count))

# save summary table
write_csv(na_summary, "derived_data/missing_summary.csv")

# bar chart of missing values per column
p <- ggplot(na_summary, aes(x = reorder(column, -na_count), y = na_count)) +
  geom_col(fill = "steelblue") +
  labs(title = "Missing Values per Column",
       x = "Column",
       y = "Number of Missing Values") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# save plot
dir.create("figures", showWarnings = FALSE)
ggsave("figures/missing_values.png", plot = p, width = 8, height = 4)

# print how many rows have any missing values
# ORIGINALLY -> 379 rows with missing values
#            -> 20 columns that are blank
#NOW NONE OF THE ROWS HAVE MISSING VALUES

rows_with_na <- raw %>% filter(if_any(everything(), is.na))
cat("Rows with at least one missing value:", nrow(rows_with_na), "\n")

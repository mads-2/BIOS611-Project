setwd("project")

library(readr)
library(dplyr)
library(janitor)

# Read the raw data
raw <- read_csv("project/source_data/Adult_Autism_Screening_UCI.csv",
                trim_ws = TRUE
                )

# Data description shows:
    #There should be 704 records and 21 attributes
    #This dataset contains missing values
    #This dataset contains binary, continous, and categorical data
    # 10 behavioral questions (AQ-10 test)
    # 10 personal/demographics questions (ex. age, gender, etc)
    # 1 target label (Positive indication via AQ-10 [score >= 6])

# Print dataset dimensions
raw <- raw %>% select(where(~!all(is.na(.))))

library(janitor)
names(raw) <- janitor::clean_names(names(raw))
print(names(raw))

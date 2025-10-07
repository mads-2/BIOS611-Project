if (!grepl("project$", getwd())) {
    setwd(file.path(getwd(), "project"))
}

library(readr)
library(dplyr)
library(janitor)

# read the raw data
raw <- read_csv("source_data/Adult_Autism_Screening_UCI.csv",
                trim_ws = TRUE
                )

# data description shows:
    #there should be 704 records and 21 attributes
    #this dataset contains missing values
    #this dataset contains binary, continous, and categorical data
    # 10 behavioral questions (AQ-10 test)
    # 10 personal/demographics questions (ex. age, gender, etc)
    # 1 target label (Positive indication via AQ-10 [score >= 6])

# take out any rows where all the results are blank
raw <- raw %>% filter(if_any(everything(), ~ !is.na(.)))

#take out any columns that are blank
raw <- raw %>% select(where(~ !all(is.na(.) | . == "")))

# clean the column names -> snakecase 
    # -> lowercase with underscores
    # remove spaces, punctuation, special char
    # replace accented char with ASCII equivalent
    # ensures names are unique (adds _2, _3 if needed)
    # avoids reserved words or syntactically bad names
    
raw <- raw %>% clean_names()

# print new dimensions and column name
#cat("Rows:", nrow(raw), " Columns:", ncol(raw), "\n\n")
#print(names(raw))

raw <- raw %>% rename(
    q1 = q1_no_yes,
    q2 = q2_no_yes,
    q3 = q3_no_yes,
    q4 = q4_no_yes,
    q5 = q5_no_yes,
    q6 = q6_no_yes,
    q7 = q7_no_yes,
    q8 = q8_no_yes,
    q9 = q9_no_yes,
    q10 = q10_no_yes,
    age = age_numeric,
    gender = gender_f_m,
    ethnicity = ethnicity_white_european_latino_others_black_asian_middle_eastern_pasifika_south_asian_hispanic_turkish_others,
    jaundice = jaundice_no_yes,
    family_pdd = family_member_with_pdd_no_yes,
    country_of_res = country_of_res,
    used_app_before = used_app_before_whether_the_person_has_used_a_screening_app_before_no_yes,
    screening_score = result_final_score,
    age_desc = age_description_18_or_more,
    relation = relation_self_parent_health_care_professional_relative_others,
    pos_indicator = asd_automated_response_no_yes
)

# remove age_desc column (all values are "18 and more")
raw <- raw %>% select(-age_desc)

# make sure output folder exists
dir.create("derived_data", showWarnings = FALSE)

# save cleaned dataset
write_csv(raw, "derived_data/01_clean_data.csv")

cat("Cleaned dataset saved to derived_data/01_clean_data.csv\n")

# because only 2 responses have missing age, we can just throw these 2 out 
# --> FYI: the other questions with misisng responses are ethnicity (95) and relation(95)
# --> FYI: all other questions have valid responses
raw <- raw %>% filter(!is.na(age) & age != "" & age != "?")

# load libraries
library(readr)
library(dplyr)
library(ggplot2)
library(stringr)

# read the cleaned data
raw <- read_csv("derived_data/01_clean_data.csv")

# --- 1. convert categorical variables to numeric dummy codes ---
# we only care about the question columns here but keeping this for consistency
demo_numeric <- raw %>%
  mutate(across(where(is.character), ~ as.numeric(as.factor(.))))

# --- 2. select only the aq-10 question columns ---
q_data <- demo_numeric %>%
  select(q1:q10)

# --- 3. compute correlations ---
# pairwise deletion makes sure we skip missing values only where needed
corr_matrix <- cor(q_data, use = "pairwise.complete.obs")

# --- 4. convert to tidy format for plotting ---
corr_df <- as.data.frame(as.table(corr_matrix))
names(corr_df) <- c("var1", "var2", "correlation")

# drop the diagonal and keep only one direction
var_levels <- colnames(corr_matrix)
corr_df <- corr_df %>%
  mutate(
    var1 = factor(var1, levels = var_levels),
    var2 = factor(var2, levels = var_levels)
  ) %>%
  filter(as.numeric(var1) < as.numeric(var2))

# --- 5. set label colors based on correlation strength ---
corr_df <- corr_df %>%
  mutate(label_color = ifelse(correlation > 0.25, "white", "black"))

# --- 6. plot correlation heatmap ---
# blue = positive correlation, red = negative, white = none
ggplot(corr_df, aes(x = var1, y = var2, fill = correlation)) +
  geom_tile(color = "white") +
  geom_text(aes(label = sprintf("%.2f", correlation), color = label_color), size = 3) +
  scale_color_identity() +
  scale_fill_gradient2(low = "red", mid = "white", high = "blue", midpoint = 0) +
  theme_minimal() +
  labs(title = "Correlations Among AQ-10 Question Responses",
       subtitle = "pairwise deletion used (missing values skipped per variable)",
       x = NULL, y = NULL) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


#---FORMAT--------------------------------------
#q#: category (+ ASD indicator response here)
# question goes here 
#-----------------------------------------------

#q1: attention to detail (agree)
# I often notice small sounds when others do not (

#q2: attention to detail (disagree)
# I usually concentrate more on the whole picture, rather than the small details

#q3: attention switching (disagree)
# I find it easy to do more than one thing at once

#q4: attention switching (disagree)
# If there is an interruption, I can switch back to what I was doing very quickly

#q5: communication (disagree)
# I find it easy to "read between the lines" when someone is talking to me

#q6: communication (disagree)
# I know how to tell if someone listening to me is getting bored

#q7: imagination (agree)
# When I'm reading a story I find it difficult to work out the characters' intentions

#q8: imagination (agree)
# I like to collect information about categories of things (e.g. types of car, types of bird, types of train, types of plants) 

#q9: social interaction (disagree)
# I find it easy to work out what someone is thinking or feeling just by looking at their face

#q10: social interaction (agree)
# I find it difficult to work out peoples intentions

#AQ-10 Questions with the largest magnitude of correlation (biggest to smallest) 
# --> q9 & q6 (0.48)
#         I supposed "boredom" also has a face and it is a feeling
# --> q4 & q3 (0.41)
#         Being able to get back to work soon after interruptions and being abble to juggle multiple tasks at once seem similar
# --> q5 & q9 (0.40)
#         "reading between the lines" is involved when interpreting facial expression 
# --> q6 & q5 (0.39)
#         I guess "reading between the lines" is needed to tell when someone is bored as people often do not directly tell you


#AQ-10 Questions with the smallest magnitude of correlation (biggest to smallest) 
# --> q4 & q8
#        liking categories of information and being able to work well with interruptiosn seem uncorrelated
# --> q3 & q8
#        liking categories of information and multitasking also seem uncorrelated
# --> q2 & q1 
#       though both in the same category (attention to detail), these two response (one about sound and the other more about thinking style) address distinct areas of functioning
         

#q8 is the least correlated question all around 




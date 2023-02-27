##### Load libraries #####
library(tidyverse)
library(readr)
library(janitor)

##### Fetch data #####
full_theorists <- read_csv("https://raw.githubusercontent.com/theory-in-dh/conceptual_forays/main/data/4_theorystrings_humans_extended_withcategories.csv")
found_theorists <- read_csv("https://raw.githubusercontent.com/theory-in-dh/conceptual_forays/main/data/reference.theorists.full.csv")

##### Clean column names #####
full_theorists <- clean_names(full_theorists)
found_theorists <- clean_names(found_theorists)
theorists <- left_join(found_theorists, full_theorists, by = c("keyword" = "item_label"))

##### Explore distinct genders #####
theorists %>% 
  distinct(q_id, .keep_all = TRUE) %>% # eliminates duplicates (! remember: there are some persons that appear more than once)
  count(sex_gender, sort = T)

theorists %>% 
  distinct(q_id, .keep_all = TRUE) %>%
  count(country_citizenship, sort = T)

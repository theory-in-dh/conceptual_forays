##### Load libraries #####
library(tidyverse)
library(readr)
library(janitor)

##### Fetch data #####
data <- read_csv("1_data/4_theory_dictionary_wikidata_extended.csv")
##### Clean column names #####
data <- clean_names(data)
data
##### Explore distinct genders #####
data %>% 
  distinct(wikidata_id, .keep_all = TRUE) %>% # eliminates duplicates (! remember: there are some persons that appear more than once)
  count(sex_or_gender)

data %>% 
  distinct(wikidata_id, .keep_all = TRUE) %>%
  count(country_of_citizenship, sort = T)

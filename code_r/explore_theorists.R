#load packages
library(tidyverse)
library(readr)
library(janitor)

# fetch data
data <- read_csv("data_reconciliation/theory_dictionary_wikidata_extended.csv")
#normalize column names
data <- clean_names(data)
data
#explore distinct genders 
data %>% 
  distinct(wikidata_id, .keep_all = TRUE) %>% # eliminates duplicates (! remember: there are some persons that appear more than once)
  count(sex_or_gender)

data %>% 
  distinct(wikidata_id, .keep_all = TRUE) %>%
  count(country_of_citizenship, sort = T)

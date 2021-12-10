#load packages
library(tidyverse)
library(readr)
library(janitor)


humanscat <- read_csv("4_data_reconciliation/theorystrings_categories_humans.csv")
humansenriched <- read_csv("5_data_enrichment/theorystrings_categories_humans_extended.csv")
humansenrichedcomplete <- humanscat %>% 
  right_join(humansenriched, by = "itemLabel")

write_csv(humansenrichedcomplete, "5_data_enrichment/theorystrings_categories_humans_extended_complete.csv")

# fetch data
data <- read_csv("5_data_enrichment/theory_dictionary_wikidata_extended.csv")
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

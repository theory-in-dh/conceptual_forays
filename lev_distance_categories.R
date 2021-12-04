library(tidyverse)
library(readr)
library(RecordLinkage)

categories_wikipedia <- read_csv("categories_wikipedia.csv")
categories_wikipedia <- categories_wikipedia %>% 
  mutate(levsim = purrr::map2(categories_wikipedia$category, categories_wikipedia$query_string, levenshteinSim))

df <- tibble(
  query_string = categories_wikipedia$query_string,
  category = categories_wikipedia$category,
  levsim = unlist(categories_wikipedia$levsim),
  pageid = categories_wikipedia$pageid,
  timestamp = categories_wikipedia$timestamp,
  snippet = categories_wikipedia$snippet,
  wordcount = categories_wikipedia$wordcount,

)

write_csv(df, "categories_wikipedia_levdistance.csv")

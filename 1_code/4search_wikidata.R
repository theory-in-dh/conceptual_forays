##### Load libraries #####
library(tidyverse)

##### Load function #####

#Taken from: https://github.com/wikimedia/WikidataQueryServiceR/issues/12
querki <- function(query,h="text/csv") {
  require(httr)
  response <- httr::GET(url = "https://query.wikidata.org/sparql", 
                        query = list(query = query),
                        httr::add_headers(Accept = h))
  return(httr::content(response))
}

##### Create query (search humans inside a Wikipedia category) #####
#Adapted from: https://github.com/lubianat/topictagger/blob/master/titlematch/utils.R
cat_query <- function(category){
  cat_query <- paste0('SELECT ?item ?itemLabel WHERE {
  BIND("', category, '" as ?category)
  SERVICE wikibase:mwapi {
     bd:serviceParam wikibase:endpoint "en.wikipedia.org";
                     wikibase:api "Generator";
                     mwapi:generator "categorymembers";
                     mwapi:gcmtitle ?category.
     ?item wikibase:apiOutputItem mwapi:item.
  } 
  FILTER BOUND (?item)
  FILTER EXISTS {
    ?article schema:about ?item .
    ?item wdt:P31 wd:Q5.
  }
SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }    
}
')
  return(cat_query)
}


##### Load data ######

data <- readr::read_csv("1_data/3_wikicategories_distances_filtered.csv")


###### Apply query & create data frame ####
queries_titles <- unique(data$title)
queries <- purrr::map(queries_titles, .f=cat_query)

df <- tibble(
  category = queries_titles,
  data = purrr::map(queries, .f=querki))

###### Unnest data ####
df <- df %>% 
  unnest(data)

###### Export to csv #####
write_csv(df, "1_data/4_theorystrings_categories_humans.csv")
#df <- read_csv("1_data/4_theorystrings_categories_humans.csv")
names(df)

###### Unique humans (2219) #####
df_unique <- df %>%
  distinct(itemLabel, .keep_all = TRUE) %>% 
  select(-category)

###### Write csv with unique human items #####
write_csv(df_unique, "1_data/4_theorystrings_categories_humans_unique.csv")

#### Enrich Wikidata items with reconciliation in OpenRefine ####
#1. Use 1_data/4_categories_humans_transformations.json to get same transformations
#2. For more information on the reconciliation process see: https://wikidata.reconci.link/en/api
#3. Resulting csv: "1_data/4_theorystrings_humans_extended.csv"

##### Add categories to enriched/extended Wikidata items

humanscat <- df
humansenriched <- read_csv("1_data/4_theorystrings_humans_extended.csv")
humansenrichedcomplete <- humanscat %>% 
  right_join(humansenriched, by = c("itemLabel", "item"))

write_csv(humansenrichedcomplete, "1_data/4_theorystrings_humans_extended_withcategories.csv")

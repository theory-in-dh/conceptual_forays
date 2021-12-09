library(tidyverse)

##### Functions #####

#Taken from: https://github.com/wikimedia/WikidataQueryServiceR/issues/12
querki <- function(query,h="text/csv") {
  require(httr)
  response <- httr::GET(url = "https://query.wikidata.org/sparql", 
                        query = list(query = query),
                        httr::add_headers(Accept = h))
  return(httr::content(response))
}

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

data <- readr::read_csv("wikicategories_distances_filtered.csv")


###### Apply query & create data frame ####
queries_titles <- unique(data$title)
queries <- purrr::map(queries_titles, .f=cat_query)

df <- tibble(
  category = queries_titles,
  data = purrr::map(queries, .f=querki))

###### Unnest data ####
df <- df %>% 
  unnest(data)

###### Export to csv ####
write_csv(df, "theory_categories_humans.csv")

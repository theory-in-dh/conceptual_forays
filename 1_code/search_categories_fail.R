library(WikidataQueryServiceR)
library(tidyverse)

data <- readr::read_csv("https://raw.githubusercontent.com/eisioriginal/conceptual_forays/silvia-test-bed/data_api_queries/wikicategories_distances_filtered.csv")
data$title

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

#Works OK:
WikidataQueryServiceR::query_wikidata(cat_query("Category:Literary criticism"))
#cat_query(data$title[11])

#R dies cuz this category does not have any humans inside of it:
WikidataQueryServiceR::query_wikidata(cat_query("Category:Axioms of set theory"))


WikidataQueryServiceR::query_wikidata('SELECT ?item ?itemLabel WHERE {
  BIND("Category:Axioms of set theory" as ?category)
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


#Test Wikidata Query
russian_formalists <- WikidataQueryServiceR::query_wikidata('SELECT ?item ?itemLabel WHERE {
  BIND("Category:Russian_formalism" as ?category)
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


library(stringr)
library(httr)
library(WikidataQueryServiceR)
library(stringi)
library(urltools)

query <- function(category){
  query <- paste0( 'SELECT ?item ?itemLabel WHERE {
  BIND("', category,'" as ?category)
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
}')
  return(query)
}

WikidataQueryServiceR::query_wikidata(query("Health effects of alcohol"))

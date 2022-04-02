#### Read packages #### 
library(readr)
library(tidyverse)
library(janitor)

##### Review data in OpenRefine - see data/1_theoryoftransformations.json & data/1_theor_of_normalized.csv

#### Read data & clean column names #### 
jjtheory <- read_csv("1_data/1_JJ_theor_.csv")
nntheory <- read_csv("1_data/1_NN_theor_.csv")
theory <- read_csv("1_data/1_theor_of_normalized.csv")
jjtheory <- clean_names(jjtheory)#549
nntheory <- clean_names(nntheory)#434
theory <- clean_names(theory)#3,376

#### Join all "theories of" strings #### 
theoriesof <- full_join(theory, jjtheory, by = c("normalized_string" = "clustered_jj_theor"))%>%
  full_join(., nntheory, by=c("normalized_string" = "clustered_nn_theor")) %>% 
  unite("freq", freq:token_count.y, sep = "", remove = T, na.rm = T) %>% 
  select(-query_string, -x)

theoriesof %>% 
  count(normalized_string, sort = T)
#### Filter unique "theories of" strings #### 
unique_theoriesof <- dplyr::distinct(theoriesof, normalized_string)

#### Write csv with unique "theor* of" strings #### 
write_csv(unique_theoriesof, "1_data/1_theoriesof_complete.csv")

#### Compare different "theor* of" sets #### 
myl <- list(A = jjtheory$clustered_jj_theor,
            B = nntheory$clustered_nn_theor,
            C = theory$normalized_string)
differences <- lapply(1:length(myl), function(n) setdiff(myl[[n]], unlist(myl[-n])))


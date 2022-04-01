library(readr)
library(tidyverse)
library(janitor)
jjtheory <- read_csv("data/JJ_theor_.csv")
nntheory <- read_csv("data/NN_theor_.csv")
theory <- read_csv("data_normalization/theor_of_normalized.csv")
jjtheory <- clean_names(jjtheory)
nntheory <- clean_names(nntheory)
theory <- clean_names(theory)

theoriesof <- full_join(theory, jjtheory, by = c("normalized_string" = "clustered_jj_theor"))%>%
  full_join(., nntheory, by=c("normalized_string" = "clustered_nn_theor")) %>% 
  unite("freq", freq:token_count.y, sep = "", remove = T, na.rm = T) %>% 
  select(-query_string, -x)

unique_theoriesof <- dplyr::distinct(theoriesof, normalized_string)
write_csv(unique_theoriesof, "data/theoriesof_complete.csv")

myl <- list(A = jjtheory$clustered_jj_theor,
            B = nntheory$clustered_nn_theor,
            C = theory$normalized_string)
differences <- lapply(1:length(myl), function(n) setdiff(myl[[n]], unlist(myl[-n])))


#setdiff(nntheory$clustered_nn_theor, unique_theoriesof$normalized_string)

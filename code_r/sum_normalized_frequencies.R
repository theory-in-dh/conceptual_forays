library(readr)
library(tidyverse)
theory <- read_csv("data_normalization/theor_of_normalized.csv")
names(theory)

normalized_theory <- theory %>% group_by(normalized_string) %>% mutate(total_freq = sum(freq)) %>% unique()

write_csv(normalized_theory, "theor_of_normalized_freq.csv")

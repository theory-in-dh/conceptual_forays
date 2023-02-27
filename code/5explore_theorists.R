##### Load libraries #####
library(tidyverse)
library(readr)
library(janitor)
library(lubridate)

##### Fetch data #####
full_theorists <- read_csv("https://raw.githubusercontent.com/theory-in-dh/conceptual_forays/main/data/4_theorystrings_humans_extended_withcategories.csv")
found_theorists <- read_csv("https://raw.githubusercontent.com/theory-in-dh/conceptual_forays/main/data/reference.theorists.full.csv")

##### Clean column names #####
full_theorists <- clean_names(full_theorists)
found_theorists <- clean_names(found_theorists)
theorists <- left_join(found_theorists, full_theorists, by = c("keyword" = "item_label"))

##### Filter unique appearances #####
theorists <- theorists %>% 
  distinct(q_id, .keep_all = TRUE)  # eliminates duplicates (! remember: there are some persons that appear more than once)

##### Model dates #####
theorists <- theorists %>% 
  mutate(date_of_birth = lubridate::ymd_hms(theorists$date_of_birth)) %>% 
  mutate(years = year(date_of_birth)) %>% 
  mutate(decade = year(floor_date(date_of_birth, years(10))))

##### Explore different statistics #####
theorists %>% 
  count(sex_gender, sort = T)

theorists %>% 
  count(country_citizenship, sort = T)

theorists %>% 
  count(decade, sort = T)

##### Explore generation #####

theorists %>% 
  filter(years > 1964, years < 1981) #10 Generation X
1000/216


#40 Boomers Genearation
theorists %>% 
  filter(years > 1945, years < 1965) %>% 
  count(country_citizenship, sort = T) %>% 
  filter(str_detect(country_citizenship, "United Kingdom"))
700/40
4000/216

#55 Silent Genearation
theorists %>% 
  filter(years > 1927, years < 1946)%>% 
  count(country_citizenship, sort = T) #%>% 
  #filter(str_detect(country_citizenship, "Fran"))
900/55
2300/55
5500/216

# 35 Greatest Genearation
theorists %>% 
  filter(years > 1900, years < 1927)
3500/216 #16.2

# 19 Lost Genearation
theorists %>% 
  filter(years > 1882, years < 1901)
1900/216 #8.7%

#Other generations pre 1883
theorists %>% 
  filter(years < 1883) %>% 
  count(years) %>% 
  View()

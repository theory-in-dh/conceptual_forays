#### Upload packages ####
library(tidyverse)
library(readr)
library(stringdist)
library(wordcloud)
#### Read categories retrieved from matching with "theory of" strings ####

categories_wikipedia <- read_csv("../data/2_wikipediacategoriesfromquery.csv")
names(categories_wikipedia)
length(unique(categories_wikipedia$title)) #1266
length(unique(categories_wikipedia$query_string)) #1529

#### Count number of categories by each "theory of" string ####
catcountbystring<- categories_wikipedia %>%
  group_by(query_string) %>%
  summarise(count = n_distinct(title))

#### Create histogram of number of categories by string query (mf cont: 10 categories per query) ####
ggplot(catcountbystring) +
  aes(x = count) +
  geom_histogram(bins = 30L, fill = "#112446") +
  labs(
    title = "Histogram of dif. categories retrieved by query string",
    caption = "By Silvia Gutiérrez"
  ) +
  theme_minimal()


#### Delete "Category:" string to match and compare with query string ####
categories_wikipedia <- categories_wikipedia %>% 
  mutate(category = stringr::str_replace_all(categories_wikipedia$title, "Category:", ""))

#### Calculate jac distance ####
categories_wikipedia_distances <- categories_wikipedia %>% 
  mutate(jac = purrr::map2(.x= categories_wikipedia$category, .y= categories_wikipedia$query_string,  ~  stringdist(.x, .y, method = "jaccard", q=3)),
         lev = purrr::map2(.x= categories_wikipedia$category, .y= categories_wikipedia$query_string,  ~  stringdist(.x, .y, method = "lv")))

categories_wikipedia_distances <- categories_wikipedia_distances %>% 
  mutate(jac = unlist(jac),
         lev = unlist(lev))

cat_count <- categories_wikipedia_distances %>% 
  count(category)
#### Data exploration #### 
##### Categories wordcloud ##### 
set.seed(1234)
wordcloud::wordcloud(words = cat_count$category, freq = cat_count$n, min.freq = 5,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

##### Terms wordcloud ##### 
swen <- tibble(words = stopwords::stopwords("en", source = "snowball"))
cat_count_words <- cat_count %>% 
  tidytext::unnest_tokens(words, category) %>% 
  anti_join(swen)
wordcloud(words = cat_count_words$words, freq = cat_count_words$n, min.freq = 30,
          max.words=100, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(4, "Dark2"))

#### Filter categories #### 

##### Filter by jac dist ##### 
df <- categories_wikipedia_distances %>% 
  filter(jac < 0.6)

##### Filter by strange kw found in wordcloud ##### 
df <- categories_wikipedia_distances %>% 
  filter(jac < 0.6,
         !grepl('WikiProject|Wikipedia|[C|c]onspiracy|Christ|[M|m]ilitary|articles|journals|missing|Satanic|[T|t]errorism|abuse|backlog|Lists|albums', category),
         !grepl('[C|c]onspiracy|[T|t]elevision|Nazis', snippet))


#### Explore results with wordcloud #### 

df_words_count <- df %>%
  select(category) %>% 
  tidytext::unnest_tokens(words, category) %>% 
  anti_join(swen) %>% 
  count(words)

wordcloud(words = df_words_count$words, freq = df_words_count$n, scale =c(4,1), min.freq = 1,
          max.words=100, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))


write_csv(df, "1_data/3_wikicategories_distances_filtered.csv")
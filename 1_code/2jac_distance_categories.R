library(tidyverse)
library(readr)
#https://journal.r-project.org/archive/2014-1/loo.pdf
#install.packages("stringdist")
library(stringdist)
#install.packages("wordcloud")
library(wordcloud)
theoriesof <- read_csv("data_normalization/theor_of_normalized_unique.csv") 
categories_wikipedia <- read_csv("data_api_queries/categories_wikipedia.csv")
length(unique(categories_wikipedia$title))
length(unique(categories_wikipedia$query_string))

title_count <- categories_wikipedia %>% 
  count(title)
esquisse::esquisser(category_count)
ggplot(category_count) +
  aes(x = count) +
  geom_histogram(bins = 30L, fill = "#112446") +
  labs(
    title = "Histogram of dif. categories retrieved by query string",
    caption = "By Silvia Gutiérrez"
  ) +
  theme_minimal()

category_count <- categories_wikipedia %>%
  group_by(query_string) %>%
  summarise(count = n_distinct(title))

categories_wikipedia <- categories_wikipedia %>% 
  mutate(category = stringr::str_replace_all(categories_wikipedia$title, "Category:", ""))
categories_wikipedia_distances <- categories_wikipedia %>% 
  mutate(jac = purrr::map2(.x= categories_wikipedia$category, .y= categories_wikipedia$query_string,  ~  stringdist(.x, .y, method = "jaccard", q=3)),
         lev = purrr::map2(.x= categories_wikipedia$category, .y= categories_wikipedia$query_string,  ~  stringdist(.x, .y, method = "lv")))
categories_wikipedia_distances <- categories_wikipedia_distances %>% 
  mutate(jac = unlist(jac),
         lev = unlist(lev))


#### Categories wordcloud
library(wordcloud)
set.seed(1234)
wordcloud(words = cat_count$category, freq = cat_count$n, min.freq = 5,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

#### Words wordcloud
swen <- tibble(words = stopwords::stopwords("en", source = "snowball"))

cat_count_words <- cat_count %>% 
  tidytext::unnest_tokens(words, category) %>% 
  anti_join(swen)

wordcloud(words = cat_count_words$words, freq = cat_count_words$n, min.freq = 30,
          max.words=100, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(4, "Dark2"))

df <- categories_wikipedia_distances %>% 
  filter(jac < 0.6)

length(unique(df$query_string))
df <- categories_wikipedia_distances %>% 
  filter(jac < 0.6,
         !grepl('WikiProject|Wikipedia|[C|c]onspiracy|Christ|[M|m]ilitary|articles|journals|missing|Satanic|[T|t]errorism|abuse|backlog|Lists|albums', category),
         !grepl('[C|c]onspiracy|[T|t]elevision|Nazis', snippet))

df_words_count <- df %>%
  select(category) %>% 
  tidytext::unnest_tokens(words, category) %>% 
  anti_join(swen) %>% 
  count(words)

wordcloud(words = df_words_count$words, freq = df_words_count$n, min.freq = 1,
          max.words=100, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

write_csv(df, "data_api_queries/wikicategories_distances_filtered.csv")

humans <- read_csv("data_api_queries/theory_categories_humans.csv")

humans_jac06 <- left_join(df, humans, by = c("title" = "category"))

humans_jac06 <- humans_jac06 %>% 
  select(-...1,-ns) %>% 
  rename(category_title = title,
         wikidata_url = item,
         wikidata_entity = itemLabel)

write_csv(humans_jac06, "data_api_queries/theory_categories_humans_smalljacdistance.csv")

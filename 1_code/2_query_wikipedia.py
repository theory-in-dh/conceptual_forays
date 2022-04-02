#### Import libraries
import requests
import pandas as pd
import os

#### Get file with all "theory of strings"
string_filename = "1_data/1_theoriesof_complete.csv"

#### Get file with all "theory of strings" and read it with pandas
df = pd.read_csv(string_filename)
df

#### Get all strings and read them as a list
query_strings = df["normalized_string"].values.tolist()

#### Create empty dataframe to save query results
all_results_df = pd.DataFrame()

#### Run query and save results in df
for query_string in query_strings:
    url = f"https://en.wikipedia.org/w/api.php?action=query&format=json&list=search&utf8=1&srsearch={query_string}&srnamespace=14"
    #url = f"https://en.wikipedia.org/w/api.php?action=query&format=json&list=search&utf8=1&srsearch=intitle:{query_string}&srnamespace=14"
    r = requests.get(url)
    search_results = r.json()['query']['search']
    new_df = pd.DataFrame(search_results)
    new_df['query_string'] = query_string
    all_results_df = all_results_df.append(new_df)
    for result in search_results:
        print(result)

print(all_results_df)

#### Create column "title" with category name without "Category:" string
all_results_df["category"] = all_results_df["title"].str.split("Category:").apply(lambda l: l[1])

#### Save results in csv
all_results_df.to_csv("1_data/2_wikipediacategoriesfromquery.csv")

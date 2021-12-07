from difflib import SequenceMatcher
import pandas as pd

#read file
string_filename = "data_api_queries/categories_wikipedia_levdistance.csv"
df = pd.read_csv(string_filename)

#function to compare two strings
def similar(a, b):
    return SequenceMatcher(None, a, b).ratio()

#test function
similar("apple", "mango")

#create function to compare two specific columns by row
def similarcolumns(row):
  return similar(row["query_string"], row["category"])
  
df["similarity"] = df.apply(similarcolumns, axis = 1)




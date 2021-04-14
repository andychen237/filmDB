Andy Chen, achen93
Curtis Nishimoto, cnishim1

The Keyword table was removed from the database because after doing queries related to most frequent
keywords per decade and also per genre, most keywords were not particularly insightful and were very
generic keywords like "relationship" or "comedy", which did not bring much insight to trends, especially
given the limited range of keyword representation and film representation within the keywords in the data.
Thus, most queries are focused on answering questions regarding shooting location, budget, actors, genres, etc. 

All queries have the results (or a preview of them) commented for record keeping. Some of the budget/revenue
data was incorrect, but to prevent having to manually check 10,000 entries in the data, anomalies were filtered
out using the WHERE clause to constrain the results to more suitable and sensible ones. 

The insertions/deletions in updates.sql were done to demonstrate most possible scenarios and how the DB will handle 
these possibilities. (This file should be ran with the original data, not the test data.)

Lastly, the files from last time have been cleaned and/or modified as queries were done, as some results produced
unexpected and weird outputs, which prompted reinspection of some files and necessary fixes. In particular, the modified
files are starring.txt and movie.txt, and the files have been resubmitted to Gradescope and can also be accessed on this
Drive link: https://drive.google.com/drive/u/0/folders/1e6LrE2GAzsHV76WB7teKk-626z1r2agZ

Make sure to use person_condensed.txt as this reduced the original person.txt by a couple million tuples to only
represent people of interest that are in Starring and DirectedBy (which reduced import time from ~30 mins to ~5 mins).
Also, there were issues found using the .txt files on Mac, but changing the extension to .csv and removing '\r' 
from LINES TERMINATED BY fixed this problem. Otherwise, the .txt files should work fine on Windows, and both instances 
have been tested.
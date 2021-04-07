Andy Chen, achen93
Curtis Nishimoto, cnishim1

NOTE: Larger files were too big to upload to Gradescope or took >10 mins to upload 
so they were uploaded on Drive here:
https://drive.google.com/drive/folders/1e6LrE2GAzsHV76WB7teKk-626z1r2agZ?usp=sharing

Data cleaning was pretty tough because of the size of the datasets,
which made it hard to process (for example, geocoding the shooting locations of
300k tuples took three days to finish, and some datasets were on the scale of millions). 
Also error handling in SQL was tough since little details were important to keep in mind 
(f.e., NULL, NaN, or blank values were interpretted as strings so error messages arose 
if they were loaded in as any type besides chars; return values also converted
fields into strings, etc), so this took quite a bit of time debugging.
Thankfully evenutally everything was miraculously able to loaded into SQL (at 30 mins time)
and most of the warnings were duplicates/foreign key restraints, which were easily fixable and didn't require meticulously
parsing through the data to find the exact row of some odd error.

Future concerns involve the speed and plausibility of certain queries, particularly
those that involve joins. But thankfully the barrier of actually getting the data in was dealt with, and we'd
likely try to figure out a way to filter out what we're joining so the joins are at their most minimal.
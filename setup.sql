-- Andy Chen achen93
-- Curtis Nishimoto cnishim1

CREATE TABLE Movie (
  movieID   VARCHAR(15),
  title     VARCHAR(300),
  year      INT,
  runtime   INT,
  budget    DECIMAL(19,4),
  revenue   DECIMAL(19,4),
  budget_adj    DECIMAL(19,4),
  revenue_adj   DECIMAL(19,4),
  PRIMARY KEY(movieID)
);

LOAD DATA LOCAL INFILE 'C:/Users/andyc/Documents/Johns Hopkins/Spring 2021/Databases/project/filmDB/movie.txt' INTO TABLE Movie
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

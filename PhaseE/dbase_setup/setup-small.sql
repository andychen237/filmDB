-- Andy Chen, achen93
-- Curtis Nishimoto, cnishim1

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

CREATE TABLE Genre (
  movieID   VARCHAR(15),
  genre     VARCHAR(100),
  PRIMARY KEY (movieID, genre),
  FOREIGN KEY (movieID) REFERENCES Movie(movieID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ShootingLocation (
  movieID   VARCHAR(15),
  locationListing  VARCHAR(500),
  rawAddress  VARCHAR(500),
  city      VARCHAR(100),
  state     VARCHAR(100),
  country   VARCHAR(100),
  PRIMARY KEY(movieID, locationListing, rawAddress, city, state, country),
  FOREIGN KEY(movieID) REFERENCES Movie(movieID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Person (
  personID  VARCHAR(15),
  name      VARCHAR(200),
  birthYear  INT,
  PRIMARY KEY(personID)
);

CREATE TABLE DirectedBy (
  movieID   VARCHAR(15),
  personID  VARCHAR(15),
  PRIMARY KEY(movieID, personID),
  FOREIGN KEY(movieID) REFERENCES Movie(movieID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(personID) REFERENCES Person(personID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Starring (
  movieID   VARCHAR(15),
  personID  VARCHAR(15),
  role      VARCHAR(200),
  PRIMARY KEY(movieID, personID, role),
  FOREIGN KEY (movieID) REFERENCES Movie(movieID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (personID) REFERENCES Person(personID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Ranking (
  movieID   VARCHAR(15),
  rank      INT,
  PRIMARY KEY(movieID, rank),
  FOREIGN KEY(movieID) REFERENCES Movie(movieID) ON DELETE CASCADE ON UPDATE CASCADE
);

LOAD DATA LOCAL INFILE 'C:/Users/andyc/Documents/Johns Hopkins/Spring 2021/Databases/project/filmDB/finaldata/movie-small.txt' INTO TABLE Movie
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/andyc/Documents/Johns Hopkins/Spring 2021/Databases/project/filmDB/finaldata/genre-small.txt' INTO TABLE Genre
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/andyc/Documents/Johns Hopkins/Spring 2021/Databases/project/filmDB/finaldata/person-small.txt' INTO TABLE Person
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/andyc/Documents/Johns Hopkins/Spring 2021/Databases/project/filmDB/finaldata/directedby-small.txt' INTO TABLE DirectedBy
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/andyc/Documents/Johns Hopkins/Spring 2021/Databases/project/filmDB/finaldata/starring-small.txt' INTO TABLE Starring
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/andyc/Documents/Johns Hopkins/Spring 2021/Databases/project/filmDB/finaldata/shootinglocation-small.txt' INTO TABLE ShootingLocation
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/andyc/Documents/Johns Hopkins/Spring 2021/Databases/project/filmDB/finaldata/ranking-small.txt' INTO TABLE Ranking
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
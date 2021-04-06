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

CREATE TABLE Genre (
  movieID   VARCHAR(15),
  genre     VARCHAR(100),
  PRIMARY KEY (genre, movieID),
  FOREIGN KEY (movieID) REFERENCES Movie(movieID)
);

CREATE TABLE Keyword (
  movieID   VARCHAR(15),
  keyword   VARCHAR(100),
  PRIMARY KEY(keyword, movieID),
  FOREIGN KEY(movieID) REFERENCES Movie(movieID)
);

CREATE TABLE ShootingLocation (
  movieID   VARCHAR(15),
  address   VARCHAR(500),
  city      VARCHAR(100),
  state     VARCHAR(100),
  country   VARCHAR(100),
  PRIMARY KEY(movieID, address, city, state, country),
  FOREIGN KEY(movieID) REFERENCES Movie(movieID)
);

CREATE TABLE Person (
  personID  VARCHAR(15),
  name      VARCHAR(200),
  birthday  DATE,
  PRIMARY KEY(personID)
);

CREATE TABLE DirectedBy (
  personID  VARCHAR(15),
  movieID   VARCHAR(15),
  name      VARCHAR(200),
  PRIMARY KEY(personID, movieID),
  FOREIGN KEY(personID) REFERENCES Person(personID),
  FOREIGN KEY(movieID) REFERENCES Movie(movieID),
  FOREIGN KEY(name) REFERENCES Person(name)
);

CREATE TABLE Starring (
  personID  VARCHAR(15),
  movieID   VARCHAR(15),
  name      VARCHAR(200),
  role      VARCHAR(200),
  PRIMARY KEY(personID, movieID, role),
  FOREIGN KEY(personID) REFERENCES Person(personID),
  FOREIGN KEY(movieID) REFERENCES Movie(movieID),
  FOREIGN KEY(name) REFERENCES Person(name)
);

  

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
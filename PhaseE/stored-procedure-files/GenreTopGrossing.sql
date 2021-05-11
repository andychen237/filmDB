DELIMITER //

DROP PROCEDURE IF EXISTS GenreTopGrossing //

CREATE PROCEDURE GenreTopGrossing(IN inputGenre VARCHAR(60))
BEGIN
	WITH foundGenre AS (SELECT movieID
	     FROM Genre
	     WHERE genre = inputGenre)
        SELECT title, year, revenue, revenue_adj
        FROM Movie JOIN foundGenre ON Movie.movieID = foundGenre.movieID
        WHERE revenue IS NOT NULL AND revenue_adj IS NOT NULL
        ORDER BY revenue_adj desc
        LIMIT 5;
END; //

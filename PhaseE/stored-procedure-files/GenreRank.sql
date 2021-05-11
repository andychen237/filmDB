-- GenreRank.sql

DELIMITER //

DROP PROCEDURE IF EXISTS GenreRank //

CREATE PROCEDURE GenreRank(IN inGenre VARCHAR(50))
BEGIN
        WITH MovieDecades AS (SELECT movieID, title, FLOOR(year / 10) * 10 AS decade, rank, year
        FROM (Ranking JOIN Movie USING (movieID)) JOIN Genre USING (movieID)
        WHERE genre = inGenre)
        SELECT title, year, rank
        FROM MovieDecades
        ORDER BY rank ASC
        LIMIT 5;
END; 

-- DecadeRank.sql

DELIMITER //

DROP PROCEDURE IF EXISTS DecadeRank //

CREATE PROCEDURE DecadeRank(IN inDecade INT)
BEGIN
        WITH MovieDecades AS (SELECT movieID, title, FLOOR(year / 10) * 10 AS decade, rank, year
        FROM Ranking JOIN Movie USING (movieID))
        SELECT title, year, rank
        FROM MovieDecades
        WHERE decade = inDecade
        ORDER BY rank ASC
        LIMIT 5;
END; //

-- DecadeDirectors.sql

DELIMITER //

DROP PROCEDURE IF EXISTS DecadeDirectors //

CREATE PROCEDURE DecadeDirectors(IN inDecade INT)
BEGIN
        WITH MovieDecades AS (SELECT movieID, title, FLOOR(year / 10) * 10 AS decade
        FROM Ranking JOIN Movie USING (movieID)),
        decadeDirectorCount AS (SELECT personID, count(personID) as count
        FROM MovieDecades JOIN DirectedBy USING (movieID)
        WHERE decade = inDecade
        GROUP BY personID
        ORDER BY count(personID) DESC
        LIMIT 5)
        SELECT name, count
        FROM decadeDirectorCount JOIN Person USING (personID);
END; //

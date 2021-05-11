-- DecadeStars.sql

DELIMITER //

DROP PROCEDURE IF EXISTS DecadeStars //

CREATE PROCEDURE DecadeStars(IN inDecade INT)
BEGIN
        WITH MovieDecades AS (SELECT movieID, title, FLOOR(year / 10) * 10 AS decade
        FROM Ranking JOIN Movie USING (movieID)),
        decadeActorCount AS (SELECT personID, count(personID) as count
        FROM MovieDecades JOIN Starring USING (movieID)
        WHERE decade = inDecade
        GROUP BY personID
        ORDER BY count(personID) DESC
        LIMIT 5)
        SELECT name, count
        FROM decadeActorCount JOIN Person USING (personID);
END; //

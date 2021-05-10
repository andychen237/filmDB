-- GenreStars.sql

DELIMITER //

DROP PROCEDURE IF EXISTS GenreStars //

CREATE PROCEDURE GenreStars(IN inGenre VARCHAR(60))
BEGIN
        IF EXISTS(SELECT 1 FROM Genre WHERE inGenre = Genre) THEN
                WITH genreActorCount AS (SELECT personID, count(personID) as count
                FROM (SELECT * FROM Genre JOIN Ranking USING (movieID)) as G JOIN Starring USING (movieID)
                WHERE Genre = inGenre
                GROUP BY personID
                ORDER BY count DESC
                LIMIT 5)
                SELECT name, count
                FROM Person JOIN genreActorCount USING (personID)
                ORDER BY count DESC;
        END IF;
END; //

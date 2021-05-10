-- GenreDirectors.sql

DELIMITER //

DROP PROCEDURE IF EXISTS GenreDirectors //

CREATE PROCEDURE GenreDirectors(IN inGenre VARCHAR(60))
BEGIN
        IF EXISTS(SELECT 1 FROM Genre WHERE inGenre = Genre) THEN
                WITH genreDirectorCount AS (SELECT personID, count(personID) as count
                FROM (SELECT * FROM Genre JOIN Ranking USING (movieID)) as G JOIN DirectedBy USING (movieID)
                WHERE Genre = inGenre
                GROUP BY personID
                ORDER BY count DESC
                LIMIT 5)
                SELECT name, count
                FROM Person JOIN genreDirectorCount USING (personID)
                ORDER BY count DESC;
        END IF;
END; //

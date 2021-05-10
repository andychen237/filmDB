-- GenreTopLocations.sql

DELIMITER //

DROP PROCEDURE IF EXISTS GenreTopLocations //

CREATE PROCEDURE GenreTopLocations(IN inGenre VARCHAR(60))
BEGIN
        IF EXISTS(SELECT 1 FROM Genre WHERE inGenre = Genre) THEN
                SELECT  CONCAT(City, ", ", State, ", ", Country) as location, count(city) as 'count'
                FROM (SELECT * FROM Genre WHERE genre = inGenre) as W JOIN ShootingLocation USING (movieID)
                WHERE city != '' and state != '' and country != ''
                GROUP BY city
                ORDER BY count(city) DESC
                LIMIT 10;
        END IF;
END; //

DELIMITER ;

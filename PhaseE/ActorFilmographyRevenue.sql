-- ActorFilmographyRevenue.sql

DELIMITER //

DROP PROCEDURE IF EXISTS ActorFilmographyRevenue//

CREATE PROCEDURE ActorFilmographyRevenue(IN inName VARCHAR(60))
BEGIN
        IF EXISTS(SELECT 1 FROM Person WHERE inName = Name) THEN
                WITH queryPersonID AS (SELECT personID
                FROM Person
                WHERE name = inName
                LIMIT 1),
                ActorFilmography AS (SELECT DISTINCT movieID
                FROM Starring JOIN queryPersonID USING (personID))
                SELECT title, revenue_adj as revenue
                FROM Movie JOIN ActorFilmography USING (movieID)
                WHERE revenue_adj > 0
                ORDER BY revenue_adj DESC;
        END IF;
END; //

DELIMITER ;

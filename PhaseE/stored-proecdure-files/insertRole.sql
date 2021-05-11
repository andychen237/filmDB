--insertRole.sql

DELIMITER //

DROP PROCEDURE IF EXISTS insertRole //

CREATE PROCEDURE insertRole(IN inMovieID VARCHAR(15), inPersonID VARCHAR(15), inRole VARCHAR(200))
BEGIN
        IF NOT EXISTS(SELECT 1 FROM Movie WHERE inMovieID = movieID) THEN
                SELECT 'That movie ID does not exist' AS errorMessage;
        ELSEIF NOT EXISTS(SELECT 1 FROM Person WHERE inPersonID = personID) THEN
                SELECT 'That person ID does not exist' AS errorMessage;
        ELSEIF EXISTS(SELECT * From Starring WHERE inMovieID = movieID AND inpersonID = personID AND inRole = role) THEN
                SELECT 'That role already exists in our database' AS errorMessage;
        ELSE
                INSERT INTO Starring VALUES (inMovieID, inPersonID, inRole);
        END IF;
END; //

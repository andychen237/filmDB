--deleteRole.sql

DELIMITER //

DROP PROCEDURE IF EXISTS deleteRole //

CREATE PROCEDURE deleteRole(IN inMovieID VARCHAR(15), inPersonID VARCHAR(15), inRole VARCHAR(200))
BEGIN
        IF EXISTS(SELECT * From Starring WHERE inMovieID = movieID AND inPersonID = personID AND inRole = role) THEN
                DELETE FROM Starring WHERE movieID = inMovieID AND personID = inPersonID AND role = inRole;
        ELSE
                SELECT 'Cannot delete a row that does not exist in our database. Please make sure your inputs are valid.' AS errorMessage;
        END IF;
END; //

-- topNgenres.sql

DELIMITER //

DROP PROCEDURE IF EXISTS topNgenres //

CREATE PROCEDURE topNgenres(IN N INT)
BEGIN
        SELECT genre, count(genre)
        FROM Genre
        GROUP BY Genre
        ORDER BY count(Genre) DESC
        LIMIT N;
END; //

DELIMITER ;


DELIMITER //

DROP PROCEDURE IF EXISTS FilmsYearRange //

CREATE PROCEDURE FilmsYearRange(IN startYear year, IN endYear year)
BEGIN
	SELECT title, year
	FROM Movie
	WHERE year >= startYear AND year <= endYear
	ORDER BY year ASC;
END; //

DELIMITER ;

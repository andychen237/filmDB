DELIMITER //

DROP PROCEDURE IF EXISTS TopFiveDecade //

CREATE PROCEDURE TopFiveDecade(IN startYear year)
BEGIN
        SELECT title, year, revenue, revenue_adj
	FROM Movie
	WHERE revenue IS NOT NULL AND revenue_adj IS NOT NULL AND FLOOR(year/10) * 10 = startYear
	ORDER BY revenue_adj DESC
	LIMIT 5;
END; //

DELIMTER ;

DELIMITER //

DROP PROCEDURE IF EXISTS TopFiveYear //

CREATE PROCEDURE TopFiveYear(IN startYear year)
BEGIN
        SELECT title, revenue, revenue_adj
	FROM Movie
	WHERE revenue IS NOT NULL AND revenue_adj IS NOT NULL AND year = startYear
	ORDER BY revenue_adj desc
	LIMIT 5;
END; //

DELIMTER ;

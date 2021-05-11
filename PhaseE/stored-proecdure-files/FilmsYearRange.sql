DELIMITER //

DROP PROCEDURE IF EXISTS FilmsYearRange //

CREATE PROCEDURE FilmsYearRange(IN startYear VARCHAR(4), IN endYear VARCHAR(4))
BEGIN
        WITH TopGross AS (SELECT title, year, revenue_adj
             FROM Movie
             WHERE year >= startYear AND year <= endYear
             ORDER BY revenue_adj DESC
             LIMIT 50)
        SELECT *
        FROM TopGross
        ORDER BY year ASC, revenue_adj DESC, title ASC;
END; //

DELIMITER ;



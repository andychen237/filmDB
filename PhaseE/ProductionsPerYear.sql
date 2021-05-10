DELIMITER //

DROP PROCEDURE IF EXISTS ProductionsPerYear //

CREATE PROCEDURE ProductionsPerYear(IN inputName VARCHAR(200))
BEGIN
	IF EXISTS (SELECT 1 FROM Person WHERE inputName = name) THEN
	   WITH Creator AS (SELECT personID, name FROM Person WHERE name = inputName),
           	Directing AS (SELECT C.personID, D.movieID
                FROM Creator AS C JOIN DirectedBy AS D ON C.personID = D.personID),
        	Directed AS (SELECT D.movieID AS movieID, M.year AS year
                FROM Directing AS D JOIN Movie AS M ON D.movieID = M.movieID
                WHERE year IS NOT NULL)
	   SELECT year, COUNT(year)
	   FROM Directed
	   GROUP BY year
	   ORDER BY COUNT(year) desc;
	END IF;
END; //

DELIMITER ;

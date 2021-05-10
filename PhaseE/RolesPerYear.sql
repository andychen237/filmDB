DELIMITER //

DROP PROCEDURE IF EXISTS RolesPerYear //

CREATE PROCEDURE RolesPerYear(inputName VARCHAR(200))
BEGIN
	IF EXISTS (SELECT 1 FROM Person WHERE inputName = name) THEN
	   WITH Creator AS (SELECT personID, name FROM Person WHERE name = inputName),
           	ActingRoles AS (SELECT C.personID, C.name, A.movieID 
           	FROM Creator AS C JOIN Starring AS A ON C.personID = A.personID),
	   	Acted AS (SELECT  Act.movieID AS movieID, M.year AS year
           	FROM ActingRoles AS Act JOIN Movie AS M ON Act.movieID = M.movieID
                WHERE year IS NOT NULL)
 	   SELECT year, COUNT(year)
 	   FROM Acted
 	   GROUP BY year
 	   ORDER BY year ASC;
	END IF;
END; //

DELIMITER ;

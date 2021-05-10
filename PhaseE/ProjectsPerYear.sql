DELIMITER //

DROP PROCEDURE IF EXISTS ProjectsPerYear //

CREATE PROCEDURE ProjectsPerYear(IN inputName VARCHAR(200))
BEGIN
	IF EXISTS (SELECT 1 FROM Person WHERE inputName = name) THEN
	   WITH Creator AS (SELECT personID, name FROM Person WHERE name = inputName),
        ActingRoles AS (SELECT C.personID, C.name, A.movieID 
                FROM Creator AS C JOIN Starring AS A ON C.personID = A.personID),
        Acted AS (SELECT  Act.movieID AS movieID, M.year AS year
                FROM ActingRoles AS Act JOIN Movie AS M ON Act.movieID = M.movieID
                WHERE year IS NOT NULL),
        Directing AS (SELECT C.personID, C.name, D.movieID
                FROM Creator AS C JOIN DirectedBy AS D ON C.personID = D.personID),
        Directed AS (SELECT D.movieID AS movieID, M.year AS year
                FROM Directing AS D JOIN Movie AS M ON D.movieID = M.movieID
                WHERE year IS NOT NULL),
                AllJobs AS (SELECT * FROM Acted
                UNION ALL
                SELECT * FROM Directed)
	    SELECT year, COUNT(year) AS projects
 	    FROM AllJobs
 	    GROUP BY year
 	    ORDER BY projects desc;
	 END IF;
END; //

DELIMITER ;

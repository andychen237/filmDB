DELIMITER //

DROP PROCEDURE IF EXISTS ReprisedRoles //

CREATE PROCEDURE ReprisedRoles(IN actor VARCHAR(200))
BEGIN
	IF EXISTS (SELECT 1 FROM Person WHERE name = actor) THEN
	   WITH Actor AS (SELECT personID FROM Person WHERE name = actor),
           Roles AS (SELECT movieID, role
           FROM Actor AS A JOIN Starring AS S ON A.personID = S.personID)
	   SELECT role, COUNT(role) AS role_num
	   FROM Roles
	   GROUP BY role
	   ORDER BY role_num DESC;
	 END IF;
END; //

DELIMITER ;

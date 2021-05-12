-- Stored procedures

-- ActorFilmographyRevenue.sql

DELIMITER //

DROP PROCEDURE IF EXISTS ActorFilmographyRevenue//

CREATE PROCEDURE ActorFilmographyRevenue(IN inName VARCHAR(60))
BEGIN
        IF EXISTS(SELECT 1 FROM Person WHERE inName = Name) THEN
                WITH queryPersonID AS (SELECT personID
                FROM Person
                WHERE name = inName
                LIMIT 1),
                ActorFilmography AS (SELECT DISTINCT movieID
                FROM Starring JOIN queryPersonID USING (personID))
                SELECT title, revenue_adj as revenue
                FROM Movie JOIN ActorFilmography USING (movieID)
                WHERE revenue_adj > 0
                ORDER BY revenue_adj DESC;
        END IF;
END; //

DELIMITER ;

-- DirectorFilmographyRevenue.sql

DELIMITER //

DROP PROCEDURE IF EXISTS DirectorFilmographyRevenue//

CREATE PROCEDURE DirectorFilmographyRevenue(IN inName VARCHAR(60))
BEGIN
        IF EXISTS(SELECT 1 FROM Person WHERE inName = Name) THEN
                WITH queryPersonID AS (SELECT personID
                FROM Person
                WHERE name = inName
                LIMIT 1),
                DirectorFilmography AS (SELECT DISTINCT movieID
                FROM DirectedBy JOIN queryPersonID USING (personID))
                SELECT title, revenue_adj as revenue
                FROM Movie JOIN DirectorFilmography USING (movieID)
                WHERE revenue_adj > 0
                ORDER BY revenue_adj DESC;
        END IF;
END; //

DELIMITER ;

                                                          
-- DecadeDirectors.sql

DELIMITER //

DROP PROCEDURE IF EXISTS DecadeDirectors //

CREATE PROCEDURE DecadeDirectors(IN inDecade INT)
BEGIN
        WITH MovieDecades AS (SELECT movieID, title, FLOOR(year / 10) * 10 AS decade
        FROM Ranking JOIN Movie USING (movieID)),
        decadeDirectorCount AS (SELECT personID, count(personID) as count
        FROM MovieDecades JOIN DirectedBy USING (movieID)
        WHERE decade = inDecade
        GROUP BY personID
        ORDER BY count(personID) DESC
        LIMIT 5)
        SELECT name, count
        FROM decadeDirectorCount JOIN Person USING (personID);
END; //

DELIMITER ;

-- DecadeRank.sql

DELIMITER //

DROP PROCEDURE IF EXISTS DecadeRank //

CREATE PROCEDURE DecadeRank(IN inDecade INT)
BEGIN
        WITH MovieDecades AS (SELECT movieID, title, FLOOR(year / 10) * 10 AS decade, rank, year
        FROM Ranking JOIN Movie USING (movieID))
        SELECT title, year, rank
        FROM MovieDecades
        WHERE decade = inDecade
        ORDER BY rank ASC
        LIMIT 5;
END; //

DELIMITER ;

-- DecadeStars.sql

DELIMITER //

DROP PROCEDURE IF EXISTS DecadeStars //

CREATE PROCEDURE DecadeStars(IN inDecade INT)
BEGIN
        WITH MovieDecades AS (SELECT movieID, title, FLOOR(year / 10) * 10 AS decade
        FROM Ranking JOIN Movie USING (movieID)),
        decadeActorCount AS (SELECT personID, count(personID) as count
        FROM MovieDecades JOIN Starring USING (movieID)
        WHERE decade = inDecade
        GROUP BY personID
        ORDER BY count(personID) DESC
        LIMIT 5)
        SELECT name, count
        FROM decadeActorCount JOIN Person USING (personID);
END; //

DELIMITER ;

-- FilmsYearRange.sql

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

-- GenreDirectors.sql

DELIMITER //

DROP PROCEDURE IF EXISTS GenreDirectors //

CREATE PROCEDURE GenreDirectors(IN inGenre VARCHAR(60))
BEGIN
        IF EXISTS(SELECT 1 FROM Genre WHERE inGenre = Genre) THEN
                WITH genreDirectorCount AS (SELECT personID, count(personID) as count
                FROM (SELECT * FROM Genre JOIN Ranking USING (movieID)) as G JOIN DirectedBy USING (movieID)
                WHERE Genre = inGenre
                GROUP BY personID
                ORDER BY count DESC
                LIMIT 5)
                SELECT name, count
                FROM Person JOIN genreDirectorCount USING (personID)
                ORDER BY count DESC;
        END IF;
END; //

DELIMITER ;

-- GenreRank.sql

DELIMITER //

DROP PROCEDURE IF EXISTS GenreRank //

CREATE PROCEDURE GenreRank(IN inGenre VARCHAR(50))
BEGIN
        WITH MovieDecades AS (SELECT movieID, title, FLOOR(year / 10) * 10 AS decade, rank, year
        FROM (Ranking JOIN Movie USING (movieID)) JOIN Genre USING (movieID)
        WHERE genre = inGenre)
        SELECT title, year, rank
        FROM MovieDecades
        ORDER BY rank ASC
        LIMIT 5;
END; //

DELIMITER ;

-- GenreStars.sql

DELIMITER //

DROP PROCEDURE IF EXISTS GenreStars //

CREATE PROCEDURE GenreStars(IN inGenre VARCHAR(60))
BEGIN
        IF EXISTS(SELECT 1 FROM Genre WHERE inGenre = Genre) THEN
                WITH genreActorCount AS (SELECT personID, count(personID) as count
                FROM (SELECT * FROM Genre JOIN Ranking USING (movieID)) as G JOIN Starring USING (movieID)
                WHERE Genre = inGenre
                GROUP BY personID
                ORDER BY count DESC
                LIMIT 5)
                SELECT name, count
                FROM Person JOIN genreActorCount USING (personID)
                ORDER BY count DESC;
        END IF;
END; //

DELIMITER ;


-- GenreTopGrossing.sql

DELIMITER //

DROP PROCEDURE IF EXISTS GenreTopGrossing //

CREATE PROCEDURE GenreTopGrossing(IN inputGenre VARCHAR(60))
BEGIN
	WITH foundGenre AS (SELECT movieID
	     FROM Genre
	     WHERE genre = inputGenre)
        SELECT title, year, revenue, revenue_adj
        FROM Movie JOIN foundGenre ON Movie.movieID = foundGenre.movieID
        WHERE revenue IS NOT NULL AND revenue_adj IS NOT NULL
        ORDER BY revenue_adj desc
        LIMIT 5;
END; //

DELIMITER ;


-- GenreTopLocations.sql

DELIMITER //

DROP PROCEDURE IF EXISTS GenreTopLocations //

CREATE PROCEDURE GenreTopLocations(IN inGenre VARCHAR(60))
BEGIN
        IF EXISTS(SELECT 1 FROM Genre WHERE inGenre = Genre) THEN
                SELECT  CONCAT(City, ", ", State, ", ", Country) as location, count(city) as 'count'
                FROM (SELECT * FROM Genre WHERE genre = inGenre) as W JOIN ShootingLocation USING (movieID)
                WHERE city != '' and state != '' and country != ''
                GROUP BY city
                ORDER BY count(city) DESC
                LIMIT 10;
        END IF;
END; //

DELIMITER ;

-- GenreTrends.sql

DELIMITER //

DROP PROCEDURE IF EXISTS GenreTrends //

CREATE PROCEDURE GenreTrends(IN inGenre VARCHAR(60))
BEGIN
        IF EXISTS(SELECT 1 FROM Genre WHERE inGenre = Genre) THEN
                WITH MovieDecades AS (SELECT movieID, title, FLOOR(year / 10) * 10 AS decade
                FROM Movie),
                GenreDecades AS (SELECT M.movieID, M.title, M.decade, G.genre
                FROM Genre AS G JOIN MovieDecades AS M ON M.movieID = G.movieID
                ORDER BY decade),
                TotalFilmsPerDecade AS (SELECT decade, count(decade) as totalFilms
                FROM GenreDecades
                WHERE decade != ''
                GROUP BY decade)
                SELECT decade, count(movieID) as numFilms, (count(movieID)/totalFilms)*100 as Percentage
                FROM TotalFilmsPerDecade JOIN GenreDecades USING (decade)
                WHERE genre = inGenre
                GROUP BY decade;
        END IF;
END; //

DELIMITER ;

-- ProductionsPerYear.sql

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
	   ORDER BY year ASC;
	END IF;
END; //

DELIMITER ;

-- ProjectsPerYear.sql


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
 	    ORDER BY year ASC;
	 END IF;
END; //

DELIMITER ;

-- ReprisedRoles.sql

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

-- RolesPerYear.sql

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

-- TopFiveDecade.sql

DELIMITER //

DROP PROCEDURE IF EXISTS TopFiveDecade //

CREATE PROCEDURE TopFiveDecade(IN startYear VARCHAR(4))
BEGIN
        SELECT title, year, revenue, revenue_adj
	FROM Movie
	WHERE revenue IS NOT NULL AND revenue_adj IS NOT NULL AND FLOOR(year/10) * 10 = startYear
	ORDER BY revenue_adj DESC
	LIMIT 5;
END; //

DELIMITER ;

-- TopFiveGenre.sql


DELIMITER //

DROP PROCEDURE IF EXISTS TopFiveGenre //

CREATE PROCEDURE TopFiveGenre(IN inputGenre VARCHAR(100))
BEGIN
	WITH foundGenre AS (SELECT movieID
	     FROM Genre
	     WHERE genre = inputGenre)
        SELECT title, year, revenue, revenue_adj
        FROM Movie JOIN foundGenre ON Movie.movieID = foundGenre.movieID
        WHERE revenue IS NOT NULL AND revenue_adj IS NOT NULL
        ORDER BY revenue_adj desc
        LIMIT 5;
END; //

DELIMITER ;

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

-- deleteRole.sql

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

DELIMITER ;

-- insertRole.sql

DELIMITER //

DROP PROCEDURE IF EXISTS insertRole //

CREATE PROCEDURE insertRole(IN inMovieID VARCHAR(15), inPersonID VARCHAR(15), inRole VARCHAR(200))
BEGIN
        IF NOT EXISTS(SELECT 1 FROM Movie WHERE inMovieID = movieID) THEN
                SELECT 'That movie ID does not exist' AS errorMessage;
        ELSEIF NOT EXISTS(SELECT 1 FROM Person WHERE inPersonID = personID) THEN
                SELECT 'That person ID does not exist' AS errorMessage;
        ELSEIF EXISTS(SELECT * From Starring WHERE inMovieID = movieID AND inpersonID = personID AND inRole = role) THEN
                SELECT 'That role already exists in our database' AS errorMessage;
        ELSE
                INSERT INTO Starring VALUES (inMovieID, inPersonID, inRole);
        END IF;
END; //

DELIMITER ;

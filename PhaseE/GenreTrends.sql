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

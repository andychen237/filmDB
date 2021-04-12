-- Andy Chen, achen93
-- Curtis Nishimoto, cnishim1

DROP VIEW IF EXISTS RankDetailed;
CREATE VIEW RankDetailed AS (SELECT movieID, title, year, FLOOR(year / 10) * 10 AS decade, rank, runtime, budget, revenue, budget_adj, revenue_adj 
FROM Movie JOIN Ranking USING (movieID));

-- Queries about shooting location

-- Top 10 cities most filmed at
-- Result: 1) LA, US, 2) NY, US, 3) Westminster, UK 4) Paris, France 5) Berlin, Germany
-- 6) Toronto, CA 7) SF, US 8) London, UK 9) Chicago, US 10) Rome, Italy
SELECT City, Country, count(city) as 'Number of films'
FROM ShootingLocation
WHERE city != ''
GROUP BY city
ORDER BY count(city) DESC
LIMIT 10;

-- Top ranked films movies shot in Baltimore, MD
-- Result: 1) Pink Flamingos (1972), 2) Female Trouble (1974)
SELECT DISTINCT Title, Year
FROM Movie JOIN (Ranking as R JOIN (SELECT movieID FROM ShootingLocation WHERE City = 'Baltimore') AS S USING (movieID)) USING (movieID)
ORDER BY Rank ASC;

-- Films shot at Johns Hopkins University
-- Result: Mondo Trasho (1969), Desperate Living (1977), Dead Man's Curve (1998), 
-- The Social Network (2010), Four Corners (2012), Chennai Serial Killer (2015)
SELECT Title, Year
FROM Movie JOIN (SELECT movieID
FROM ShootingLocation
WHERE locationListing LIKE '%Johns Hopkins%') as JH USING (movieID);

-- Films with most countries as shooting locations
-- Result: 1) To the Top (2016) (36), Samsara (2011) (26), Baraka (1992) (24), The Fall (2006) (21), World Safari (1977) (20)
SELECT Title, Year, count as 'Number of countries'
FROM (SELECT movieID, count(DISTINCT country) as count
FROM ShootingLocation
GROUP BY movieID
ORDER BY count(DISTINCT country) DESC
LIMIT 5) as L JOIN Movie USING (movieID);

-- Most popular shooting locations for Westerns
-- Results: Santa Clarita, Tuscon, LA, Mexico City, Santa Fe, Guadalupe, Monterrey, Victorille, Gallup, Prescott
SELECT Genre, City, Country, count(city) as 'Number of Films'
FROM (SELECT * FROM Genre WHERE genre = 'western') as W JOIN ShootingLocation USING (movieID)
WHERE city != ''
GROUP BY Genre, city
ORDER BY count(city) DESC
LIMIT 10;

-- Queries about genres

-- Top 3 most popular genres per decade
WITH MovieDecades AS (SELECT movieID, title, FLOOR(year / 10)*10 AS decade
        FROM Movie),
        GenreDecades AS (SELECT M.movieID, M.title, M.decade, G.genre
        FROM Genre AS G JOIN MovieDecades AS M ON M.movieID = G.movieID
        ORDER BY decade),
        DecadeCount AS (SELECT G.decade, G.genre, COUNT(G1.genre) AS count
        FROM GenreDecades AS G JOIN GenreDecades AS G1 ON G.movieID = G1.movieID AND G.genre = G1.genre
        GROUP BY G.decade, G.genre),
        GenreRank AS (SELECT DENSE_RANK() OVER (PARTITION BY Decade ORDER BY Count DESC) AS 'Rank', Decade, Genre, Count
        from DecadeCount)
SELECT Decade, Genre, Count as 'Number of Films'
FROM GenreRank
WHERE Rank <= 3 AND Decade IS NOT NULL;

-- Which genres have changed the most from the Old Hollywood era (pre-1970) to contemporary times (>= 1970)?
-- Results: 
-- Genres that have increased most in production: 1) Animation +65% , 2) Horror +61%, 3) Documentary +61%, 4) Biography +53%, 5) Thriller +53%
-- Genres that have decreased most in production: 1) Film-noirs -100%, 2) Westerns -84%, 3) Musicals -57%, 4) War films -45%, 5) Adventure films -26%
WITH MovieDecades AS (SELECT movieID, title, FLOOR(year / 10) * 10 AS decade
        FROM Movie),
        GenreDecades AS (SELECT M.movieID, M.title, M.decade, G.genre
        FROM Genre AS G JOIN MovieDecades AS M ON M.movieID = G.movieID
        ORDER BY decade),
        OldHollywoodGenres AS (SELECT Genre, (count(genre)/(SUM(COUNT(genre)) OVER())) * 100 AS Percentage FROM GenreDecades WHERE Decade <= 1960 GROUP BY Genre),
        ModernTimeGenres AS (SELECT Genre, (count(genre)/(SUM(COUNT(genre)) OVER())) * 100 AS Percentage FROM GenreDecades WHERE Decade >= 1970 GROUP BY Genre)
(SELECT Genre, OldPercentage as '% of total made in Old Hollywood era, pre-1970', NewPercentage '% of total made in contemporary times, >=1970', CONCAT(CAST(CAST((NewPercentage-OldPercentage)/(OldPercentage + NewPercentage)*100 AS INT) AS VARCHAR(5)), '%') AS '% Change'
FROM (SELECT Genre, O.Percentage as 'OldPercentage', IFNULL(M.Percentage, 0) as 'NewPercentage' FROM ModernTimeGenres AS M RIGHT JOIN OldHollywoodGenres AS O USING (Genre)) AS T
WHERE Genre != 'Reality-TV' AND Genre != 'News' 
ORDER BY (NewPercentage-OldPercentage)/(OldPercentage + NewPercentage)*100 DESC
LIMIT 5)
UNION
(SELECT Genre, OldPercentage as '% of total made in Old Hollywood era, pre-1970', NewPercentage '% of total made in contemporary times, >=1970', CONCAT(CAST(CAST((NewPercentage-OldPercentage)/(OldPercentage + NewPercentage)*100 AS INT) AS VARCHAR(5)), '%') AS '% Change'
FROM (SELECT Genre, O.Percentage as 'OldPercentage', IFNULL(M.Percentage, 0) as 'NewPercentage' FROM ModernTimeGenres AS M RIGHT JOIN OldHollywoodGenres AS O USING (Genre)) AS T
ORDER BY (NewPercentage-OldPercentage)/(OldPercentage + NewPercentage)*100 ASC
LIMIT 5);

-- Directors who directed the most of each genre
-- Preview of results: Mystery - Alfred Hitchcock (22), Film-Noir - Fritz Lang (17), Sci-Fi: Ishiro Honda (33)
With DirectorCount AS (SELECT Genre, personID, count(personID) as count
        FROM Genre JOIN DirectedBy USING (movieID)
        GROUP BY genre, personID),
        MaxGenreCount AS (SELECT *
        FROM DirectorCount AS D1
        WHERE D1.count = (SELECT max(count) FROM DirectorCount as D2 WHERE D1.genre = D2.genre) AND D1.count > 10)
SELECT Genre, Name, Count as 'Number of Films Directed'
From MaxGenreCount JOIN Person USING (personID);

-- Actor who acted the most of each genre
-- Preview of results:  Film-Noir - Humphrey Bogart (27), Biography: Anthony Hopkins (16)
With ActorCount AS (SELECT Genre, personID, count(personID) as count
        FROM Genre JOIN Starring USING (movieID)
        GROUP BY genre, personID),
        MaxGenreCount AS (SELECT *
        FROM ActorCount AS A1
        WHERE A1.count = (SELECT max(count) FROM ActorCount as A2 WHERE A1.genre = A2.genre) AND A1.count > 10)
SELECT Genre, Name, Count as 'Number of Starring Films'
From MaxGenreCount JOIN Person USING (personID);

-- Top ten most popular genres
-- Result: 1) Drama, 2) Documentary, 3) Comedy, 4) Action, 5) Romance
-- 6) Thriller, 7) Crime, 8) Horror, 9) Adventure, 10) Familly
SELECT Genre, count(genre) as 'Number of films'
FROM Genre
GROUP BY Genre
ORDER BY count(Genre) DESC
LIMIT 10;

-- Queries related to film rankings

-- Best ranked film per genre
-- Preview of results: Horror: Psycho (1960), Musical: Singin' in the Rain (1952), 
-- Sport: Raging Bull (1980), Animation: Up (2009), Crime: The Godfather (1972)
With RankGenres as (SELECT * FROM RankDetailed JOIN Genre USING (movieID))
SELECT Genre, Title, Year
FROM RankGenres as R1
WHERE rank = (SELECT min(rank) FROM RankGenres as R2 WHERE R1.genre = R2.genre)
GROUP BY Genre;

-- Top 20 directors with most appearances in greatest film list (along with their greatest film)
-- Preview of Results: 1) John-Luc Godard (Breathless), 2) John Ford (The Searchers), 3) ALfred Hitchcock (Vertigo)
With TopDirectors AS (SELECT personID, movieID, rank, title, Year
FROM RankDetailed JOIN DirectedBy USING (movieID)),
TopDirectorsCount AS (SELECT Name, personID, Count(DISTINCT movieID) as Count
FROM TopDirectors JOIN Person USING (personID)
GROUP BY Name
ORDER BY count(DISTINCT movieID) DESC
LIMIT 20)
SELECT Name, Count as 'Number of ranked films', Title as 'Greatest film', Year as 'Year'
FROM (SELECT * FROM TopDirectors JOIN TopDirectorsCount USING (personID)) AS T1
WHERE rank = (SELECT min(rank) FROM (SELECT * FROM TopDirectors JOIN TopDirectorsCount USING (personID)) AS T2 WHERE T1.personID = T2.personID);

-- Top 20 actors with most appearances in greatest film list (along with their greatest film)
-- Preview of results: 1) Robert De Niro (Taxi Driver), 2) John Wayne (The Searchers), 3) James Stewart (Vertigo), 4) Cary Grant (North by Northwest)
With TopActors AS (SELECT personID, movieID, rank, title, Year
FROM RankDetailed JOIN Starring USING (movieID)),
TopActorsCount AS (SELECT Name, personID, Count(DISTINCT movieID) as Count
FROM TopActors JOIN Person USING (personID)
GROUP BY Name
ORDER BY count(DISTINCT movieID) DESC
LIMIT 20)
SELECT Name, Count as 'Number of ranked films', Title as 'Greatest film', Year as 'Year'
FROM (SELECT * FROM TopActors JOIN TopActorsCount USING (personID)) AS T1
WHERE rank = (SELECT min(rank) FROM (SELECT * FROM TopActors JOIN TopActorsCount USING (personID)) AS T2 WHERE T1.personID = T2.personID);

-- Top ranked film per decade
-- Results: 1910: Intolerance, 1920: Sunrise, 1930: The Rules of the Game, 1940: Citizen Kane,
-- 1950: Vertigo, 1960: 2001: A Space Odyssey, 1970: The Godfather, 1980: Raging Bull, 1990: Pulp Fiction,
-- 2000: In the Mood for Love, 2010: The Tree of Life
SELECT Decade, Title, Year
FROM RankDetailed as R1
WHERE rank = (SELECT min(rank) FROM RankDetailed as R2 WHERE R1.decade = R2.decade)
GROUP BY Decade;

-- Top ranked film per year (if represented in ranking)
SELECT Year, Title
FROM RankDetailed as R1
WHERE rank = (SELECT min(rank) FROM RankDetailed as R2 WHERE R1.year = R2.year)
GROUP BY year;

-- Directors with most appearances in greatest film list per decade
With DirectorCount AS (SELECT * FROM (SELECT decade, personID, count(DISTINCT movieID) as Count
FROM RankDetailed JOIN DirectedBy USING (movieID)
GROUP BY decade, personID) as A JOIN Person USING (personID)),
DirectorRank AS (SELECT DENSE_RANK() OVER (PARTITION BY Decade ORDER BY Count DESC) AS 'Position', Decade, Name, PersonID, Count
        from DirectorCount)
SELECT Decade, Name, Count
FROM DirectorRank
WHERE Position <= 2 AND COUNT >= 2;

-- Actors with most appearances in greatest film list per decade
With ActorCount AS (SELECT * FROM (SELECT decade, personID, count(DISTINCT movieID) as Count
FROM RankDetailed JOIN Starring USING (movieID)
GROUP BY decade, personID) as A JOIN Person USING (personID)),
ActorRank AS (SELECT DENSE_RANK() OVER (PARTITION BY Decade ORDER BY Count DESC) AS 'Position', Decade, Name, PersonID, Count
        from ActorCount)
SELECT Decade, Name, Count
FROM ActorRank
WHERE Position <= 3 AND COUNT >= 2;

-- Queries about budget/revenue

-- Top ten movies in revenue (adjusted)
-- Preview of results: 1) Avatar, 2) Star Wars: A New Hope, 3) Titanic, 4) The Exorcist, 5) Jaws
SELECT Title, Year, CONCAT('$', CAST(Revenue AS VARCHAR(20))) AS 'Revenue', CONCAT('$', CAST(Revenue_adj AS VARCHAR(20))) AS 'Adjusted Revenue'
FROM Movie
WHERE revenue IS NOT NULL AND revenue_adj IS NOT NULL
ORDER BY revenue_adj desc
LIMIT 10;

-- Top ten movies by profit (not adjusted)
-- Preview of results: 1) Avatar, 2) Star Wars: A New Hope, 3) Titanic, 4) Jurassic World, 5) Furious 7
SELECT Title, Year, CONCAT('$', CAST(Budget AS VARCHAR(20))) AS 'Budget', CONCAT('$', CAST(Revenue AS VARCHAR(20))) AS 'Revenue', CONCAT('$',CAST(revenue - budget AS VARCHAR(20))) AS Gross
FROM Movie
WHERE revenue IS NOT NULL AND budget IS NOT NULL
ORDER BY revenue - budget desc
LIMIT 10;

-- Top ten movies who made the higher returns on investment
-- Preview of results: 1) Paranormal Activity (2007), 2) The Blair Witch Project (1999), 3) Eraserhead (1977), 4) Pink Flamingos (1972), 5) Super Size Me (2004)
SELECT Title, Year, CONCAT('$', CAST(Budget AS VARCHAR(20))) AS 'Budget', CONCAT('$', CAST(Revenue AS VARCHAR(20))) AS 'Revenue', CONCAT(CAST(((revenue - budget)/budget*100) AS VARCHAR(20)),'%') AS 'Return on Investment'
FROM Movie
WHERE revenue IS NOT NULL AND budget > 1000
ORDER BY (revenue - budget)/(budget) desc
LIMIT 10;
        
-- Top 10 Box Office Bombs
-- Results: 1) Chaos (2005), 2) 5 Days of War (2011), 3) Foodfight! (2011), 4) The Good Night (2007), 5) Cherry 2000 (1987)
With PercentProfit AS (SELECT title as Title, movieID, year as Year, budget as Budget, revenue as Revenue, ((revenue / budget) * 100) AS Percent
        FROM Movie
        WHERE budget > 10000 AND revenue > 10000)
SELECT Title, Year, Budget, Revenue, CONCAT(CAST(Percent AS VARCHAR(5)), '%') AS 'Percent of Budget Grossed'
FROM PercentProfit
ORDER BY percent ASC
LIMIT 10;

-- Revenue per year
SELECT M.year As Year, CONCAT('$',CAST((SELECT SUM(revenue_adj) AS profit 
        FROM Movie AS M1
        WHERE M1.year = M.year AND M1.revenue_adj IS NOT NULL) AS VARCHAR(20))) as Revenue
FROM Movie AS M
WHERE M.revenue_adj IS NOT NULL
GROUP BY M.year;

-- Revenue per decade
WITH MovieDecades AS (SELECT movieID, revenue, FLOOR(year / 10) AS decade
        FROM Movie
        WHERE revenue IS NOT NULL)
SELECT M1.decade * 10 as Decade, CONCAT('$',CAST((SELECT SUM(M.revenue) 
        FROM MovieDecades AS M
        WHERE M.decade = M1.decade) AS VARCHAR(20))) AS Revenue
FROM MovieDecades AS M1
GROUP BY M1.decade;

-- Common Roles/Names
-- Results (first 5): Narrator (7676), Anna (1981), Maria (1794), David (1963), Mother (1546)
SELECT Role, COUNT(role) AS 'Number of appearances'
FROM Starring
GROUP BY role
ORDER BY COUNT(role) desc
LIMIT 10;


-- These have obscure and/or uninteresting results, so should probably be scrapped. 
-- Kept here for reference just in case.

-- Directors who starred in the greatest number of their own movies
WITH TopSelfStarring AS (SELECT DISTINCT personID, count(DISTINCT movieID) as Count
FROM Starring JOIN DirectedBy USING (personID, movieID)
GROUP BY personID
ORDER BY count(DISTINCT movieID) desc
LIMIT 5)
SELECT Name as 'Director', Count as 'Number of self-starring films'
FROM TopSelfStarring LEFT OUTER JOIN Person using (personID);

-- Top 5 movies with longest runtime
SELECT Title, Year, Runtime
FROM Movie
ORDER BY runtime DESC
LIMIT 5;

-- Most played historical roles [using genres: biography, history, or war] 
-- (Expected actual historical figures but results are still narrator, mother, etc. so nevermind)
WITH HistoricalFilms AS (SELECT * FROM Genre WHERE genre = 'biography' OR genre = 'history' OR genre = 'war')
SELECT Genre, Role, COUNT(role) AS 'Number of appearances'
FROM Starring JOIN HistoricalFilms USING (movieID)
GROUP BY Genre, role
ORDER BY COUNT(role) desc
LIMIT 20;

-- For films where location is important, what are the popular shooting locations? 
-- Results are just LA and NY, which was kind of expected, 
-- but decided to use Westerns for a query because that was the only one with interesting results
WITH LocationGenres AS (SELECT * FROM Genre WHERE genre = 'adventure' OR genre = 'fantasy' OR genre = 'war' OR genre = 'sci-fi' OR genre = 'western' OR genre = 'horror')
SELECT Genre, city, count(city)
FROM LocationGenres JOIN ShootingLocation USING (movieID)
WHERE city != ''
GROUP BY Genre, city
ORDER BY count(city) DESC;

-- Top keywords for genres, not very insightful
SELECT Genre, keyword, count(keyword)
FROM Genre JOIN Keyword USING (movieID)
WHERE keyword != ''
GROUP BY Genre, keyword
ORDER BY count(keyword) DESC;


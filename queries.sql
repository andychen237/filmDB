-- Most popular genres per decade (incomplete)--
WITH MovieDecades AS (SELECT movieID, title, FLOOR(year / 10) AS decade
        FROM Movie),
        GenreDecades AS (SELECT M.movieID, M.title, M.decade, G.genre
        FROM Genre AS G JOIN MovieDecades AS M ON M.movieID = G.movieID
        ORDER BY decade),
        DecadeCount AS (SELECT G.decade, G.genre, COUNT(G1.genre) AS count
        FROM GenreDecades AS G JOIN GenreDecades AS G1 ON G.movieID = G1.movieID AND G.genre = G1.genre
        GROUP BY G.decade, G.genre)
SELECT decade, genre, MAX(count)
FROM DecadeCount
GROUP BY decade, genre;

--Top ten movies in revenue(Adjusted)--
SELECT title, year, revenue, revenue_adj
FROM Movie
WHERE revenue IS NOT NULL AND revenue_adj IS NOT NULL
ORDER BY revenue_adj desc
LIMIT 10;

--Top ten movies by profit (not adjusted)--
SELECT title, year, revenue - budget AS gross
FROM Movie
WHERE revenue IS NOT NULL AND budget IS NOT NULL
ORDER BY gross desc;

--Most prevalent genre overall--
WITH GenreCount AS (SELECT genre, COUNT(genre) AS count
        FROM Genre
        GROUP BY genre)
SELECT genre, MAX(count)
FROM GenreCount
GROUP BY genres
ORDER BY MAX(count) desc
LIMIT 1;

--Revenue per decade--
WITH MovieDecades AS (SELECT movieID, revenue, FLOOR(year / 10) AS decade
        FROM Movie
        WHERE revenue IS NOT NULL)
SELECT M1.decade * 10, (SELECT SUM(M.revenue) 
        FROM MovieDecades AS M
        WHERE M.decade = M1.decade)
FROM MovieDecades AS M1
GROUP BY M1.decade;

--Ten least profitable films--
WITH PercentProfit AS (SELECT title, ((revenue / budget) * 100) AS percent
        FROM Movie
        WHERE budget IS NOT NULL AND revenue IS NOT NULL)
SELECT title, percent 
FROM PercentProfit
WHERE percent < 75
ORDER BY percent ASC
LIMIT 10;

--Revenue per year--
SELECT M.year, (SELECT SUM(revenue) AS profit 
        FROM Movie AS M1
        WHERE M1.year = M.year AND M1.revenue IS NOT NULL)
FROM Movie AS M
WHERE M.revenue IS NOT NULL
ORDER BY M.year;

--Common Roles--
SELECT role, COUNT(role) AS appearances
FROM Starring
GROUP BY role
ORDER BY COUNT(role) desc
LIMIT 10;


--What have been the most prevalent genres of each decade? (incomplete)
WITH MovieDecades AS (SELECT movieID, title, CAST(year / 10 AS INT) AS decade
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
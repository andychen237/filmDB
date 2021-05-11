 -- actors's filmography ordered by revenue
WITH queryPersonID AS (SELECT personID
FROM Person
WHERE name = "Al Pacino"
LIMIT 1),
ActorFilmography AS (SELECT DISTINCT movieID
FROM Starring JOIN queryPersonID USING (personID))
SELECT title, revenue_adj as revenue
FROM Movie JOIN ActorFilmography USING (movieID)
WHERE revenue_adj > 0
ORDER BY revenue_adj DESC;

-- director's filmography ordered by revenue
WITH queryPersonID AS (SELECT personID
FROM Person
WHERE name = "David Lynch"
LIMIT 1),
DirectorFilmography AS (SELECT DISTINCT movieID
FROM DirectedBy JOIN queryPersonID USING (personID))
SELECT title, revenue_adj as revenue
FROM Movie JOIN DirectorFilmography USING (movieID)
WHERE revenue_adj > 0
ORDER BY revenue_adj DESC;
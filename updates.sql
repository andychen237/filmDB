-- Andy Chen, achen93
-- Curtis Nishimoto, cnishim1

-- For the sake of organization, insertions and deletions are not separated, 
-- but ordered to correspond with each other and demonstrate functionality


-- insertion into Starring with two foreign keys (movieID and personID)
INSERT INTO Starring VALUES
('tt0034583','nm0000048','Ugarte');
-- deletion of the same tuple to preserve original DB
DELETE FROM Starring
WHERE movieID = 'tt0034583' AND personID = 'nm0000048' AND role = 'Ugarte';

-- adding a made up movie into database; Genre is Film-Noir, director is Nicholas Ray, cast member is Montgomery Clift
INSERT INTO Movie VALUES
('tt381038132','Fake Movie','1944','90', '1002', '1000.4','14320.2','202420.3');
INSERT INTO Genre VALUES
('tt381038132','Film-Noir');
INSERT INTO DirectedBy VALUES 
('tt381038132','nm0712947');
INSERT INTO Starring VALUES
('tt381038132','nm0001050','John Doe');

-- if we updated the movieID, the movieID in Genre, DirectedBy, and Starring should change
UPDATE Movie
SET movieID = 'tt3487328'
WHERE movieID = 'tt381038132';

-- Queries with both movieID's; only those with new movieID is returned, 
-- so movieID was changed successfully (ON UPDATE CASCADE works)
SELECT *
FROM DirectedBy
WHERE movieID = 'tt381038132' OR movieID = 'tt3487328';
SELECT *
FROM Starring
WHERE movieID = 'tt381038132' OR movieID = 'tt3487328';
SELECT *
FROM Genre
WHERE movieID = 'tt381038132' OR movieID = 'tt3487328';

-- deletion to reverse adding this movie and to preserve original DB
DELETE FROM Movie
WHERE movieID = 'tt3487328';

-- insert new person into DB; add him as director to Chungking Express and a cast member in The King of Comedy
INSERT INTO Person VALUES
('nm420666911','Andy Chen','1999');
INSERT INTO DirectedBy VALUES
('tt0109424','nm420666911');
INSERT INTO Starring VALUES
('tt0085794','nm420666911','Self');

-- if we delete the person from Person, they are no longer a director and cast member of the respective two movies
DELETE FROM Person
WHERE personID = 'nm420666911';

-- All return empty result set (ON DELETE CASCADE works)
SELECT *
FROM DirectedBy
WHERE personID = 'nm420666911';
SELECT *
FROM Starring
WHERE personID = 'nm420666911';


-- Insertions that shouldn't work 
-- (commented out to remove error messages, but all produce errors if uncommented)

-- nonexisting foreign key (movieID)
-- INSERT INTO Ranking VALUES
-- ('tt0918401381', '2000');

-- duplicate primary key
-- INSERT INTO Person VALUES
-- ('nm0002092', 'John Garfield', 1913);

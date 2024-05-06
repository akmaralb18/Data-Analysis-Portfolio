/* Video Game Sales 
Skills used: Joins, Windows Functions, Aggregate Functions */

-- Select all games with more than 10M sales in the United State
SELECT name, NA_Sales
FROM games
WHERE NA_Sales>10

-- Select all games created between 2000 and 2003 and whose Publisher is Ubisoft
SELECT name, year, publisher 
FROM games
WHERE year BETWEEN 2000 and 2003 
  AND publisher = 'Ubisoft'

-- Select the games whose Publisher is missing
SELECT name, publisher 
FROM games
WHERE publisher IS NULL


-- Among the games that contain “FIFA” in the title, which one has achieved the most sales in Europe?
SELECT name, EU_Sales
FROM games
WHERE name LIKE '%FIFA%'
ORDER BY EU_Sales DESC
LIMIT 1
  
-- Calculate the sum of sales in Japan and Europe by Publisher.
SELECT publisher, SUM(JP_Sales), SUM(EU_Sales)
FROM games
GROUP BY publisher
  
-- Create a new column named “genre2” which contains:
-- “Jeu de course” if the genre is “Racing”
-- “Jeu de rôle” if the genre is “Role-Playing”
-- “Jeu de combat” if the genre is “Action”, “Simulation” and “Fighting”
-- “Other types” for other genres
-- Calculate the average sales in Japan with the new “gender2” game category
SELECT AVG(JP_Sales),
CASE WHEN genre = 'Racing' THEN 'Jeu de course'
WHEN genre = 'Role-Playing' THEN 'Jeu de rôle'
WHEN genre in ('Action', 'Simulation', 'Fighting') THEN 'Jeu de combat'
ELSE 'Other types'
END AS genre2
FROM games
GROUP BY genre2
  
-- Create a new column named “BestSellers” which contains:
-- “Pokémon” if the title contains “Pokemon”
-- “Mario” if the title contains “Mario”
-- “Call of Duty” if the title contains “Call of Duty” Among the bestsellers, what is the amount of sales in the United States? 
-- Keep bestsellers with more than 100M sales.
SELECT SUM(NA_Sales) AS sum,
CASE WHEN name LIKE '%Pokemon%' THEN 'Pokémon'
WHEN name LIKE '%Mario%' THEN 'Mario'
WHEN name LIKE '%Call of Duty%' THEN 'Call of Duty'
END AS BestSellers
FROM games
GROUP BY BestSellers
HAVING sum>100
  
-- Which platforms generated the most total sales? Keep only the first 3.
SELECT pl.name, Total_Sales
FROM games as ga
INNER JOIN platforms as pl ON ga.platform_id=pl.id
ORDER BY Total_Sales DESC
LIMIT 3

-- What is the year of first publication of a game per platform. Sort games from oldest to newest.
SELECT pl.name as Platform, MIN(ga.year) AS first
FROM games as ga
INNER JOIN platforms as pl ON ga.platform_id=pl.id
WHERE year IS NOT NULL
GROUP BY Platform
ORDER BY first

-- Calculate total sales by platform. 
-- Display the name of the platform and keep those between 100M and 300M sales, or those with more than 1000M sales.
SELECT pl.name as Platform, SUM(Total_Sales) as sum
FROM games as ga
INNER JOIN platforms as pl ON ga.platform_id=pl.id
GROUP BY Platform
HAVING sum between 100 AND 300 OR sum > 1000
  
-- Identify game genres that saw a significant increase in total sales in the United States, 
-- compared to the following year. Indicate the type of game, the year and the difference with the following year.
SELECT genre, year, NA_Sales, prev_sls, NA_Sales - prev_sls AS difference
FROM (SELECT genre, year, NA_Sales, LAG(NA_Sales) OVER (ORDER BY year) AS prev_sls
FROM games
WHERE year IS NOT NULL) AS subquery
WHERE NA_Sales > prev_sls

-- Identify games published by publishers with a higher average total sales in Europe than 
-- the overall average sales in Europe. View the game name, publisher, and total sales in Europe.
SELECT name, publisher, AVG(EU_Sales) as avg, (SELECT AVG(EU_Sales) FROM games) as tot
FROM games
GROUP BY publisher
HAVING tot > avg


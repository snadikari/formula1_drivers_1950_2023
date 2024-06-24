CREATE DATABASE formula_1;

USE formula_1;

-- Taking a look at the tables
SELECT *  FROM drivers;
SELECT *  FROM races;

-- Teams --
SELECT DISTINCT(car)
FROM drivers;

-- Cleaning team names --
SET SQL_SAFE_UPDATES = 0;

UPDATE drivers
SET car = TRIM(SUBSTRING_INDEX(car, ' ', LENGTH(car) - LENGTH(REPLACE(car, ' ', ''))))
WHERE LOCATE(' ', car) > 0
AND car NOT LIKE 'Alfa Romeo';

-- Cleaning duplicates with long engine manufacturer names --
UPDATE drivers
SET car = 'Alfa Romeo'
WHERE car LIKE 'Alfa Romeo%';

UPDATE drivers
SET car = 'AlphaTauri'
WHERE car LIKE 'AlphaTauri%';

UPDATE drivers
SET car = 'Aston Martin'
WHERE car LIKE 'Aston Martin%';

UPDATE drivers
SET car = 'Brabham'
WHERE car LIKE 'Brabham%';

UPDATE drivers
SET car = 'Connaught'
WHERE car LIKE 'Connaught%';

UPDATE drivers
SET car = 'Footwork'
WHERE car LIKE 'Footwork%';

UPDATE drivers
SET car = 'Williams'
WHERE car LIKE 'Frank Williams Racing%';

UPDATE drivers
SET car = 'Jordan'
WHERE car LIKE 'Jordan%';

UPDATE drivers
SET car = 'Ligier'
WHERE car LIKE 'Ligier%';

UPDATE drivers
SET car = 'Lotus'
WHERE car LIKE 'Lotus%';

UPDATE drivers
SET car = 'Mercedes'
WHERE car LIKE 'Mercedes%';

UPDATE drivers
SET car = 'Osella'
WHERE car LIKE 'Osella%';

UPDATE drivers
SET car = 'Prost'
WHERE car LIKE 'Prost%';

UPDATE drivers
SET car = 'Red Bull Racing'
WHERE car LIKE 'RBR';

UPDATE drivers
SET car = 'Red Bull Racing'
WHERE car LIKE 'Red Bull%';

UPDATE drivers
SET car = 'Toro Rosso'
WHERE car LIKE '%Toro Rosso%';

UPDATE drivers
SET car = 'Toro Rosso'
WHERE car LIKE 'STR';

UPDATE drivers
SET car = 'Wolf'
WHERE car LIKE 'Wolf%';

SET SQL_SAFE_UPDATES = 1;

-- Cleaning driver names --
SET SQL_SAFE_UPDATES = 0;

UPDATE drivers
SET driver = 'Kimi Raikkonen RAI'
WHERE driver LIKE 'Kimi RÃƒÆ’Ã‚Â¤ikkÃƒÆ’Ã‚Â¶nen RAI%';

-- Creating a new driver column for alteration to be safe --
ALTER TABLE drivers
ADD COLUMN driver_name VARCHAR(255);

UPDATE drivers
SET driver_name = driver;

-- Removing driver symbols --
UPDATE drivers
SET driver_name = SUBSTRING(driver_name, 1, LENGTH(driver_name) - 4)
WHERE LENGTH(driver_name) > 4;

-- Cleaning driver names on race results table --
-- Creating a new driver name column to be safe --
ALTER TABLE races
ADD COLUMN driver_name VARCHAR(255);

UPDATE races
SET driver_name = winner;

-- Removing driver symbols from race results table --
UPDATE races
SET driver_name = SUBSTRING(driver_name, 1, LENGTH(driver_name) - 4)
WHERE LENGTH(driver_name) > 4;

UPDATE races
SET driver_name = 'Kimi Raikkonen'
WHERE driver_name LIKE 'Kimi RÃƒÆ’Ã‚Â¤ikkÃƒÆ’Ã‚Â¶nen%';

SET SQL_SAFE_UPDATES = 1;

-- Total career points per driver --
SELECT
	driver_name,
    SUM(pts)
FROM drivers
GROUP BY driver_name;

-- Driver points per team --
SELECT
	driver_name,
    car AS team,
    SUM(pts)
FROM drivers
GROUP BY driver_name, car
LIMIT 100000;

-- Driver wins per team --
SELECT DISTINCT(r.driver_name) as driver,
	COUNT(r.driver_name) as wins,
    d.car as team
FROM races as r
LEFT JOIN drivers as d ON r.year = d.year AND r.driver_name = d.driver_name
GROUP BY r.driver_name, d.car
LIMIT 100000;

-- Championships per team --
SELECT driver_name as driver,
	car as team,
    COUNT(driver) as championships
FROM drivers
WHERE pos = 1
GROUP BY driver_name, car
LIMIT 100000;

-- Driver standings over the years --
SELECT driver_name as driver,
	pos as position,
    year as year
FROM drivers
LIMIT 10000;

-- Final export --
SELECT
	drivers.year,
    drivers.pos as standing,
    drivers.car as team,
    drivers.pts as points,
    drivers.driver_name as driver,
    count(races.driver_name) as wins
FROM
	drivers
LEFT JOIN races
	ON drivers.year = races.year
	AND drivers.driver_name = races.driver_name
GROUP BY drivers.year,
    drivers.pos,
    drivers.car,
    drivers.pts,
    drivers.driver_name
LIMIT 100000;
/* 
1. General look at passenger counts (seats occupied, arrival-departure) between 2010 and 2021.
   Passenger count in 2021, from 2020 >> 2021 comparison
2. Percentages of increase-decrease between 2019 to 2021
3. Before-after covid between 2019 >> 2021
4. Top 10 airport has the most air traffic in 2021
5. Top 10 country has the most air traffic in 2021
6. Regional destinations from EU to other countries, passenger count desc
7. Regional passenger comparison-percentages % 
8. What about 2022? We don't have enough data about 2022. Can we make a model and predict air traffic? 

 Hypothesis 1: 2021 air trafic is more than 50% of 2019
       >>> 2021 air traffic average more than 30 million
 Hypothesis 2:      
*/

USE aviation;

-- 1. General look at passenger counts (seats occupied, arrival-departure) between 2010-2021 in millions.
SELECT year, round(SUM(value)/1000000,2) AS total
FROM total_by_country
GROUP BY year;

-- 2. Passenger percentage difference from 2010 to 2021 comparison
SELECT y2 AS year, CONCAT(round((total2-total1)*100/total1), '%') AS percentage_difference
FROM(
SELECT * FROM (SELECT year AS y1, round(SUM(value)/1000000,2) AS total1
FROM total_by_country
WHERE year BETWEEN '2010' AND '2021'
GROUP BY year) sub1
JOIN (SELECT year as y2, round(SUM(value)/1000000,2) AS total2
FROM total_by_country
WHERE year BETWEEN '2010' AND '2021'
GROUP BY year) sub2
ON sub1.y1 = sub2.y2 - 1) sub3;

  -- 3. before_after covid between 2019-2021 
SELECT y1 AS between_2019, y2 AS and_2021, CONCAT(round((total2-total1)*100/total1), '%') AS percentage_difference
FROM(
SELECT * FROM (SELECT year AS y1, round(SUM(value)/1000000,2) AS total1
FROM total_by_country
WHERE year BETWEEN '2018' AND '2021'
GROUP BY year) sub1
JOIN (SELECT year as y2, round(SUM(value)/1000000,2) AS total2
FROM total_by_country
WHERE year BETWEEN '2018' AND '2021'
GROUP BY year) sub2
ON sub1.y1 ='2019' AND sub2.y2='2021') sub3;

-- 4. Top 10 country has the most air traffic in 2021
SELECT *, ROUND(SUM(value)/1000000,2) AS total
FROM total_by_country
WHERE year = 2021
GROUP BY country
ORDER BY total DESC
LIMIT 10;

-- 5. Top 10 airport has the most air traffic in 2021
SELECT airport_code, airport, year, ROUND(value/1000000,2) AS million
FROM top_10_airport
ORDER BY value DESC
LIMIT 10;


-- 6. Regional destinations from EU to other countries in 2021, passenger count desc
SELECT region, round(value/1000000,2) AS total_million, start_latitude, start_longitude, end_latitude, end_longitude
FROM eu_to_world
WHERE year = '2021'
GROUP BY region
ORDER BY value DESC;


-- 7. Regional passenger comparison between 2020and 2021 -percentages % 
SELECT abc1.region, total_2020, total_2021, round((total_2021-total_2020)*100/total_2020) AS percentage_diff, 
abc1.start_latitude, abc1.start_longitude, abc1.end_latitude, abc1.end_longitude
FROM
(SELECT region, round(value/1000000,2) AS total_2020, start_latitude, start_longitude, end_latitude, end_longitude
FROM eu_to_world
WHERE year = '2020'
GROUP BY region) abc1
INNER JOIN
(SELECT region, round(value/1000000,2) AS total_2021
FROM eu_to_world
WHERE year = '2021'
GROUP BY region) abc2
ON abc1.region = abc2.region
ORDER BY percentage_diff DESC;

 -- Hypothesis 1: Average air traffic in 2019 is 50 million
      -- >>> 2021 air traffic average more than 30 million
SELECT value 
FROM total_by_country
WHERE year = 2021;

SELECT * FROM intra_extra_national;

-- in 2021, intra_extra_national flights
SELECT tra_name AS destination, ROUND(value/1000000,2) value 
FROM intra_extra_national;

-- 8. What about 2022? We have data about first half of the year, so I will compare with first 6 months of previous years
SELECT country_code, country, left(year,4) AS year, right(year,2) AS month, round(value/1000000,2) AS monthly_value
FROM by_country_monthly_2018_2022
WHERE (right(year,2) BETWEEN '01' AND '12') AND (left(year,4) BETWEEN '2018' AND '2022');


-- Hypothesis 2 : average first half of 2022 is more than 20 million
SELECT SUM(monthly_value)
FROM (SELECT country_code, country, left(year,4) AS year, right(year,2) AS month, value AS monthly_value
FROM by_country_monthly_2018_2022
WHERE (right(year,2) BETWEEN '01' AND '06') AND (left(year,4) BETWEEN '2018' AND '2022')) abc6
WHERE year = 2022
GROUP BY country;




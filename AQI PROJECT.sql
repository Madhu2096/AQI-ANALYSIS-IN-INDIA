use aqi;
select*from aqi_final;

desc aqi_final;
select distinct City from aqi_final;
ALTER TABLE aqi_final
CHANGE `PM2.5` PM2_5 DECIMAL(10,2);

-- How many monitoring stations are active in each state

SELECT State, COUNT(DISTINCT StationId) AS total_stations
FROM aqi_final GROUP BY State;

-- Which city is most polluted on average

SELECT City, ROUND(AVG(AQI),2) AS avg_aqi
FROM aqi_final GROUP BY City ORDER BY avg_aqi DESC
LIMIT 10;

-- Which station recorded the highest AQI ever

SELECT StationId, City, MAX(AQI) AS highest_aqi
FROM aqi_final GROUP BY StationId, City
ORDER BY highest_aqi DESC;

-- Find top cities with the most Severe AQI days

SELECT City, COUNT(*) AS severe_days
FROM aqi_final WHERE AQI_Bucket = 'Severe'
GROUP BY City ORDER BY severe_days desc;

-- Find Year-wise AQI trend 

SELECT Year, ROUND(AVG(AQI),2) AS avg_aqi
FROM aqi_final GROUP BY Year ORDER BY Year;

-- Which month generally has the worst air quality

SELECT Month_Name, ROUND(AVG(AQI),2) AS avg_aqi
FROM aqi_final GROUP BY Month_Name ORDER BY avg_aqi DESC;

-- Compare AQI before VS after 2020

SELECT 
CASE 
  WHEN Year < 2020 THEN 'Before 2020'
  ELSE 'After 2020'
END AS period,ROUND(AVG(AQI),2) AS avg_aqi
FROM aqi_final GROUP BY period;

-- Rank cities based on pollution level

SELECT City,ROUND(AVG(AQI),2) AS avg_aqi,
DENSE_RANK() OVER (ORDER BY AVG(AQI) DESC) AS pollution_rank
FROM aqi_final GROUP BY City;

-- Year over year AQI change

SELECT Year,
ROUND(AVG(AQI),2) AS avg_aqi,
ROUND(AVG(AQI) - LAG(AVG(AQI)) OVER(ORDER BY Year),2) AS yoy_change 
FROM aqi_final GROUP BY Year;

-- Which pollutant has the highest average concentration

SELECT
AVG(PM2_5) AS avg_pm25,AVG(PM10) AS avg_pm10,
AVG(NO2) AS avg_no2,AVG(CO) AS avg_co FROM aqi_final;

-- separating date and time

SELECT
    CAST(Datetime AS DATE) AS Date,
    CAST(Datetime AS TIME) AS Time
FROM aqi_final;

-- List distinct cities and states

SELECT DISTINCT City, State
FROM aqi_final;

-- Data available year-wise

SELECT YEAR(Datetime) AS Year, COUNT(*) AS record_count
FROM aqi_final
GROUP BY YEAR(Datetime)
ORDER BY Year;

-- Average AQI by city

SELECT City, AVG(AQI) AS avg_aqi
FROM aqi_final
GROUP BY City
ORDER BY avg_aqi DESC;

-- Monthly AQI trend

SELECT
    YEAR(Datetime) AS Year,
    MONTH(Datetime) AS Month,
    AVG(AQI) AS avg_aqi
FROM aqi_final
GROUP BY YEAR(Datetime), MONTH(Datetime)
ORDER BY Year, Month;

-- Count of AQI buckets

SELECT AQI_Bucket, COUNT(*) AS count_records
FROM aqi_final
GROUP BY AQI_Bucket;

-- Rank cities by pollution level

SELECT
    City,
    AVG(AQI) AS avg_aqi,
    RANK() OVER (ORDER BY AVG(AQI) DESC) AS pollution_rank
FROM aqi_final
GROUP BY City;

-- Percentage of Severe AQI days per city

SELECT City,
    COUNT(CASE WHEN AQI_Bucket = 'Severe' THEN 1 END) * 100.0 / COUNT(*) AS severe_percentage
FROM aqi_final GROUP BY City;

-- Find Hour-wise AQI analysis

SELECT HOUR(Datetime) AS Hour,AVG(AQI) AS avg_aqi
FROM aqi_final GROUP BY HOUR(Datetime) ORDER BY Hour;

-- Worst pollution month each year

SELECT Year, Month, avg_aqi
FROM (SELECT
        YEAR(Datetime) AS Year,
        MONTH(Datetime) AS Month,
        AVG(AQI) AS avg_aqi,
        RANK() OVER (PARTITION BY YEAR(Datetime) ORDER BY AVG(AQI) DESC) AS rnk
    FROM aqi_final GROUP BY YEAR(Datetime), MONTH(Datetime)) t WHERE rnk = 1;

-- Most polluted station
    
SELECT StationName,City,AVG(AQI) AS avg_aqi
FROM aqi_final GROUP BY StationName, City
ORDER BY avg_aqi DESC;

-- Pre-aggregated city AQI

SELECT City,
    YEAR(Datetime) AS Year,
    AVG(AQI) AS avg_aqi
FROM aqi_final
GROUP BY City, YEAR(Datetime);

-- Records from a specific city and year

SELECT * FROM aqi_final
WHERE City = 'Delhi'
AND YEAR(Datetime) = 2020;

-- Maximum and minimum AQI per city

SELECT City,
       MAX(AQI) AS max_aqi,
       MIN(AQI) AS min_aqi
FROM aqi_final
GROUP BY City;

-- Create AQI risk category

SELECT
    City,
    AQI,
    CASE
        WHEN AQI <= 50 THEN 'Good'
        WHEN AQI <= 100 THEN 'Satisfactory'
        WHEN AQI <= 200 THEN 'Moderate'
        WHEN AQI <= 300 THEN 'Poor'
        ELSE 'Severe'
    END AS AQI_Risk
FROM aqi_final;

-- Monthly AQI trend

SELECT
    YEAR(Datetime) AS Year,
    MONTH(Datetime) AS Month,
    AVG(AQI) AS avg_aqi
FROM aqi_final
GROUP BY YEAR(Datetime), MONTH(Datetime);

-- Weekday VS Weekend AQI trend

SELECT CASE
	WHEN DAYOFWEEK(Datetime) IN (1,7) THEN 'Weekend'
	ELSE 'Weekday'
    END AS Day_Type,
    AVG(AQI) AS avg_aqi
FROM aqi_final GROUP BY Day_Type;

-- Create a View for city-level AQI 

CREATE VIEW city_aqi_summary AS
SELECT City, AVG(AQI) AS avg_aqi
FROM aqi_final
GROUP BY City;

 select * from city_aqi_summary;
select * from aqi_final;





















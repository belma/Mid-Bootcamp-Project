/* 
SQL | HOUE PRICE REGRESSION

1. Create a database called house_price_regression.
*/

CREATE DATABASE IF NOT EXISTS house_price_regression;

USE house_price_regression;

/*
2. Create a table house_price_data with the same columns as given in the csv file. Please make sure you use the correct data types for the columns.
*/

-- DROP TABLE house_price_data;
CREATE TABLE house_price_data (
    `date` DATE ,
    `bedrooms` INT,
    `bathrooms` DECIMAL,
    `sqft_living` INT,
    `sqft_lot` INT,
    `floors` DECIMAL,
    `waterfront` INT,
    `view` INT,
    `condition` INT,
    `grade` INT,
    `sqft_above` INT,
    `sqft_basement` INT,
    `yr_built` INT,
    `yr_renovated` INT,
    `zipcode` INT,
    `lat` INT,
    `long` INT,
    `sqft_living15` INT,
    `sqft_lot15` INT,
    `price` INT
    );

SELECT * FROM house_price_data;

/* 
3. Import the data from the csv file into the table. Before you import the data into the empty table, make sure that you have deleted the headers from the csv file. To not modify the original data, if you want you can create a copy of the csv file as well. Note you might have to use the following queries to give permission to SQL to import data from csv files in bulk:
SHOW VARIABLES LIKE 'local_infile'; -- This query would show you the status of the variable ‘local_infile’. If it is off, use the next command, otherwise you should be good to go
*/

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1; -- Also enable the access in Settings for Connection

LOAD DATA LOCAL INFILE '/Users/belma/Documents/IRONHACK/Lessons/Week_5/Mid_bootcamp_project/Data/cleaned_data.csv'
INTO TABLE house_price_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
	(`date`,`bedrooms`,`bathrooms`,`sqft_living`,`sqft_lot`,`floors`,`waterfront`,`view`,`condition`,`grade`,
    `sqft_above`,`sqft_basement`,`yr_built`,`yr_renovated`,`zipcode`,`lat`,`long`,`sqft_living15`,`sqft_lot15`,`price`);

/*
4. Select all the data from table house_price_data to check if the data was imported correctly.
*/

SELECT * FROM house_price_data; -- I see first row was imported wrong, with 0 in all columns
DELETE FROM house_price_data WHERE date = 0;

ALTER TABLE house_price_data
ADD COLUMN id SERIAL PRIMARY KEY FIRST;
-- Since I use the cleaned data file with dropped ID column, I  add a primary key with serial incremet as an  'id' column

SELECT * FROM house_price_data; -- works!

/* 
5. Use the alter table command to drop the column date from the database, as we would not use it in the analysis with SQL. 
Select all the data from the table to verify if the command worked. Limit your returned results to 10.
*/

ALTER TABLE house_price_data DROP COLUMN date;

SELECT * FROM house_price_data
LIMIT 10;

/*
6. Use sql query to find how many rows of data you have.
*/
SELECT COUNT(id) FROM house_price_data; -- count ID as ID is distict with the result of 2140 or
SELECT * FROM house_price_data; -- 2140 rows are returned

/*
7. Now we will try to find the unique values in some of the categorical columns:

a) What are the unique values in the column bedrooms?
b) What are the unique values in the column bathrooms?
c) What are the unique values in the column floors?
d) What are the unique values in the column condition?
e) What are the unique values in the column grade?
*/	

-- a) What are the unique values in the column bedrooms?
SELECT DISTINCT (bedrooms) FROM house_price_data
ORDER BY bedrooms; -- 1-11m is number of bedrooms

-- b) What are the unique values in the column bathrooms?
SELECT DISTINCT(bathrooms) FROM house_price_data
ORDER by bathrooms; -- 1-8 is number of bathrooms

-- c) What are the unique values in the column floors?
SELECT DISTINCT(floors) FROM house_price_data
ORDER BY floors; -- 1-4 ist the number of floors

-- d) What are the unique values in the column condition?
SELECT DISTINCT (`condition`) FROM house_price_data
ORDER BY `condition`; -- 1-5 are the bunbers for the conditin rate number 

-- e) What are the unique values in the column grade?
SELECT DISTINCT(grade) FROM house_price_data
ORDER BY grade; -- Grade exists from 3-13, 1 and 2 are not included

/*
8. Arrange the data in a decreasing order by the price of the house. Return only the IDs of the top 10 most expensive houses in your data.
*/

SELECT id, price FROM house_price_data
ORDER BY price DESC
LIMIT 10;  -- 10 several prices, outlook here make bins and distribute the percentage of prices

/*
9. What is the average price of all the properties in your data?
*/

SELECT round(AVG(price),0) AS avg_price FROM house_price_data; -- 541861 is the average price of all properties

/*
10. In this exercise we will use simple group by to check the properties of some of the categorical variables in our data

a) What is the average price of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the prices. Use an alias to change the name of the second column.
b) What is the average sqft_living of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the sqft_living. Use an alias to change the name of the second column.
c) What is the average price of the houses with a waterfront and without a waterfront? The returned result should have only two columns, waterfront and Average of the prices. Use an alias to change the name of the second column.
d) Is there any correlation between the columns condition and grade? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
*/

-- a) What is the average price of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the prices. Use an alias to change the name of the second column.
SELECT DISTINCT(bedrooms), round(AVG(price),0) AS average_price FROM house_price_data
GROUP BY bedrooms
ORDER BY bedrooms;

/* 
BEDROOMS | PRICE
	'1','321848'
	'2','402246'
	'3','467813'
	'4','636318'
	'5','789629'
	'6','839755'
	'7','951448'
	'8','1105077'
	'9','894000'
	'10','820000'
	'11','520000'
*/
-- b) What is the average sqft_living of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the sqft_living. Use an alias to change the name of the second column.
SELECT bedrooms, ROUND(AVG(sqft_living),0) AS average_sqft_living FROM house_price_data
GROUP BY bedrooms
ORDER BY bedrooms;

/*
BEDROOMS | AVG SQFT LIVING
	'1','889'
	'2','1241'
	'3','1808'
	'4','2556'
	'5','3055'
	'6','3311'
	'7','3974'
	'8','3800'
	'9','3775'
	'10','3707'
	'11','3000'
*/
-- c) What is the average price of the houses with a waterfront and without a waterfront? The returned result should have only two columns, waterfront and Average of the prices. Use an alias to change the name of the second column.
SELECT waterfront, ROUND(AVG(price),0) AS avg_price FROM house_price_data
GROUP BY waterfront
ORDER BY waterfront;

/* 
WATERFRONT | AVG PRICE
	'0','533268'
	'1','1662524'
*/

-- d) Is there any correlation between the columns condition and grade? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
SELECT 
@cond:=AVG(`condition`) as avg_condition,
@grade:=AVG(grade) as avg_grade,
@div:=(STDDEV_SAMP(`condition`) * STDDEV_SAMP(grade)) AS standart_dev
FROM house_price_data;
    
SELECT ROUND(SUM((`condition` - @cond) * (grade - @grade)) / ((COUNT(`condition`) - 1) * @div),3) AS correlation_score
FROM house_price_data; -- There is a negative correlation of -0,151

/*
11. One of the customers is only interested in the following houses:
- Number of bedrooms either 3 or 4
- Bathrooms more than 3
- One Floor
- No waterfront
- Condition should be 3 at least
- Grade should be 5 at least
- Price less than 300000
For the rest of the things, they are not too concerned. 
Write a simple query to find what are the options available for them?
*/       

SELECT * FROM house_price_data
WHERE bedrooms IN (3, 4) 
AND bathrooms > 3 
AND floors = 1 
AND waterfront = 0 
AND`condition` >= 3 
AND grade >= 5 
AND price < 300000; -- this customer expects too much, no property available. 

/*
12. Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database. 
Write a query to show them the list of such properties. 
You might need to use a sub query for this problem.
*/

SELECT id, price FROM house_price_data
WHERE price > (
	SELECT (AVG(price) * 2) FROM house_price_data)
ORDER BY price ASC; -- 1240 prperties are double the average price 

/*
13. Since this is something that the senior management is regularly interested in, create a view of the same query.
*/ 

create view house_price AS (
	SELECT id, price from house_price_data
	WHERE price > (
		SELECT (AVG(price) * 2) FROM house_price_data)
        );

SELECT * FROM house_price;

/*
14. Most customers are interested in properties with three or four bedrooms. 
What is the difference in average prices of the properties with three and four bedrooms?
*/

SELECT round((AVG(four.price) - AVG(three.price)),2) AS diff_avg_price
FROM house_price_data AS three
INNER JOIN house_price_data AS four
WHERE three.bedrooms = 3
AND four.bedrooms = 4
GROUP BY four.bedrooms;

/*
15. What are the different locations where properties are available in your database? (distinct zip codes)
*/

SELECT DISTINCT (zipcode) AS location from house_price_data; -- 70 different zipcodes

/*
16. Show the list of all the properties that were renovated.
*/

SELECT DISTINCT (yr_renovated) AS renovated from house_price_data; -- 0 is not renovated
SELECT COUNT(id) FROM house_price_data
WHERE yr_renovated > 0;  -- 910 properties have a renovation year 

/*
17. Provide the details of the property that is the 11th most expensive property in your database.
*/

SELECT * FROM (
	SELECT *, RANK() OVER (ORDER BY price DESC) AS ranking 
    FROM house_price_data) AS rank_table
WHERE ranking = 11;

/*
'11951','5','6','7440','21540','2','0','0','3','12','5550','1890','2003','0','98006','47.5692','-122.189','4740','19329','4210000','11'
*/

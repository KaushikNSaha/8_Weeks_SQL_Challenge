-- creating database and Table

CREATE DATABASE Pizza_Runner


USE Pizza_Runner
GO

DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  "runner_id" INTEGER,
  "registration_date" DATE
);
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" SMALLDATETIME
);

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

INSERT INTO runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);
INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');

select *
from Pizza_Runner..customer_orders;

select *
from Pizza_Runner..pizza_names;

select *
From Pizza_Runner..pizza_toppings;

select *
from Pizza_Runner..runner_orders;

select *
from Pizza_Runner..runners;

-- Data cleaning Task

-- Problems with Null values and data types in customer_orders and runner_orders table

select *
from Pizza_Runner..customer_orders;


select *
from Pizza_Runner..customer_orders
Where exclusions is NULL and extras is NULL;


-- cleaning customer_orders table

Select 
	exclusions,
	CASE 
		WHEN exclusions = '' THEN NULL
		WHEN exclusions = 'null' THEN NULL
		else exclusions
		END as exclusionCleaned,
	extras,
	CASE 
		WHEN extras = '' THEN NULL
		WHEN extras = 'NULL' THEN NULL
		WHEN exclusions = 'null' THEN NULL
		Else extras
		END as extrasCleaned
From Pizza_Runner..customer_orders


Alter TABLE Pizza_Runner..customer_orders
ADD exclusionCleaned varchar(4);

Update Pizza_Runner..customer_orders
SET exclusionCleaned = CASE 
		WHEN exclusions = '' THEN NULL
		WHEN exclusions = 'null' THEN NULL
		else exclusions
		END;

Alter TABLE Pizza_Runner..customer_orders
ADD extrasCleaned varchar(4);

Update Pizza_Runner..customer_orders
SET extrasCleaned = CASE 
		WHEN extras = '' THEN NULL
		WHEN extras = 'NULL' THEN NULL
		WHEN exclusions = 'null' THEN NULL
		Else extras
		END;


-- cleaning runners order table

select *
from Pizza_Runner..runner_orders;


select *
from Pizza_Runner..runner_orders
WHERE 
	pickup_time is null or 
	distance is null or
	duration is null or
	cancellation is null;

-- too many place to clean. Using a temp table for cleaning purpose

DROP TABLE if exists #runner_orders_cleaned;

Create TABLE #runner_orders_cleaned(
order_id int,
runner_id int,
pickup_time_cleaned datetime,
distance_kilometer numeric,
duration_minutes numeric,
cancellation nvarchar(35)
)

INSERT INTO #runner_orders_cleaned
SELECT 
	order_id,
	runner_id,
	CASE
		WHEN pickup_time = 'null' THEN NULL
		ELSE pickup_time
		END as pickup_time_cleaned,
	CASE
		WHEN distance like '%km%' THEN TRIM('km' from distance)
		WHEN distance = 'null' THEN NULL
		ELSE distance
	END as distance_kilometer,
	CASE
		WHEN duration = 'null' THEN NULL
		WHEN duration = 'null' THEN NULL
		WHEN duration like '%minutes%' THEN TRIM('minutes' FROM duration)
		WHEN duration like '%minute%' THEN TRIM('minute' FROM duration)
		WHEN duration like '%mins%' THEN TRIM('mins' FROM duration)
		ELSE duration
		END as duration_minutes,
	CASE
		WHEN cancellation = 'null' THEN NULL
		WHEN cancellation = '' THEN NULL
		ELSE cancellation
	END as cancellation
FROM Pizza_Runner..runner_orders;

select * 
from #runner_orders_cleaned


-- check if any row has any whitespace

--WITH dur as
--(
--select
--	CASE
--		WHEN duration = 'null' THEN NULL
--		WHEN duration like '%minutes' THEN TRIM('minutes' FROM duration)
--		WHEN duration like '%minute' THEN TRIM('minute' FROM duration)
--		WHEN duration like '%mins' THEN TRIM('mins' FROM duration)
--		ELSE duration
--		END as duration_min
--FROM Pizza_Runner..runner_orders
--)
--select *
--from dur
--where len(duration_min) > 2


-- doesn't work properly
--select
--	duration,
--	SUBSTRING(duration, PATINDEX('%[0-9]%', duration), PATINDEX('%[a-z ]%', duration))
--FROM Pizza_Runner..runner_orders


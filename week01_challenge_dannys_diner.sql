-- create database Danny's Diner

CREATE DATABASE Dannys_Diner;


-- create table
USE Dannys_Diner
Go


CREATE TABLE sales
(
customer_id varchar(1),
order_date DATE,
product_id int
);

CREATE TABLE members
(
customer_id varchar(1),
join_date DATE
);


CREATE TABLE menu
(
product_id int,
product_name varchar(5),
price int
);

Go

-- Inserting Data in the tables

-- The menu table maps the product_id to the actual product_name and price of each menu item.

INSERT INTO sales VALUES
('A', '2021-01-01', 1),
('A', '2021-01-01', 2),
('A', '2021-01-07', 2),
('A', '2021-01-10', 3),
('A', '2021-01-11', 3),
('A', '2021-01-11', 3),
('B', '2021-01-01', 2),
('B', '2021-01-02', 2),
('B', '2021-01-04', 1),
('B', '2021-01-11', 1),
('B', '2021-01-16', 3),
('B', '2021-02-01', 3),
('C', '2021-01-01', 3),
('C', '2021-01-01', 3),
('C', '2021-01-07', 3);


-- The menu table maps the product_id to the actual product_name and price of each menu item.

INSERT INTO menu VALUES
(1, 'sushi', 10),
(2, 'curry', 15),
(3, 'ramen', 12);


-- The final members table captures the join_date when a customer_id 
-- joined the beta version of the Danny’s Diner loyalty program.

INSERT INTO members VALUES
('A', '2021-01-07'),
('B', '2021-01-09');

select * 
From Dannys_Diner..sales;

select * 
From Dannys_Diner..menu;

select * 
From Dannys_Diner..members;


-- CASE STUDY QUESTION 01
-- What is the total amount each customer spent at the restaurant?

/*
In this question I used a aggregate function to find the total amount spent by all customer.
*/



select sal.customer_id, sum(menu.price) as amount_spent
From Dannys_Diner..sales sal
join Dannys_Diner..menu menu
	ON sal.product_id = menu.product_id
GROUP BY sal.customer_id
ORDER BY 2 DESC;


/* Solution

customer_id		amount_spent
		A			76
		B			74
		C			36

The solution shows that customer A spent the most $76 during his visit to Danny's Diner.
*/



-- CASE STUDY QUESTION 02
-- How many days has each customer visited the restaurant?

/*
For question 02 I used count function to find the distinct number of the days the customer
visited Danny's Diner. I assumed the customers ordered multiple items in case the 
order date is same.
*/


select customer_id, count(distinct order_date) as days_visited
from Dannys_Diner..sales
group by customer_id
order by 2 desc;

/* Solution
customer_id    days_visited
		B			6
		A			4
		C			2

*/


-- CASE STUDY QUESTION 03
-- What was the first item from the menu purchased by each customer?

/*
In question 03, I used row number function to partition the customer id according to
order date. So each item is ranked according to the row number. 

Then I used CTE to select only the item that ranked first in the list.
*/

WITH first_order as 
(select 
	s.customer_id as cus_id, s.product_id ,m.product_name as item_name, 
	ROW_NUMBER() OVER (Partition BY s.customer_id ORDER BY s.order_date) as item_ordered
from Dannys_Diner..sales s
Join Dannys_Diner..menu m
	ON s.product_id = m.product_id)

select cus_id, item_name as first_item_ordered
From first_order
Where item_ordered = 1;

/* Solution

cus_id	first_item_ordered
	A		sushi
	B		curry
	C		ramen

*/


-- CASE STUDY QUESTION 04
-- What is the most purchased item on the menu and how many times was it purchased by all customers?

/*
In question 04, I used aggregate function to count each items ordered by each customer.
Then I used CTE to find the sum of all the items and selected only the top 1 to find
the most purchased item.

*/

WITH items_purchased as
(select 
	s.customer_id, m.product_name as item_name, 
	count(s.product_id) as times_ordered
from Dannys_Diner..sales s
Join Dannys_Diner..menu m
	ON s.product_id = m.product_id
Group by s.customer_id, m.product_name)

SELECT TOP (1)[item_name], sum(times_ordered) as number_of_times_ordered
FROM items_purchased
GROUP BY item_name
ORDER BY 2 DESC;

/* Solution
item_name	number_of_times_ordered
  ramen				8

Seems that, Ramen is the most purchased item in the menu. It was purchased 8 times.

*/


-- CASE STUDY QUESTION 05
-- Which item was the most popular for each customer?

/*
My Solution to this question is not totally correct. Although I couldn't find
most popular item for each customer perfectly, I counted the number of times 
each items was ordered by each customer and ordered them in descending order.
*/

select 
	s.customer_id as cus_id,
	m.product_name as item_name, 
	count(s.product_id) as times_ordered
from Dannys_Diner..sales s
Join Dannys_Diner..menu m
	ON s.product_id = m.product_id
Group by s.customer_id, m.product_name
order by 3 DESC;


/* Solution

cus_id	item_name	times_ordered
	A	 ramen			3
	C	 ramen			3
	B	 sushi			2
	B	 ramen			2
	A	 curry			2
	B	 curry			2
	A	 sushi			1

It seems Ramen is most popular item for Customer A and C whereas customer B ordered all the
items equally.

*/



-- CASE STUDY QUESTION 06
-- Which item was purchased first by the customer after they became a member?

/*
For question 06 I joined all the tables and ranked the purchased items according to
order date. I added a filter where the order date has to be after the customer
joined the loyalty program. I didn't include the purchased items of the joining date.

Then used CTE to select only the items which ranked 1 on the customers ordered 
item after joining the program.
*/


WITH order_after_membership as 
(SELECT 
	s.customer_id as customer,
	mem.join_date as membership_date,
	s.order_date as order_date,
	m.product_name as item_ordered,
	RANK() OVER (Partition by s.customer_id Order by s.order_date) as Rank
FROM Dannys_Diner..sales s
Join Dannys_Diner..members mem
	ON s.customer_id = mem.customer_id
	Join Dannys_Diner..menu m
		ON s.product_id = m.product_id
WHERE s.order_date > mem.join_date
)
SELECT customer, membership_date, order_date, item_ordered
From order_after_membership
WHERE Rank = 1;


/*
customer	membership_date		order_date		item_ordered
	A			1/7/2021		1/10/2021			ramen
	B			1/9/2021		1/11/2021			sushi

After becoming a member customer A bought 'Ramen' while customer B bought 'Sushi'.
*/



-- CASE STUDY QUESTION 07
-- Which item was purchased just before the customer became a member?

/*
For question 07 I joined all the tables and ranked the purchased items according to
descending order date. I added a filter where the order date has to be before the customer
joined the loyalty program. I didn't include the purchased items of the joining date.

Then used CTE to select only the items which ranked 1 on the customers ordered 
item before joining the program.

*/


WITH order_after_membership as 
(SELECT 
	s.customer_id as customer,
	mem.join_date as membership_date,
	s.order_date as order_date,
	m.product_name as item_ordered,
	RANK() OVER (Partition by s.customer_id Order by s.order_date DESC) as Rank
FROM Dannys_Diner..sales s
Join Dannys_Diner..members mem
	ON s.customer_id = mem.customer_id
	Join Dannys_Diner..menu m
		ON s.product_id = m.product_id
WHERE s.order_date < mem.join_date
)
SELECT customer, membership_date, order_date, item_ordered
From order_after_membership
WHERE Rank = 1;

/* Solution

customer	membership_date		order_date		item_ordered
	A		 1/7/2021			 1/1/2021		 sushi
	A		 1/7/2021			 1/1/2021		 curry
	B		 1/9/2021			 1/4/2021		 sushi

The solution shows that Customer B bought Sushi before he became a member 
while Customer A bought both Curry and Sushi.

*/




-- CASE STUDY QUESTION 08
-- What is the total items and amount spent for each member before they became a member?

/*
For solution 08 I joined all the tables and filtered the amount spent before they become
member of Danny's diner. I didn't include the item purchased the day they become member.

Then I used CTE to aggregate the amount spent for each member. 

*/

WITH items_bought as
(SELECT 
	s.customer_id as customer,
	mem.join_date as membership_date,
	s.order_date as order_date,
--	m.product_name as item_ordered,
	m.price as price
FROM Dannys_Diner..sales s
Join Dannys_Diner..members mem
	ON s.customer_id = mem.customer_id
	Join Dannys_Diner..menu m
		ON s.product_id = m.product_id
WHERE s.order_date < mem.join_date)

SELECT customer, membership_date, sum(price) as spent_before_membership
From items_bought
GROUP BY customer, membership_date
order by spent_before_membership DESC;

/* Solution

customer	membership_date		spent_before_membership
	B			1/9/2021				40
	A			1/7/2021				25

Customer B spent $40 before he/she became a member while Customer A spent $25 
before becoming a member.


*/


-- CASE STUDY QUESTION 09

-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how 
-- many points would each customer have?

/*
In question 09 I created a point system for all the items. First, I used a case statement
to indicate how many point can be earned by buying each items. 

Later I used A CTE to sum all the points earned by each customer against every 
dollar they spent.
*/


WITH point_earned as
(SELECT 
	s.customer_id as customer,
	Case
		WHEN s.product_id = 2 THEN m.price * 10
		WHEN s.product_id = 3 THEN m.price * 10
		ELSE m.price * 10 * 2
	END as points
FROM Dannys_Diner..menu m
JOIN Dannys_Diner..sales s
	ON s.product_id = m.product_id)

SELECT customer, sum(points) as points_earned
FROM point_earned
Group by customer
order by 2 DESC;


/*
customer	points_earned
	B			940
	A			860
	C			360

Seems to me that Customer B earned the highest 940 points.

*/



-- CASE STUDY QUESTION 10
-- In the first week after a customer joins the program (including their join date) 
-- they earn 2x points on all items, not just sushi - how many points do customer A
-- and B have at the end of January?

/*
In question 10 I used case statement to create several different conditions. 

-1st condition states that before joining the program all items except Sushi will earn 10 point
for each dollar spent. 

-The 2nd condition states that after joining the loyalty program to one week after that all the 
item will earn 2x points. 

-The 3rd Condition states that from 1st week after joining the loyalty program all items except 
Sushi will return to their original point system.

-The 4th condition states that Sushi will always get you 2x points.

-As the problem statement indicated, I filtered the points only upto January. Didn't Include the
data from February.

Later I used A CTE to sum all the point each members earned.

*/


WITH members_point as
(SELECT 
	s.customer_id as customer,
	a.join_date,
	s.order_date,
	CASE 
		WHEN s.order_date < a.join_date and b.product_id <> 1 THEN price * 10
		WHEN s.order_date between a.join_date and DATEADD(day, 7, a.join_date) THEN price * 10 * 2
		WHEN s.order_date > DATEADD(day, 7, a.join_date) and b.product_id <> 1 THEN price * 10
		ELSE price * 10 * 2
	END as points
FROM Dannys_Diner..sales s
JOIN Dannys_Diner..members a
	ON s.customer_id = a.customer_id
	JOIN Dannys_Diner..menu b
		ON s.product_id = b.product_id
WHERE s.order_date < '2021-02-01' 
)

SELECT customer, sum(points) as members_point
FROM members_point
GROUP BY customer
order by 2 DESC;

/* Solution

customer	members_point
	A			1370
	B			940

Seems to me that Customer A is the clever one. He purchased A lot of items during 1 week
after he/she become a loyal member. 
*/


-- BONUS QUESTION 01
-- JOIN ALL THE THINGS AND RECREATE TABLE

/*
Bonus question 01 provides a quick insight to all the data in the 
database. The table shows whether the customer is a member of the Diner while 
he/ she was ordering the food.

I used Full outer join to include all the data in the tables and several case 
statement to find out if the customer is the member of the diner.
*/


SELECT 
	s.customer_id as customer_id,
	s.order_date as order_date,
	m.product_name as product_name,
	m.price as price,
	Case
		WHEN mm.customer_id IS NULL THEN 'N'
		WHEN s.order_date < mm.join_date THEN 'N'
		ELSE 'Y'
	END as member
FROM Dannys_Diner..sales s
FULL OUTER JOIN Dannys_Diner..menu m
	ON s.product_id = m.product_id
	FULL OUTER JOIN Dannys_Diner..members mm
 		ON s.customer_id = mm.customer_id;

/* Solution

customer_id		order_date		product_name	price	member
	A			1/1/2021			sushi		 10		 N
	A			1/1/2021			curry		 15		 N
	A			1/7/2021			curry		 15		 Y
	A			1/10/2021			ramen		 12		 Y
	A			1/11/2021			ramen		 12		 Y
	A			1/11/2021			ramen		 12		 Y
	B			1/1/2021			curry		 15		 N
	B			1/2/2021			curry		 15		 N
	B			1/4/2021			sushi		 10		 N
	B			1/11/2021			sushi		 10		 Y
	B			1/16/2021			ramen		 12		 Y
	B			2/1/2021			ramen		 12		 Y
	C			1/1/2021			ramen		 12		 N
	C			1/1/2021			ramen		 12		 N
	C			1/7/2021			ramen		 12		 N

*/


-- BONUS QUESTION 02
-- Danny also requires further information about the ranking of customer products,
-- but he purposely does not need the ranking for non-member purchases so he expects
-- null ranking values for the records when customers are not yet part of the loyalty program.

/*
For Bonus question 02 I couldn't match properly with the required output mentioned in 
the challenge page. 

I used full outer join to join all the tables and used 2 case statement.

For the ranking system I ordered the data according the order date which doesn't match 
the desired output. 


*/

SELECT 
	s.customer_id as customer_id,
	s.order_date as order_date,
	m.product_name as product_name,
	m.price as price,
	Case
		WHEN mm.customer_id IS NULL THEN 'N'
		WHEN s.order_date < mm.join_date THEN 'N'
		ELSE 'Y'
	END as member,
	CASE
		WHEN s.order_date >= mm.join_date THEN RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date)
		WHEN s.order_date < mm.join_date THEN null
		ELSE null
	END as ranking
FROM Dannys_Diner..sales s
FULL OUTER JOIN Dannys_Diner..menu m
	ON s.product_id = m.product_id
	FULL OUTER JOIN Dannys_Diner..members mm
 		ON s.customer_id = mm.customer_id;

/* Solution

customer_id		order_date	product_name	price	member	ranking
	A			1/1/2021		sushi		10		 N		 NULL
	A			1/1/2021		curry		15		 N		 NULL
	A			1/7/2021		curry		15		 Y		 3
	A			1/10/2021		ramen		12		 Y		 4
	A			1/11/2021		ramen		12		 Y		 5
	A			1/11/2021		ramen		12		 Y		 5
	B			1/1/2021		curry		15		 N		 NULL
	B			1/2/2021		curry		15		 N		 NULL
	B			1/4/2021		sushi		10		 N		 NULL
	B			1/11/2021		sushi		10		 Y		 4
	B			1/16/2021		ramen		12		 Y		 5
	B			2/1/2021		ramen		12		 Y		 6
	C			1/1/2021		ramen		12		 N		 NULL
	C			1/1/2021		ramen		12		 N		 NULL
	C			1/7/2021		ramen		12		 N		 NULL

The last solution doesn't match the required output provided by Danny Ma.
Feel free to add your opinion in this question.
*/

/*
Key Insights:

1. Ramen seems to be the most popular dish in Danny's Diner. So far, after ordering 
Ramen the customers didn't order any other dish. More observation required in this case.

2. Sushi seems to be the most unpopular dish. Customer A ordered it only once and didn't 
order it anymore.
Although Customer B ordered it 2 times, he/she ordered all the items twice.
Looks like Customer C likes the Ramen too much.

3. Customer A seems to be the most loyal customer. He became a member just after 2 purchase.
Customer B is the most regular loyal customer. He/she came by most often.
More effort needs to be put in for Customer C. He/she purchased 3 times but didn't become a member.

*/





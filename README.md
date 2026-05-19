# 8 Week SQL Challenge

Solutions to the **8 Week SQL Case Study Challenge** created by [Danny Ma](https://8weeksqlchallenge.com/).

> "Each case study includes a business problem, dataset, and a set of questions to answer using SQL — simulating real-world analytics scenarios."

**Tool used:** Microsoft SQL Server (T-SQL)  
**Author:** Kaushik Nandan Saha · [LinkedIn](https://www.linkedin.com/in/knsaha/) · [Portfolio](https://kaushiknsaha.com)

---

## Progress

| Case Study | Title | Status | Key Concepts |
|:---:|---|:---:|---|
| #1 | [Danny's Diner](#case-study-1--dannys-diner) | ✅ Complete | JOINs, CTEs, Window Functions, CASE |
| #2 | [Pizza Runner](#case-study-2--pizza-runner) | 🔄 In Progress | Data Cleaning, CTEs, String Functions |
| #3 | Foodie-Fi | 🔜 Upcoming | — |
| #4 | Data Bank | 🔜 Upcoming | — |
| #5 | Data Mart | 🔜 Upcoming | — |
| #6 | Clique Bait | 🔜 Upcoming | — |
| #7 | Balanced Tree Clothing | 🔜 Upcoming | — |
| #8 | Fresh Segments | 🔜 Upcoming | — |

---

## Case Study #1 — Danny's Diner

📁 [`week01_challenge_dannys_diner.sql`](week01_challenge_dannys_diner.sql)

### Business Context
Danny wants to use data from his Japanese restaurant to understand customer visiting patterns, spending habits, and favourite menu items — to decide whether to expand the loyalty programme.

### Entity Relationship Diagram

```
sales                    menu                  members
─────────────────        ──────────────────    ──────────────────
customer_id VARCHAR  ──► product_id INT (PK)   customer_id VARCHAR
order_date  DATE         product_name VARCHAR   join_date   DATE
product_id  INT ─────►   price       INT
```

### Questions Answered

| # | Question | SQL Concepts Used |
|---|---|---|
| 1 | Total amount spent per customer | JOIN, SUM, GROUP BY |
| 2 | Number of days each customer visited | COUNT DISTINCT |
| 3 | First item purchased by each customer | CTE, ROW_NUMBER |
| 4 | Most purchased item overall | CTE, COUNT, TOP |
| 5 | Most popular item per customer | JOIN, COUNT, GROUP BY |
| 6 | First item purchased after membership | CTE, RANK, WHERE date filter |
| 7 | Item purchased just before membership | CTE, RANK DESC |
| 8 | Total spend before membership | CTE, SUM, WHERE date filter |
| 9 | Points calculation (sushi 2x multiplier) | CTE, CASE WHEN |
| 10 | Points in first week of membership (2x all) | CTE, CASE WHEN, DATEADD |
| B1 | Recreate full joined table with member flag | FULL OUTER JOIN, CASE |
| B2 | Ranking for members only | RANK, CASE WHEN NULL |

---

## Case Study #2 — Pizza Runner

📁 [`Week02ChallangePizzaRunner/`](Week02ChallangePizzaRunner/)

### Business Context
Danny launched a pizza delivery service using Uber-style runners. Data needs cleaning before analysis — raw tables contain inconsistent nulls, mixed units, and formatting issues.

### Entity Relationship Diagram

```
runners                  customer_orders            pizza_names
──────────────────       ───────────────────────    ─────────────────
runner_id INT (PK)       order_id   INT             pizza_id INT (PK)
registration_date DATE   customer_id INT            pizza_name TEXT
                         pizza_id    INT ─────────►
runner_orders            exclusions  VARCHAR        pizza_recipes
──────────────────       extras      VARCHAR        ─────────────────
order_id   INT           order_time  DATETIME       pizza_id  INT (PK)
runner_id  INT ──►                                  toppings  VARCHAR
pickup_time DATETIME     pizza_toppings
distance   VARCHAR       ─────────────────          
duration   VARCHAR       topping_id   INT (PK)
cancellation VARCHAR      topping_name VARCHAR
```

### Questions Answered
-> Coming Soon

---

## Resources

- 🌐 [8weeksqlchallenge.com](https://8weeksqlchallenge.com/) — original challenge by Danny Ma
- 📊 [My Portfolio](https://kaushiknsaha.com) — other data projects
- 💼 [LinkedIn](https://www.linkedin.com/in/knsaha/)

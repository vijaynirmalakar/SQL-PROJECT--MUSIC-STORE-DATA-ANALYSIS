# Music Store Data Analysis — SQL Project
> Analyzed a digital music store database using MySQL across 11 relational tables to answer 8 business questions spanning Easy, Moderate, and Advanced SQL — including CTEs, subqueries, multi-table JOINs, and window-function-style logic for tie-handling.

---

## Problem
A music store wants to use its sales and customer data to make smarter business decisions:
- Which cities and countries generate the most revenue — and where to host events?
- Who are the best customers, and how much do they spend per artist?
- Which music genres are most popular in each country?
- Which artists should be invited for promotions based on track volume?

This project answers all these questions using structured SQL queries on a real relational database.

---

## Database Schema
The database contains 11 tables with the following relationships:

<img width="594" height="598" alt="schema_diagram" src="https://github.com/user-attachments/assets/ff7eed87-118b-4b3b-afc4-02be8e0297e0" />


| Table | Description |
|---|---|
| `employee` | Store staff with hierarchy (reports_to) |
| `customer` | Customer contact and location details |
| `invoice` | Purchase records with billing info and totals |
| `invoice_line` | Line items per invoice (track, price, quantity) |
| `track` | Song details including duration and price |
| `album` | Album metadata linked to artists |
| `artist` | Artist names |
| `genre` | Music genre classification |
| `playlist` | Named playlists |
| `playlist_track` | Many-to-many: playlists ↔ tracks |
| `media_type` | Audio format types |

---

## Tools Used
`MySQL` `SQL` `CTEs (WITH clause)` `Subqueries` `Aggregate Functions` `Multi-table JOINs` `Window Logic`

---

## Questions Solved

### Set 1 — Easy
| # | Question | SQL Concepts Used |
|---|---|---|
| 1 | Senior-most employee by job title | ORDER BY, LIMIT |
| 2 | Countries with the most invoices | GROUP BY, COUNT, ORDER BY |
| 3 | Top 3 invoice values | ORDER BY DESC, LIMIT |
| 4 | Best city for a music festival (highest revenue) | GROUP BY, SUM, ORDER BY, LIMIT |
| 5 | Best customer by total spending | JOIN, GROUP BY, SUM, ORDER BY, LIMIT |

### Set 2 — Moderate
| # | Question | SQL Concepts Used |
|---|---|---|
| 1 | Rock music listeners (email, name, genre) | 5-table JOIN, WHERE filter, DISTINCT, ORDER BY |
| 2 | Top 10 rock artists by track count | 4-table JOIN, GROUP BY, COUNT, ORDER BY, LIMIT |
| 3 | Tracks longer than average song length | Subquery in WHERE, ORDER BY DESC |

### Set 3 — Advanced
| # | Question | SQL Concepts Used |
|---|---|---|
| 1 | Customer spending per artist (best-selling artist only) | CTE, 6-table JOIN, ROUND, GROUP BY |
| 2 | Most popular genre per country (with tie-handling) | 2-CTE chain, COUNT, MAX, JOIN for tie resolution |
| 3 | Top spending customer per country (with tie-handling) | 2-CTE chain, SUM, MAX, JOIN for tie resolution |

---

## Process

1. **Schema Understanding** — Mapped all 11 tables and their relationships; identified primary and foreign keys
2. **Query Planning** — Broke each question into logical steps before writing SQL
3. **Easy Queries** — Used basic aggregations, GROUP BY, ORDER BY, and LIMIT to answer 5 business questions
4. **Moderate Queries** — Used multi-table JOINs (up to 5 tables) and subqueries to filter and rank data
5. **Advanced Queries** — Used CTEs (WITH clause) to create reusable intermediate result sets; handled tie-breaking logic by joining max-value CTEs back to the main dataset
6. **Code Organisation** — Structured all queries with clear comments, step labels inside CTEs, and consistent formatting

---

## Key SQL Techniques Demonstrated

- **Multi-table JOINs** — up to 6 tables joined in a single query (customer → invoice → invoice_line → track → album → artist)
- **CTEs (Common Table Expressions)** — used in all 3 advanced queries; chained 2 CTEs in Q2 and Q3 to isolate best-selling artist, then max purchases/spending per country
- **Subquery in WHERE clause** — used in Set 2 Q3 to compare each track's duration against the computed average
- **Tie-handling logic** — instead of LIMIT 1 (which drops ties), used CTE + JOIN to return ALL rows matching the maximum value per group
- **DISTINCT** — used to avoid duplicate customer rows when joining through multiple transaction tables
- **ROUND()** — applied consistently to all monetary calculations for clean output
- **USING clause** — used for clean JOIN syntax when column names match across tables

---

## Project Structure
```
music-store-sql-analysis/
├── SQL_PROJECT_MUSIC_STORE_DATA_ANALYSIS.sql   # All 8 queries with comments
├── schema.png                                   # Database schema diagram
└── README.md                                    # This file
```

---

## How to Run
```sql
-- 1. Create and select the database
CREATE DATABASE music_store;
USE music_store;

-- 2. Import the dataset (use MySQL Workbench or CLI)
-- source /path/to/music_store_data.sql

-- 3. Run any query from the .sql file
```

---

## Author
**Vijay Nirmalakar**
[[LinkedIn Profile](https://www.linkedin.com/in/vijaynirmalakar/)] | [[GitHub Profile](https://github.com/vijaynirmalakar)]

*Tools: MySQL | Skills: SQL Querying, Multi-table JOINs, CTEs, Subqueries, Business Analysis*

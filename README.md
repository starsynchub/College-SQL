# College Database - SQL Assignment

A relational database for managing college students, courses, and societies, built as a SQL assignment. It covers database design, data manipulation, queries, and database administration.

## Database Overview

The `college` database has five tables:

- STUDENT: student details (Rollno, Name, Dateofbirth)
- COURSE: courses offered (SID, Cname, TotalSeats, Duration, Coursetype, TeacherInCharge)
- SOCIETY: college societies (SocID, Socname, Mentor, TotalSeats)
- ADMISSION: links students to courses (Rollno, SID, Dateofadmission)
- ENROLLMENT: links students to societies (Rollno, SocID, Dateofenrollment)

ADMISSION and ENROLLMENT are junction tables with composite primary keys and foreign keys to the tables they link.

## What's Included

- Table creation (DDL) with primary keys, foreign keys, UNIQUE and CHECK constraints
- Sample data for all tables
- 25 queries using JOINs, subqueries, GROUP BY / HAVING, LIKE, UNION, and views
- ALTER and UPDATE statements
- Database administration: users, roles, GRANT / REVOKE, and indexes

## Concepts Covered

- Inner and LEFT JOINs
- Aggregate functions (COUNT, MAX) and grouping
- Subqueries and NOT EXISTS
- Views
- Date functions
- Referential integrity (ON DELETE CASCADE / RESTRICT)
- Access control with roles and privileges

## How to Run

1. Open your SQL client (MySQL Workbench, command line, etc.).
2. Open `College.sql`.
3. Run the script from top to bottom, since tables must be created before the tables that reference them.
4. Run the queries and check the output.

## Tech

- Database: MySQL 8.0.16 or later (CHECK constraints need this version)

## Author

Your Name

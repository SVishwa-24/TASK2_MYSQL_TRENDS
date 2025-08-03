# TASK2_MYSQL_TRENDS
# Health Analysis Project

## Overview

This project provides a comprehensive health analysis of a hypothetical clinic's patient data using SQL. The primary goal is to extract meaningful insights into patient trends, common health issues, and individual patient health metrics. The analysis is performed using advanced SQL concepts, including **Window Functions**, **Subqueries**, and **Common Table Expressions (CTEs)**, to demonstrate a powerful approach to data analysis.

The project is designed to be a learning tool for anyone interested in applying advanced SQL to a real-world, albeit simplified, health dataset.

## Features

* **Monthly Visit Trends:** Analyze patient visit frequency and month-over-month changes.
* **Top Clinic Issues:** Identify the most common reasons for patient visits.
* **Doctor Performance:** Rank doctors based on their patient visit count.
* **Patient Demographics:** Track patient registrations over time.
* **Health Risk Identification:** Use advanced queries to flag patients with high-risk health markers (e.g., high blood sugar).

## Technologies Used

* **SQL (MySQL / SQL Server):** The core of the project. The provided code is written to be compatible with both MySQL and SQL Server, with minor syntax differences noted in the comments.
* **Markdown:** Used for this `README.md` file to provide clear and well-structured documentation.

## Database Schema

The analysis is based on the following simplified database schema. The SQL code includes `CREATE TABLE` statements for easy setup.

* `Patients`: Stores patient demographic information.
    * `patient_id` (Primary Key)
    * `gender`
    * `birth_year`
    * `registered_date`
    * `city`
* `Visits`: Records each patient's clinic visit.
    * `visit_id` (Primary Key)
    * `patient_id` (Foreign Key)
    * `visit_date`
    * `doctor_id` (Foreign Key)
    * `reason_for_visit`
* `Doctors`: Stores doctor details.
    * `doctor_id` (Primary Key)
    * `doctor_name`
    * `specialty`
* `Lab_Results`: Contains specific lab test results from a visit.
    * `result_id` (Primary Key)
    * `visit_id` (Foreign Key)
    * `test_name`
    * `result_value`

## Getting Started

Follow these steps to set up the project and run the analysis.

### Prerequisites

* A running instance of a SQL database (MySQL or SQL Server).
* A SQL client or command-line tool (e.g., MySQL Workbench, SQL Server Management Studio, DBeaver, or `mysql` client).

### Installation and Setup

1.  **Clone the repository:**
    (Note: Since this is a conceptual project, you can simply copy the SQL code.)

2.  **Create the Database and Tables:**
    * Open the SQL file.
    * Run the `CREATE TABLE` and `INSERT INTO` statements to set up the dummy database schema and populate it with sample data. This will create a local environment to test the queries.

3.  **Run the Analysis Queries:**
    * Execute each of the five analysis queries provided in the SQL file, one by one.
    * For each query, observe the results and the insights they provide.

## Analysis Queries

The project includes five key analysis queries, each with a specific purpose.

### 1. Monthly Visits Trend

* **Purpose:** Track patient visits per month and calculate the percentage change from the previous month.
* **Concepts:** `DATE_FORMAT` (or equivalent), `COUNT()`, and the `LAG()` Window Function.

### 2. Busiest Doctors

* **Purpose:** Identify the top doctors by the number of visits they've conducted.
* **Concepts:** `GROUP BY`, `COUNT()`, and `ORDER BY` with a `LIMIT` (or `TOP`).

### 3. Top Reasons for Visits

* **Purpose:** Pinpoint the most common health concerns or reasons for patient visits.
* **Concepts:** `GROUP BY`, `COUNT()`, `ORDER BY`, and `LIMIT` (or `TOP`).

### 4. Patient Registrations by Year

* **Purpose:** Understand patient acquisition trends by counting how many new patients registered each year.
* **Concepts:** `DATE_FORMAT` (or equivalent) and a Common Table Expression (CTE) for improved readability.

### 5. Patients with High Blood Sugar on First Test

* **Purpose:** Proactively identify patients at risk for conditions like diabetes by finding those whose initial blood sugar reading was above a certain threshold.
* **Concepts:** CTEs, `ROW_NUMBER()` Window Function, and conditional filtering (`WHERE`).

## How to Contribute

This project is intended as a conceptual guide. However, if you would like to expand on it, you could:

* Add more complex queries (e.g., finding the average age of patients with a specific condition).
* Create queries for a different database type (e.g., PostgreSQL).
* Develop a Python script to visualize the SQL query results.



This project is provided for educational and illustrative purposes. You are free to use and adapt the code for your own learning.

---

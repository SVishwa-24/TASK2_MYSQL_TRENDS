use task01;
show databases;
use sql_task01;

CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    gender VARCHAR(10),
    birth_year INT,
    registered_date DATE,
    city VARCHAR(50)
);

CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100),
    specialty VARCHAR(50)
);

CREATE TABLE Visits (
    visit_id INT PRIMARY KEY,
    patient_id INT,
    visit_date DATE,
    doctor_id INT,
    reason_for_visit VARCHAR(255),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Lab_Results (
    result_id INT PRIMARY KEY,
    visit_id INT,
    test_name VARCHAR(100),
    result_value DECIMAL(10, 2),
    FOREIGN KEY (visit_id) REFERENCES Visits(visit_id)
);

INSERT INTO Patients (patient_id, gender, birth_year, registered_date, city) VALUES
(101, 'Female', 1985, '2023-01-10', 'Bengaluru'),
(102, 'Male', 1970, '2023-02-05', 'Chennai'),
(103, 'Female', 1990, '2023-01-20', 'Hyderabad'),
(104, 'Male', 1960, '2024-03-15', 'Bengaluru');

INSERT INTO Doctors (doctor_id, doctor_name, specialty) VALUES
(1, 'Dr. Sharma', 'General'),
(2, 'Dr. Singh', 'Pediatrics'),
(3, 'Dr. Devi', 'General');

INSERT INTO Visits (visit_id, patient_id, visit_date, doctor_id, reason_for_visit) VALUES
(1001, 101, '2024-01-15', 1, 'Cold/Flu'),
(1002, 102, '2024-01-20', 1, 'Check-up'),
(1003, 101, '2024-02-01', 3, 'Follow-up'),
(1004, 103, '2024-02-10', 2, 'Child Immunization'),
(1005, 104, '2024-03-20', 1, 'Check-up');

INSERT INTO Lab_Results (result_id, visit_id, test_name, result_value) VALUES
(2001, 1001, 'Blood Sugar', 110.5), -- High for typical fasting
(2002, 1002, 'Cholesterol', 210.0),
(2003, 1005, 'Blood Sugar', 135.0); -- High
show tables;


-- QUERY 1: MONTHLY VISITS TREND.
-- How many patients visited each month and how that number changed from the month before.
SELECT
    DATE_FORMAT(visit_date, '%Y-%m') AS visit_month, -- SQL Server: FORMAT(visit_date, 'yyyy-MM')
    COUNT(visit_id) AS total_visits_in_month,
    -- Get visits from the previous month
    LAG(COUNT(visit_id), 1, 0) OVER (ORDER BY DATE_FORMAT(visit_date, '%Y-%m')) AS previous_month_visits,
    -- Calculate % change from previous month
    CASE
        WHEN LAG(COUNT(visit_id), 1, 0) OVER (ORDER BY DATE_FORMAT(visit_date, '%Y-%m')) = 0 THEN NULL
        ELSE (COUNT(visit_id) - LAG(COUNT(visit_id), 1, 0) OVER (ORDER BY DATE_FORMAT(visit_date, '%Y-%m'))) * 100.0 / LAG(COUNT(visit_id), 1, 0) OVER (ORDER BY DATE_FORMAT(visit_date, '%Y-%m'))
    END AS monthly_visit_change_pct
FROM
    Visits
GROUP BY
    visit_month
ORDER BY
    visit_month;

-- QUERY 2: BUSIEST DOCTORS (Top 3 by Visits)
-- Which doctors saw the most patients.
SELECT
    d.doctor_name,
    d.specialty,
    COUNT(v.visit_id) AS total_visits
FROM
    Doctors d
JOIN
    Visits v ON d.doctor_id = v.doctor_id
GROUP BY
    d.doctor_name, d.specialty
ORDER BY
    total_visits DESC
LIMIT 3; -- SQL Server: TOP 3

-- QUERY 3: TOP 5 REASONS FOR VISITS
-- The most common reasons patients come to the clinic.
SELECT
    reason_for_visit,
    COUNT(visit_id) AS count_of_reasons
FROM
    Visits
GROUP BY
    reason_for_visit
ORDER BY
    count_of_reasons DESC
LIMIT 5; -- SQL Server: TOP 5

-- QUERY 4: PATIENT REGISTRATIONS BY YEAR
-- How many new patients registered in each year. (Using a CTE for clarity)
WITH PatientRegistrationsByYear AS (
    SELECT
        DATE_FORMAT(registered_date, '%Y') AS registration_year, 
        COUNT(patient_id) AS new_patients_count
    FROM
        Patients
    GROUP BY
        registration_year
)
SELECT
    registration_year,
    new_patients_count
FROM
    PatientRegistrationsByYear
ORDER BY
    registration_year;

-- QUERY 5: PATIENTS WITH HIGH BLOOD SUGAR ON FIRST TEST
-- Identify patients whose first recorded blood sugar test result was high (e.g., > 120).
-- This helps flag patients who might need follow-up for diabetes risk.
WITH PatientFirstBloodSugar AS (
    SELECT
        v.patient_id,
        lr.result_value AS blood_sugar_value,
        ROW_NUMBER() OVER (PARTITION BY v.patient_id ORDER BY v.visit_date, lr.result_id) AS rn -- Orders by visit date then result ID to get the 'first'
    FROM
        Lab_Results lr
    JOIN
        Visits v ON lr.visit_id = v.visit_id
    WHERE
        lr.test_name = 'Blood Sugar'
)
SELECT
    p.patient_id,
    p.gender,
    p.birth_year,
    p.city,
    pfbs.blood_sugar_value
FROM
    Patients p
JOIN
    PatientFirstBloodSugar pfbs ON p.patient_id = pfbs.patient_id
WHERE
    pfbs.rn = 1 -- Only the first blood sugar test
    AND pfbs.blood_sugar_value > 120.0 -- Define 'high' threshold here
ORDER BY
    pfbs.blood_sugar_value DESC;
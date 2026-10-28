/*
Project: Hospital Readmissions Data Analysis & Feature Engineering Pipeline
Author: Okoro Emmanuel Njoku
Tool: Microsoft SQL Server / T-SQL

Purpose:
This script contains the reviewed and validated version of the
hospital readmissions analysis.

Approach:
1. Inspect and validate the source data.
2. Standardize missing values.
3. Validate mapping tables and relationships.
4. Prepare the analytical dataset.
5. Engineer relevant features.
6. Analyze readmission patterns.
7. Validate query logic and document limitations.

Note:
The original SQL script is preserved separately for reference.
Only results from successfully executed and validated queries
will be reported as findings.
*/




USE Hospital_readmissions;
GO

-- 1. Total number of source records
SELECT
    COUNT(*) AS total_source_records
FROM dbo.diabetic_data_raw;

-- 2. Number of distinct patients
SELECT
    COUNT(DISTINCT patient_nbr) AS distinct_patients
FROM dbo.diabetic_data_raw;

-- 3. Check whether encounter_id has duplicates
SELECT
    encounter_id,
    COUNT(*) AS record_count
FROM dbo.diabetic_data_raw
GROUP BY encounter_id
HAVING COUNT(*) > 1;

-- 4. Check for missing key identifiers
SELECT
    SUM(CASE WHEN patient_nbr IS NULL THEN 1 ELSE 0 END)
        AS missing_patient_nbr,
    SUM(CASE WHEN encounter_id IS NULL THEN 1 ELSE 0 END)
        AS missing_encounter_id
FROM dbo.diabetic_data_raw;
--------------------------------------------

-- 5. Missing-value assessment for selected columns
SELECT
    COUNT(*) AS total_records,

    SUM(CASE WHEN race = '?' OR race IS NULL
        THEN 1 ELSE 0 END) AS missing_race,

    SUM(CASE WHEN weight = '?' OR weight IS NULL
        THEN 1 ELSE 0 END) AS missing_weight,

    SUM(CASE WHEN payer_code = '?' OR payer_code IS NULL
        THEN 1 ELSE 0 END) AS missing_payer_code,

    SUM(CASE WHEN medical_specialty = '?' OR medical_specialty IS NULL
        THEN 1 ELSE 0 END) AS missing_medical_specialty,

    SUM(CASE WHEN diag_1 = '?' OR diag_1 IS NULL
        THEN 1 ELSE 0 END) AS missing_diag_1,

    SUM(CASE WHEN diag_2 = '?' OR diag_2 IS NULL
        THEN 1 ELSE 0 END) AS missing_diag_2,

    SUM(CASE WHEN diag_3 = '?' OR diag_3 IS NULL
        THEN 1 ELSE 0 END) AS missing_diag_3

FROM dbo.diabetic_data_raw;

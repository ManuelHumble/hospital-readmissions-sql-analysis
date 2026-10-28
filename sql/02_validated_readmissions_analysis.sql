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
-- 6. Check admission type mapping
SELECT
    admission_type_id,
    COUNT(*) AS mapping_count
FROM dbo.admission_type_map
GROUP BY admission_type_id
HAVING COUNT(*) > 1;

-- 7. Check admission source mapping
SELECT
    admission_source_id,
    COUNT(*) AS mapping_count
FROM dbo.Admission_source_map
GROUP BY admission_source_id
HAVING COUNT(*) > 1;

-- 8. Check discharge disposition mapping
SELECT
    discharge_disposition_id,
    COUNT(*) AS mapping_count
FROM dbo.Discharge_disposition_map
GROUP BY discharge_disposition_id
HAVING COUNT(*) > 1;

-- 9. Find admission types without a mapping
SELECT DISTINCT
    d.admission_type_id
FROM dbo.diabetic_data_raw AS d
LEFT JOIN dbo.admission_type_map AS m
    ON d.admission_type_id = m.admission_type_id
WHERE m.admission_type_id IS NULL;

-- 10. Find admission sources without a mapping
SELECT DISTINCT
    d.admission_source_id
FROM dbo.diabetic_data_raw AS d
LEFT JOIN dbo.Admission_source_map AS m
    ON d.admission_source_id = m.admission_source_id
WHERE m.admission_source_id IS NULL;

-- 11. Find discharge dispositions without a mapping
SELECT DISTINCT
    d.discharge_disposition_id
FROM dbo.diabetic_data_raw AS d
LEFT JOIN dbo.Discharge_disposition_map AS m
    ON d.discharge_disposition_id = m.discharge_disposition_id
WHERE m.discharge_disposition_id IS NULL;

-- 12. Validate the patient-level dataset
SELECT
    COUNT(*) AS total_patient_level_records,
    COUNT(DISTINCT patient_nbr) AS distinct_patients,
    COUNT(*) - COUNT(DISTINCT patient_nbr)
        AS excess_records_over_distinct_patients
FROM dbo.diabetic_data_depue;

-- 13. Identify patients with multiple records
SELECT
    patient_nbr,
    COUNT(*) AS record_count
FROM dbo.diabetic_data_depue
GROUP BY patient_nbr
HAVING COUNT(*) > 1;


USE Hospital_readmissions;

SELECT *
FROM IDS_mapping_raw;
--Breaking down map into indevidual tables

CREATE TABLE Discharge_disposition_map (
discharge_disposition_id int,
description varchar(150)
)

CREATE TABLE Admission_source_map (
admission_source_id int,
description varchar(150)
)

CREATE TABLE admission_type_map (
admission_type_id int,
description varchar(150)
)

INSERT INTO admission_type_map
	(admission_type_id,description ) VALUES
(1,	'Emergency'),
(2,	'Urgent'),
(3,	'Elective'),
(4,	'Newborn'),
(5,	'Not Available'),
(6,	'NULL'),
(7,	'Trauma Center'),
(8,	'Not Mapped');

INSERT INTO  Discharge_disposition_map 
( discharge_disposition_id, description) VALUES
(1,	'Discharged to home'),
(2,	'Discharged/transferred to another short term hospital'),
(3,	'Discharged/transferred to SNF'),
(4,	'Discharged/transferred to ICF'),
(5,	'Discharged/transferred to another type of inpatient care institution'),
(6,	'Discharged/transferred to home with home health service'),
(7,	'Left AMA'),
(8,	'Discharged/transferred to home under care of Home IV provider'),
(9,	'Admitted as an inpatient to this hospital'),
(10,	'Neonate discharged to another hospital for neonatal aftercare'),
(11,	'Expired'),
(12,	'Still patient or expected to return for outpatient services'),
(13,	'Hospice / home'),
(14,	'Hospice / medical facility'),
(15,	'Discharged/transferred within this institution to Medicare approved swing bed'),
(16,	'Discharged/transferred/referred another institution for outpatient services'),
(17,	'Discharged/transferred/referred to this institution for outpatient services'),
(18,	'NULL'),
(19,	'Expired at home. Medicaid only, hospice.'),
(20,	'Expired in a medical facility. Medicaid only, hospice.'),
(21,	'Expired, place unknown. Medicaid only, hospice.'),
(22,	'Discharged/transferred to another rehab fac including rehab units of a hospital.'),
(23,	'Discharged/transferred to a long term care hospital.'),
(24,	'Discharged/transferred to a nursing facility certified under Medicaid but not certified under Medicare.'),
(25,	'Not Mapped'),
(26,	'Unknown/Invalid'),
(30,	'Discharged/transferred to another Type of Health Care Institution not Defined Elsewhere'),
(27,	'Discharged/transferred to a federal health care facility.'),
(28,	'Discharged/transferred/referred to a psychiatric hospital of psychiatric distinct part unit of a hospital'),
(29,	'Discharged/transferred to a Critical Access Hospital (CAH)')


INSERT INTO Admission_source_map 
(admission_source_id,	description) VALUES

(1,	'Physician Referral'),
(2,	'Clinic Referral'),
(3,	'HMO Referral'),
(4,	'Transfer from a hospital'),
(5,	'Transfer from a Skilled Nursing Facility (SNF)'),
(6,	'Transfer from another health care facility'),
(7,	'Emergency Room'),
(8,	'Court/Law Enforcement'),
(9,	'Not Available'),
(10,	'Transfer from critial access hospital'),
(11,	'Normal Delivery'),
(12,	'Premature Delivery'),
(13,	'Sick Baby'),
(14,	'Extramural Birth'),
(15,	'Not Available'),
(17,	'NULL'),
(18,	'Transfer From Another Home Health Agency'),
(19,	'Readmission to Same Home Health Agency'),
(20,	'Not Mapped'),
(21,	'Unknown/Invalid'),
(22,	'Transfer from hospital inpt/same fac reslt in a sep claim'),
(23,	'Born inside this hospital'),
(24,	'Born outside this hospital'),
(25,	'Transfer from Ambulatory Surgery Center'),
(26,	'Transfer from Hospice')
----Validating newly created tables
SELECT * 
FROM Admission_source_map
SELECT *
FROM admission_type_map
SELECT *
FROM Discharge_disposition_map

---Viewing Diabetic data raw table
SELECT COUNT(*) AS Total_Record
FROM diabetic_data_raw;

SELECT TOP 90 *
FROM [dbo].diabetic_data_raw


EXEC sp_columns @table_name = diabetic_data_raw

==-----Data cleaning--====
UPDATE diabetic_data_raw
SET race = NULLIF (race,'?'),
	weight = NULLIF(weight,'?'),
	payer_code = NULLIF(payer_code,'?'),
	medical_specialty = NULLIF(medical_specialty,'?'),
	diag_1 = NULLIF(diag_1,'?'),
	diag_2 = NULLIF(diag_2,'?'),
	diag_3 = NULLIF (diag_3, '?');

---Altring Table to be aable to replace '?' with null 
ALTER TABLE diabetic_data_raw ALTER COLUMN  race nvarchar(50) null;
ALTER TABLE diabetic_data_raw ALTER COLUMN  weight varchar(50) null;
ALTER TABLE diabetic_data_raw ALTER COLUMN	payer_code nvarchar(50) null;
ALTER TABLE diabetic_data_raw ALTER COLUMN medical_specialty nvarchar(50) null
ALTER TABLE diabetic_data_raw ALTER COLUMN	diag_1 nvarchar(50) null;
ALTER TABLE diabetic_data_raw ALTER COLUMN	diag_2 nvarchar (50) null;
ALTER TABLE diabetic_data_raw ALTER COLUMN 	diag_3 nvarchar(50) null;
ALTER TABLE diabetic_data_raw ALTER COLUMN 	discharge_disposition_id int


--patients with more than 1 encounter

SELECT patient_nbr,
	   COUNT(*) AS encounter_count
FROM diabetic_data_raw
GROUP BY patient_nbr
HAVING COUNT(*) >1
ORDER BY encounter_count DESC

---Patients with just one visit

SELECT 
		DISTINCT(patient_nbr),
		COUNT(encounter_id) AS Total_encounter
FROM diabetic_data_raw
GROUP BY patient_nbr
HAVING COUNT(encounter_id) <2

--Determining every unique patient and their first encounter, then create a table with this information

SELECT t.*
INTO diabetic_data_depue
FROM diabetic_data_raw AS t
INNER JOIN (
	SELECT patient_nbr,
		Min(encounter_id) AS First_encounter
FROM diabetic_data_raw
GROUP BY patient_nbr 
			) AS   First_enc
ON T.patient_nbr = First_enc.patient_nbr
AND t.encounter_id =First_enc.first_encounter;

--comfirming newly created table
SELECT *
FROM diabetic_data_depue;

SELECT COUNT(*) AS New_Total_record
FROM diabetic_data_depue;

--===filtering patinets that can not be readmited===--- 

--having a view of the IDs table
SELECT *
FROM IDS_mapping_raw

---Conditions that could affect patients' readmission
SELECT *
FROM IDS_mapping_raw
where column2 like '%hospice%' or column2 like '%expired%' or column2 like '%deceased';
-- discharge IDs not readmitable 11,13,14,19,20,21,26

SELECT discharge_disposition_id,
		COUNT(*) AS ecounter_count
FROM diabetic_data_raw
WHERE discharge_disposition_id in (11,13,14,19,20,21,26)
GROUP BY discharge_disposition_id
ORDER BY ecounter_count DESC

--Delete non-readmitable patients from depue record 
DELETE FROM diabetic_data_depue
WHERE discharge_disposition_id in (11,13,14,19,20,21,26)

--verifying deleted updated record 
SELECT * 
FROM diabetic_data_depue
WHERE discharge_disposition_id in (11,13,14,19,20,21,26);

---== Adding a Midage colunm
ALTER TABLE diabetic_data_depue
ADD  age_midpoint int

--Imputing values into the midage column
UPDATE diabetic_data_depue
 SET age_midpoint = CASE
	WHEN age = '[0-10)'   THEN 5
	WHEN age = '[10-20)'  THEN 15
	WHEN age = '[20-30)'  THEN 25
	WHEN age = '[30-40)'  THEN 35
	WHEN age = '[40-50)'  THEN 45
	WHEN age = '[50-60)'  THEN 55
	WHEN age = '[60-70)'  THEN 65
	WHEN age = '[70-80)'  THEN 75
	WHEN age = '[80-90)'  THEN 85
	WHEN age = '[90-100)' THEN 95 
END;

----Overall readmission breakdown
SELECT readmitted,
		COUNT(*) as encounter_count,
		CAST(ROUND(100.0 * COUNT(*)/(SELECT COUNT(*) FROM diabetic_data_depue),1) AS decimal(10,1)) AS pct_of_total
FROM diabetic_data_depue
GROUP BY readmitted
ORDER BY readmitted DESC

--Readmissions by Age and Age_midpoint
SELECT  age,
		age_midpoint,
		COUNT(*) AS total_encounter,
		SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmitted_under_30,
		CAST(ROUND(100.0 * SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END ) / COUNT(*), 1) AS DECIMAL(10,1)) AS readmission_rate	
FROM diabetic_data_depue
GROUP BY age,age_midpoint
ORDER BY age ;

--READMISSION BY DESCRIPTION (i.e. admission type)
--JOIN THIS TABLE TO ADMISSION TYPE
SELECT ATM.description AS admission_type,
	   COUNT(*) AS total_encounters,
	   CAST(ROUND(100.0 * SUM(CASE WHEN dd.readmitted = '<30' THEN 1 ELSE 0 END) / COUNT(*),1) AS DECIMAL(10,1)) AS readmission_rate_pct
FROM diabetic_data_depue DD
JOIN admission_type_map ATM
ON ATM.admission_type_id = DD.admission_type_id
GROUP BY ATM.description

--Readmission by admission source 
SELECT ASM.description AS admission_type,
	   COUNT(*) AS total_encounters,
	   CAST(ROUND(100.0 * SUM(CASE WHEN dd.readmitted = '<30' THEN 1 ELSE 0 END) / COUNT(*),1) AS DECIMAL(10,1)) AS readmission_rate_pct
FROM diabetic_data_depue DD
JOIN Admission_source_map ASM
ON ASM.admission_source_id = DD.admission_type_id
GROUP BY ASM.description




--CREATING A CTE WITH (columns my analysis will focus on and readmission under )

WITH patient_risk_base AS (
	SELECT patient_nbr,
	encounter_id,
	age_midpoint,
	time_in_hospital,
	number_diagnoses,
	num_medications,
	num_lab_procedures,
	number_inpatient,
	number_outpatient,
	number_emergency,
	diag_1,
	diag_2,
	diag_3,
	readmitted,
	CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END AS readmistted_30
FROM diabetic_data_depue
)

SELECT *
FROM patient_risk_base

--Global segmentation of medication by age group
--Which age group takes more medications ?
--ranking each age group by medication individually

WITH patient_risk_base AS (

	SELECT encounter_id,
			age_midpoint,
			num_medications,
			readmitted,
	        CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END AS readmistted_30
     FROM diabetic_data_depue
	 )
SELECT encounter_id,
		age_midpoint,
		num_medications,
		RANK () OVER (PARTITION BY age_midpoint ORDER BY num_medications DESC) AS medication_rank_in_agegroup
FROM patient_risk_base 
ORDER BY Age_midpoint DESC


--Patient risk stratification via inpatient Quartiles

WITH pastient_risk_base AS (
	 SELECT 
		encounter_id,
		number_inpatient,
		readmitted,
		CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END AS readmitted_30
	FROM diabetic_data_depue )
SELECT 
	encounter_id,
	number_inpatient,
	NTILE (4) OVER ( ORDER BY number_inpatient DESC) AS risk_quatile
FROM pastient_risk_base

---Segmenting By medication burdern and Diagnosis complexity
-- What is the medication burden what is the patients diagnostic complexity

SELECT encounter_id,
		num_medications,
		CASE 
		WHEN num_medications  <=10 THEN 'Low'
		WHEN num_medications BETWEEN 11 AND 20 THEN 'Medium'
		ELSE 'High'
		END AS Medication_burden_tire,
		CASE
		WHEN number_diagnoses <=5 THEN 'Low Complexity'
		WHEN number_diagnoses BETWEEN 6 AND 9 THEN 'Morderate Complexity'
		ELSE 'High Complexity'
		END AS diagnostic_complexity_tire
FROM diabetic_data_depue;

--===MAJOR BUSINESS QUESTIONS ????REVISIT
--1. Top diagnosos driving readmission 

WITH Diag_catergorized AS ( 

	SELECT encounter_id,
			readmitted,
			CASE WHEN diag_1 LIKE '250%' THEN 'Diabetes' 
			WHEN TRY_CAST(LEFT(diag_1,3) AS INT) BETWEEN 390 AND 459 THEN 'Circulatory'
			WHEN TRY_CAST(LEFT(diag_1,3) AS INT) BETWEEN 460 AND 519 THEN 'Respiratoy'
			WHEN TRY_CAST(LEFT(diag_1,3) AS INT) BETWEEN 520 AND 579 THEN 'Diagestive'
			WHEN TRY_CAST(LEFT(diag_1,3) AS INT) BETWEEN 580 AND 629 THEN 'Genitourinary'
			WHEN TRY_CAST(LEFT(diag_1,3) AS INT) BETWEEN 800 AND 999 THEN 'Ingury'
			ELSE 'Other'
			END AS diagnosis_category,
			CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END AS is_readmitted_30
	
	FROM diabetic_data_depue
	WHERE diag_1 IS NOT NULL
	)
	SELECT diagnosis_category,
		   COUNT(*)	AS total_encounter,
		  CAST(ROUND(100.0 * AVG(CAST(is_readmitted_30 AS FLOAT)),1) AS DECIMAL (5,1))AS readmission_rate_pct
	FROM Diag_catergorized
	GROUP BY  diagnosis_category
	HAVING AVG(CAST(is_readmitted_30 AS FLOAT)) > (
		SELECT AVG(CAST(is_readmitted_30 AS FLOAT)) FROM Diag_catergorized
		)
	ORDER BY readmission_rate_pct DESC ;

----2 Dose a medication change at discharge affect  readmission?

	SELECT  d.change,
			COUNT(*) AS Total_encounters,
			CAST(ROUND(100.0 * SUM (CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) / COUNT (*), 1) AS DECIMAL (5,1)) AS readmission_rate
		FROM diabetic_data_depue d	
	GROUP BY d.change; 


----3 what is the Discharge disposition  impact

	SELECT 
			map.description,
			COUNT(*) AS total_encounter,
			 CAST(ROUND(100.0 * SUM(CASE WHEN d.readmitted = '<30' THEN 1 ELSE 0 END) / COUNT(*),1) AS DECIMAL(10,1)) AS readmission_rate_pct
FROM diabetic_data_depue d
JOIN Discharge_disposition_map map
		  ON map.discharge_disposition_id = d.discharge_disposition_id
GROUP BY map.description
ORDER BY readmission_rate_pct
	

----4. A1c testing and readmission  
SELECT A1Cresult,
		COUNT(*) AS totla_encounters,
       CAST(ROUND(100.0 * SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) / COUNT(*),1) AS DECIMAL(10,1)) AS readmission_rate_pct
FROM diabetic_data_depue
GROUP BY A1Cresult
	

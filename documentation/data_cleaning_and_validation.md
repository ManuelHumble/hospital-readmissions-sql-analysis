# Data Cleaning and Validation

## 1. Purpose

This document records the data preparation decisions and validation checks used in the Hospital Readmissions Data Analysis & Feature Engineering Pipeline.

The objective is to make the analytical workflow transparent, identify potential data-quality issues, and improve the reliability of subsequent findings.

## 2. Initial Data Inspection

The initial SQL workflow examines the source dataset using:

- Record counts.
- Sample record inspection.
- SQL Server column metadata.
- Queries examining repeated patient identifiers.

These checks provide an initial understanding of the dataset before transformation.

## 3. Standardization of Missing Values

### Transformation performed

The following fields were updated to replace the `?` placeholder with SQL NULL:

- `race`
- `weight`
- `payer_code`
- `medical_specialty`
- `diag_1`
- `diag_2`
- `diag_3`

### Reason

SQL NULL values allow missing information to be handled consistently in SQL queries.

## 4. Patient Encounter Analysis

The workflow groups records by `patient_nbr` and counts encounters for each patient.

It also identifies patients with more than one encounter and patients with fewer than two encounters.

### Purpose

These queries help establish how frequently patients appear in the source dataset and inform the design of the analytical dataset.

## 5. Patient-Level Dataset Construction

The SQL workflow creates `diabetic_data_depue` by selecting the record with the minimum `encounter_id` for each `patient_nbr`.

### Purpose

This produces a derived dataset containing one selected encounter per patient, assuming patient identifiers and encounter identifiers behave as expected.

### Important limitation

The earliest encounter is not automatically the appropriate index encounter for a 30-day readmission study.

A readmission analysis should establish the index encounter and examine subsequent encounters within the specified observation window.

The existing patient-level dataset therefore requires further assessment before it can support a defensible readmission-risk analysis.

## 6. Discharge-Disposition Exclusions

The workflow excludes records with the following discharge disposition identifiers from `diabetic_data_depue`:

`11, 13, 14, 19, 20, 21, 26`

The original SQL comments describe these records as patients who may not be readmitted, as revealed in the IDS mapping.
|discharge_id|description|
| :--- | :--- |
|11	| Expired |
|13	| Hospice / home. |
|14	| Hospice / medical facility. | 
|19	| Expired at home. Medicaid only, hospice.| 
|20	| Expired in a medical facility. Medicaid only, hospice. | 
|21	| Expired, place unknown. Medicaid only, hospice.| 
|26	| Unknown/Invalid. | 

## 7. Age Feature Engineering

The workflow adds `age_midpoint` to the derived dataset.

Age ranges are represented using their numeric midpoints. For example, `[50-60)` becomes 55.

The midpoint is an approximation and should not be treated as the patient's exact age.


### Admission source join

The admission-source analysis joins `Admission_source_map.admission_source_id` to `diabetic_data_depue.admission_type_id`.

The intended relationship is between `admission_source_id` in the encounter data and `admission_source_id` in the mapping table.

This is to extract the descriptions from ID mapping table 

### Readmission outcome definition

The workflow defines an indicator based on whether `readmitted = '<30'`.

## 8. Validation Checklist

Queries have been validated 



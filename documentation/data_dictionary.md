# Data Dictionary

## 1. Overview

This document describes the principal tables and variables used in the Hospital Readmissions Data Analysis & Feature Engineering Pipeline.

The project uses SQL Server and T-SQL to prepare diabetic patient encounter data and investigate patterns associated with 30-day readmission.

## 2. Source and Analytical Tables

### 2.1 `diabetic_data_raw`

**Purpose:** Stores the source hospital encounter data used for analysis.

The table contains patient and encounter information, clinical variables, healthcare utilization measures, medication-related fields, and readmission status.

Selected fields containing `?` placeholders were converted to SQL NULL values during the cleaning stage.

### 2.2 `diabetic_data_depue`

**Purpose:** Stores the derived patient-level dataset created from the source data.

The SQL workflow selects the earliest encounter for each `patient_nbr` using the minimum `encounter_id`. It then excludes records with selected discharge disposition IDs.

**Important:** The earliest encounter is not necessarily the correct index encounter for every readmission analysis. The analytical outcome and observation window must be validated before the dataset is used to estimate readmission rates.

### 2.3 `admission_type_map`

**Purpose:** Maps admission type identifiers to readable descriptions.

The mapping is used to group encounters by admission type.

### 2.4 `Admission_source_map`

**Purpose:** Maps admission source identifiers to readable descriptions.

The mapping is intended to support analysis of readmission patterns by admission source.

### 2.5 `Discharge_disposition_map`

**Purpose:** Maps discharge disposition identifiers to readable descriptions.

The mapping supports interpretation of discharge outcomes and exploration of their association with readmission.

## 3. Key Variables Used in the Analysis

The following variables are referenced in the SQL workflow.

| Variable | Description | Analytical Use |
|---|---|---|
| `patient_nbr` | Patient identifier in the source dataset | Identifying repeat encounters and selecting one encounter per patient |
| `encounter_id` | Encounter identifier | Identifying encounters and selecting the earliest encounter |
| `age` | Patient age range | Comparing readmission patterns across age groups |
| `age_midpoint` | Derived numeric midpoint of the age range | Supporting numeric age-group comparisons |
| `time_in_hospital` | Duration of the hospital stay, represented in the source data | Examining hospital stay duration |
| `number_diagnoses` | Number of diagnoses recorded for an encounter | Exploring diagnosis complexity |
| `num_medications` | Number of medications associated with an encounter | Examining medication burden |
| `num_lab_procedures` | Number of laboratory procedures | Exploring healthcare utilization |
| `number_inpatient` | Number of prior inpatient visits, as represented in the source data | Examining previous inpatient utilization |
| `number_outpatient` | Number of outpatient visits, as represented in the source data | Exploring outpatient utilization |
| `number_emergency` | Number of emergency visits, as represented in the source data | Exploring emergency utilization |
| `diag_1` | Primary diagnosis code | Categorizing diagnoses for exploratory analysis |
| `diag_2` | Secondary diagnosis code | Potentially supporting further diagnosis analysis |
| `diag_3` | Additional diagnosis code | Potentially supporting further diagnosis analysis |
| `readmitted` | Readmission category in the source data | Defining the outcome used in the exploratory readmission queries |
| `admission_type_id` | Identifier describing the admission type | Joining encounters to the admission type mapping |
| `admission_source_id` | Identifier describing the admission source | Joining encounters to the admission source mapping |
| `discharge_disposition_id` | Identifier describing the discharge disposition | Joining encounters to the discharge disposition mapping |
| `change` | Medication-change indicator or category in the source data | Comparing readmission patterns by medication-change status |
| `A1Cresult` | HbA1c test result category in the source data | Exploring readmission patterns by HbA1c result category |

## 4. Derived Features

### `age_midpoint`

A numeric midpoint is assigned to each age range.

For example, the age group `[50-60)` is represented by 55.

This allows age ranges to be used in numeric comparisons. However, the midpoint is an approximation, not the patient's exact age.

### `readmitted_30`

The SQL workflow creates a binary indicator using the following definition:

- `1` when `readmitted = '<30'`
- `0` otherwise

This represents the source dataset's under-30-day readmission category.

The indicator should not automatically be interpreted as a fully validated prediction outcome. Its meaning depends on the source data's encounter structure and the analytical inclusion criteria.

### Medication Burden

The workflow categorizes medication counts as follows:

- Low: 10 or fewer medications
- Medium: 11–20 medications
- High: More than 20 medications

These are analyst-defined categories and should not be interpreted as clinically validated risk thresholds.

### Diagnostic Complexity

The workflow categorizes the number of diagnoses as follows:

- Low complexity: 5 or fewer diagnoses
- Moderate complexity: 6–9 diagnoses
- High complexity: More than 9 diagnoses

These are exploratory categories used to support comparisons.

### Inpatient Utilization Quartile

The workflow uses the SQL Server `NTILE(4)` window function to divide encounters into four groups ordered by `number_inpatient` in descending order.

The resulting groups are relative rankings within the selected dataset, not validated clinical risk scores.

## 5. Mapping Table Fields

The mapping tables use the following fields:

| Field | Description |
|---|---|
| `admission_type_id` | Admission type identifier |
| `admission_source_id` | Admission source identifier |
| `discharge_disposition_id` | Discharge disposition identifier |
| `description` | Human-readable category description |

## 6. Data Dictionary Limitations

This document describes the variables referenced in the current SQL workflow. It is not a complete inventory of every field in the source dataset.

Variable definitions should be checked against the original dataset documentation before the project is finalized.

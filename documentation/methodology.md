# Project Methodology

## 1. Overview

This document describes the analytical workflow used in the Hospital Readmissions Data Analysis & Feature Engineering Pipeline.

The project uses SQL Server and T-SQL to prepare hospital encounter data, construct analytical features, and investigate patterns associated with 30-day hospital readmission.

## 2. Data Inspection

The first stage involved examining the available dataset and its structure to understand the fields available for analysis.

The inspection stage provides a foundation for identifying relevant variables, understanding categorical identifiers, and planning subsequent transformations.

## 3. Categorical Mapping

Mapping tables were created for selected admission-related and discharge-related identifiers.

The purpose was to associate coded values with readable descriptions, making the data easier to interpret during exploratory analysis.

The mapping tables and their relationships should be validated against the original data dictionary before final results are published.

## 4. Missing-Value Treatment

Selected fields containing the `?` placeholder were converted to SQL NULL values.

This transformation standardizes the representation of missing information and makes it easier to apply SQL functions and missing-value checks consistently.

Missing values were not assumed to mean zero, and their treatment should be considered when interpreting analytical results.

## 5. Repeat-Encounter Analysis

The workflow examines repeat encounters and constructs a patient-level dataset using each patient's earliest encounter.

This provides a patient-level view for selected analyses.

However, selecting the earliest encounter does not, by itself, establish whether a patient was readmitted within 30 days. That outcome requires a clearly defined index encounter, a subsequent encounter, and an appropriate time-window calculation.

## 6. Discharge-Disposition Filtering

Selected discharge dispositions were excluded from the patient-level dataset.

These exclusions can affect the composition of the analytical population and the resulting readmission patterns.

The final documentation should identify the exact excluded values, explain the rationale for each exclusion, and assess their effect on the analysis.

## 7. Feature Engineering

The SQL workflow includes the following feature-engineering activities:

- Estimating age using the midpoint of an age range.
- Defining a 30-day readmission indicator.
- Ranking medication counts within age groups.
- Applying quartiles to prior inpatient visit counts.
- Segmenting medication burden and diagnosis complexity.

These features are intended to support comparisons across patient groups and exploratory investigation of factors associated with readmission.

Each feature's definition, calculation, and intended interpretation should be documented alongside the validated SQL implementation.

## 8. Exploratory Analysis

The analysis investigates readmission patterns across selected variables, including:

- Age group.
- Admission type.
- Admission source.
- Diagnosis category.
- Medication changes.
- Discharge disposition.
- HbA1c testing.

The objective is to identify patterns that may warrant further clinical or operational investigation.

## 9. Validation and Quality Assurance

Before final results are published, the SQL workflow should be checked for:

- Correct joins between mapping tables and source data.
- Consistent handling of missing values.
- Appropriate treatment of repeat encounters.
- Correct calculation of the 30-day readmission outcome.
- Consistency between feature names and their calculations.
- Duplicate records and unexpected row-count changes.
- Accurate interpretation of query outputs.

## 10. Limitations

The analysis is subject to limitations associated with the available variables, the definition of readmission, missing data, and the assumptions used in feature engineering.

A patient-level dataset based on earliest encounters may not represent all subsequent readmission events.

Observed associations do not establish causation, and exploratory findings should not be interpreted as validated clinical predictions.

## 11. Reproducibility

The SQL scripts are maintained in the repository's `sql/` directory.

The final project documentation will be updated as the queries are validated, analytical definitions are finalized, and findings are confirmed against actual query outputs.

# Hospital Readmissions Data Analysis & Feature Engineering Pipeline

## Project Overview

Hospital readmissions are an important healthcare quality and operational concern. Understanding patient characteristics, previous healthcare utilization, and clinical factors associated with readmission can help identify areas that warrant further investigation.

This project uses SQL Server and T-SQL to prepare, transform, and analyze hospital encounter data, with a focus on readmission within 30 days.

The workflow includes data cleaning, mapping categorical identifiers, patient-level data preparation, feature engineering, exploratory analysis, and risk-oriented segmentation.

## Problem Statement

How can hospital encounter data be prepared and analyzed to investigate patterns associated with 30-day hospital readmission?

## Project Objectives

- Inspect and prepare raw hospital encounter data for analysis.
- Standardize selected missing-value representations.
- Map admission and discharge identifiers to readable descriptions.
- Examine repeat encounters and construct a patient-level analytical dataset.
- Engineer features relevant to patient characteristics and healthcare utilization.
- Explore readmission patterns across selected clinical and operational variables.
- Develop reproducible SQL queries to support further analysis.

## Tools and Technologies

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL

## Analytical Workflow

1. Data inspection and schema exploration
2. Mapping-table creation and validation
3. Missing-value treatment
4. Repeat-encounter analysis and patient-level preparation
5. Discharge-disposition filtering
6. Feature engineering
7. Exploratory readmission analysis
8. Query validation and documentation
9. Results presentation and visualization

## Repository Structure

The repository will contain SQL scripts, project methodology, data documentation, validated findings, and selected result screenshots as the project progresses.

## Current Project Status

The initial SQL workflow has been developed. The next stage is to validate the queries, document the analytical decisions, verify the findings, and organize the scripts for reproducibility.

## Important Notes

- The analysis uses a patient-level dataset derived from the original encounter data; this is not automatically equivalent to an encounter-level readmission analysis.
- Readmission patterns should be interpreted as associations, not proof of causation.
- The analytical dataset, outcome definition, and exclusion criteria require validation before final conclusions are reported.
- Raw data and sensitive patient identifiers will not be published in this repository.

## Author

**Okoro Emmanuel Njoku**

Doctor of Optometry | Healthcare Data Analytics

This project reflects my interest in applying data analysis to healthcare questions and translating clinical data into actionable insights.

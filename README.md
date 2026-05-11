# DataFest-2026
[View presentation] Presentation%20-%20DataFest%202026.pdf

**Overview**

Healthcare utilization varies significantly across populations due to differences in access, cost, and social determinants of health. This project investigates Emergency Department (ED) visit patterns across Kansas, exploring how demographic factors like age and race interact to predict ED utilization.

**Research Question**

How can we predict ED visits based on the interaction between age and race?

The goal is to identify patterns in emergency department use to better understand population-level differences in healthcare utilization — and ultimately support better distribution of healthcare resources.

**Dataset**

The project uses five linked datasets from a Kansas healthcare system:

FileDescriptionpatients.csv Patient demographics including age, race, and vital status

encounters.csv Hospital encounter records linked to patients via

PatientDurableKeydepartments.csv Department-level metadata for each encounter

diagnosis.csv Diagnosis codes associated with 

encounterssocial_determinants.csv Social determinants of health (e.g. socioeconomic indicators)

**Data Preparation**

Data Integration: Linked patient and encounter data using DurableKey (patients) and PatientDurableKey (encounters)

Outcome Variable: Binary ED visit flag — Had ED Visit: Yes (1) / No (0); missing encounters treated as no ED visit

Data Filtering: Restricted to living patients with non-missing race and age values

**Methodology**

1. Logistic Regression

Outcome: ED visit (binary)
Predictors: Age, Race, and Age × Race interaction term
Class imbalance handling: ED visits are rare (~3% of population), so a stratified train/test split was used to preserve outcome proportions across splits

2. Data Filtering and Grouping (Department Analysis)

Visits were cross-tabulated by department and city
Used to identify which medical departments dominate demand across Kansas cities
Revealed that the most-visited department varies by city

**Key Findings**

ED Visit Patterns
- Age alone is a weak predictor of ED visits
- Modest differences in ED visit probability exist across racial groups
- The Age × Race interaction reveals subtle but meaningful variation in utilization patterns

**Department Analysis**

- Emergency Medicine and Radiology are by far the most visited departments overall
- Neonatology and Infusion Therapy also rank high
- Visit distribution across departments is highly uneven
- The most visited department varies by city across Kansas

**Implications**

- Socioeconomic disparities likely underlie differences in ED utilization by social minorities
- Better distribution of high-demand departments (e.g. Emergency Medicine) across cities could improve access
- Findings support targeted engagement strategies to improve preventive care uptake and reduce unnecessary ED visits


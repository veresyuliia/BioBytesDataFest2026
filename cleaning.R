library(readr)
library(tidyr)
library(dplyr)


patients <- read.csv("patients.csv")
patients_alive <- filter(patients, patients$VitalStatus == "Alive")
patients_age <- patients_alive %>% mutate(Age = 2026 - PatientBirthYearBin)
patients_clean <- select(patients_age, "DurableKey", "FirstRace", "Age")
glimpse(patients_clean)

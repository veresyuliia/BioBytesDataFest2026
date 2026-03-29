library(readr)
library(dplyr)
library(tidymodels)
library(ggplot2)

## Cleaning Patients
patients <- read.csv("patients.csv")
patients_alive <- filter(patients, VitalStatus == "Alive")
patients_age <- patients_alive %>% mutate(Age = 2026 - PatientBirthYearBin)
patients_filtered <- select(patients_age, DurableKey, FirstRace, Age)
patients_filtered <- patients_filtered %>%
  filter(!is.na(FirstRace), !is.na(DurableKey), !is.na(Age))
glimpse(patients_filtered)

## Cleaning Encounters
encounters <- read.csv("encounters.csv")
encounters_filtered <- select(encounters, "PatientDurableKey", "IsEdVisit")
glimpse(encounters_filtered)

## Create new dataframe combining patients and encounters and match it to durablekey + change NA after join to 0 to indicate that it is not an Ed visits
combined_data <- patients_filtered %>%
  left_join(encounters_filtered,
            by = c("DurableKey" = "PatientDurableKey")) %>%
  mutate(IsEdVisit = ifelse(is.na(IsEdVisit), 0, IsEdVisit))

# group by durable key to have one row per patient and if more than one ED visit set it equal to 1 visit
patient_level <- combined_data %>%
  group_by(DurableKey, FirstRace, Age) %>%
  summarise(
    had_ED = max(IsEdVisit),
    .groups = "drop"
  )
patient_level$FirstRace <- as.factor(patient_level$FirstRace)
glimpse(patient_level)


## Performing Logistic Regression
# Splitting Dataset
set.seed(123)
split <- initial_split(patient_level, prop = 0.7, strata = had_ED)

train_data <- training(split)
test_data <- testing(split)

prop.table(table(train_data$had_ED))
prop.table(table(test_data$had_ED))

glimpse(train_data)

# Building Model
model <- glm(had_ED ~ Age * FirstRace,
             data = train_data,
             family = "binomial")

summary(model)

## PLotting
# Logistic curves: Age vs ED probability by race
ggplot(train_data, aes(x = Age, y = had_ED, color = FirstRace)) +
  geom_smooth(
    method = "glm",
    method.args = list(family = "binomial"),
    se = FALSE
  ) +
  labs(
    title = "Probability of ED Visit by Age and Race",
    x = "Age",
    y = "Probability of ED Visit"
  ) +
  theme_minimal()

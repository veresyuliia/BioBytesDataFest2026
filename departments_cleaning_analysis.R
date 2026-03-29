library(dplyr)

library(ggplot2)

departments <- read.csv("departments.csv")
head(departments)


departments_clean <- departments %>%
  select(City, County, DepartmentSpecialty, DepartmentType) %>%
  filter(!is.na(City),
         !is.na(DepartmentSpecialty),
         City != "",
         DepartmentSpecialty != "")
dept_counts <- departments_clean %>%
  count(City, DepartmentSpecialty)
dept_counts <- dept_counts %>%
  arrange(desc(n))


departments_clean <- departments %>%
  select(City, County, DepartmentSpecialty, DepartmentType)


departments_clean$DepartmentSpecialty[
  departments_clean$DepartmentSpecialty %in% c("Unknown", "Unspecified")
] <- "Missing_Passive"

departments_clean$DepartmentSpecialty[
  departments_clean$DepartmentSpecialty %in% c("*Unknown", "*Unspecified")
] <- "Missing_Refused"


departments_clean$City[
  departments_clean$City %in% c("*DELETED", "*NOT APPLICABLE", "*UNSPECIFIED", "*UNKNOWN", "")
] <- NA

departments_clean$DepartmentType[
  departments_clean$DepartmentType %in% c("*Deleted", "*Not Applicable", "*Unspecified", "*Unknown")
] <- NA

departments_clean$County[
  departments_clean$County %in% c("*Deleted", "*Not Applicable", "*Unspecified")
] <- NA
departments_clean <- departments_clean[
  !is.na(departments_clean$City) &
    !is.na(departments_clean$DepartmentSpecialty),
]
departments_clean$City <- toupper(departments_clean$City)
unique(departments_clean$City)

table(departments_clean$DepartmentSpecialty)

departments_plot <- departments_clean[
  !(departments_clean$DepartmentSpecialty %in% c("Missing_Refused", "Missing_Passive", "*Not Applicable")),
]
dept_counts <- departments_plot %>%
  count(City, DepartmentSpecialty) %>%
  arrange(desc(n))


plot_department_visits <- ggplot(head(dept_counts, 10), aes(x = reorder(DepartmentSpecialty, n), y = n, fill = n)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  scale_fill_gradient(low = "green", high = "blue") +
  labs(
    title = "Department Visits Distribution",
    x = "Department",
    y = "Count",
    fill = "Visit Count\n(Low → High)"
  )

print(plot_department_visits)


if (!dir.exists("plots")) {
  dir.create("plots")
}

if (!dir.exists("data")) {
  dir.create("data")
}

ggsave("plots/top10_departments_visits.png", plot = plot_department_visits, width = 8, height = 6)

write.csv(departments_clean, "departments_clean.csv", row.names = FALSE)


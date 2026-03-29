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

top3_dept_per_city <- dept_counts %>%
  group_by(City) %>%
  slice_max(n, n = 3) %>%  
  ungroup() %>%
  arrange(City, desc(n))   

top3_per_city_clean <- top3_dept_per_city %>%
  filter(!City %in% c("*DELETED", "*Deleted") & !is.na(City))

top3_city_table <- top3_per_city_clean %>%
  group_by(City) %>%
  summarise(
    Departments = paste(DepartmentSpecialty, n, sep = " (", collapse = "), "),
    .groups = "drop"
  ) %>%
  mutate(Departments = paste(Departments, ")")) 

top3_per_city_plot <- ggplot(top3_per_city_clean, aes(x = DepartmentSpecialty, y = n, size = n, fill = n)) +
  geom_point(alpha = 0.7, shape = 21, color = "black") +
  facet_wrap(~ City, scales = "free_y") +  
  scale_size(range = c(3, 12)) +          
  scale_fill_gradient(low = "lightblue", high = "darkblue") +
  coord_flip() +                          
  labs(
    title = "Top Departments per City",
    x = "Department",
    y = "Number of Visits",
    size = "Visits",
    fill = "Visits"
  ) +
  theme_minimal()

print(top3_per_city_plot)

if (!dir.exists("plots")) {
  dir.create("plots")
}

if (!dir.exists("data")) {
  dir.create("data")
}

ggsave("plots/top_per_city_plot.png", plot = top3_per_city_plot, width = 8, height = 6)

write.csv(top3_city_table, "top_city_table.csv", row.names = FALSE)

write.csv(departments_clean, "departments_clean.csv", row.names = FALSE)


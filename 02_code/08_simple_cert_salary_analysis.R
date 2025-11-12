# Simple Certification Salary Data Analysis
# Source: CompTIA Tech Jobs Report + Dice Salary Data

library(tidyverse)
library(janitor)

# ============================================================================
# LOAD EXISTING DATA FROM CERTS FOLDER
# ============================================================================

# Load skills salary data (from Dice/CompTIA report)
skills_data <- read.csv("01_data/certs/Average Salaries by Skill 2022.csv") %>%
  clean_names()

# Load occupations data
occupations_data <- read.csv("01_data/certs/Average salaries by tech occupation 2022.csv") %>%
  clean_names()

# Load experience level data
experience_data <- read.csv("01_data/certs/Tech salaries by years of experience.csv") %>%
  clean_names()

cat("Data loaded successfully:\n")
cat("  - Skills: ", nrow(skills_data), " records\n")
cat("  - Occupations: ", nrow(occupations_data), " records\n")
cat("  - Experience: ", nrow(experience_data), " records\n\n")

# ============================================================================
# EXTRACT CERTIFICATION-RELEVANT SKILLS
# ============================================================================

# Dashboard certs to look for
dashboard_certs <- c(
  "AWS", "Lambda", "CodeWhisperer",
  "CISSP", "Security+",
  "PMP", "Project Management",
  "Kubernetes", "CKA",
  "Azure", "Administrator",
  "Google Cloud", "GCP",
  "ITIL",
  "Docker",
  "DevOps",
  "Machine Learning", "ML",
  "Artificial Intelligence", "AI",
  "Terraform",
  "Network+",
  "Python",
  "Java",
  "Go", "Golang"
)

# Clean up salary values (remove $ and ,)
skills_data <- skills_data %>%
  mutate(average_salary_numeric = as.numeric(gsub("[\\$,]", "", average_salary)))

# Search for matches (case-insensitive)
cert_matches <- skills_data %>%
  filter(str_detect(tolower(skill), 
                    paste0("(", paste(tolower(dashboard_certs), collapse = "|"), ")"))) %>%
  arrange(desc(average_salary_numeric)) %>%
  select(skill, average_salary, change_from_2023, average_salary_numeric)

cat("CERTIFICATION SKILLS FOUND IN SALARY DATA:\n")
cat("==========================================\n\n")

for (i in 1:nrow(cert_matches)) {
  cat(sprintf("%2d. %-40s $%7d\n", 
              i, 
              cert_matches$skill[i], 
              cert_matches$average_salary_numeric[i]))
}

cat("\n\nTOP 10 SALARIES (All Skills):\n")
cat("=============================\n\n")
top_10 <- skills_data %>%
  arrange(desc(average_salary_numeric)) %>%
  head(10)

for (i in 1:nrow(top_10)) {
  cat(sprintf("%2d. %-40s $%7d\n", 
              i, 
              top_10$skill[i], 
              top_10$average_salary_numeric[i]))
}

# ============================================================================
# EXPORT RESULTS
# ============================================================================

# Export cert matches
write.csv(cert_matches, 
          "04_results/CERT_SALARY_DATA_FROM_COMPTIA_DICE.csv",
          row.names = FALSE)

cat("\n\nOCCUPATION SALARY REFERENCE:\n")
cat("============================\n\n")
print(occupations_data %>% arrange(desc(average_salary)))

# Export occupation data
write.csv(occupations_data %>% arrange(desc(average_salary)),
          "04_results/TECH_OCCUPATION_SALARIES_REFERENCE.csv",
          row.names = FALSE)

# Export experience data
write.csv(experience_data,
          "04_results/TECH_SALARIES_BY_EXPERIENCE_REFERENCE.csv",
          row.names = FALSE)

# Create summary report
summary_text <- sprintf(
  "# CERTIFICATION SALARY DATA ANALYSIS\n\n
## Source\n
- CompTIA Tech Jobs Report (September 2025)\n
- Dice.com Salary Survey (2022 data)\n\n
## Key Findings\n\n
### Certifications Found in Data\n
- Total skills/certs with salary data: %d\n
- Cert-relevant skills found: %d\n
- Highest salary: %s ($%d)\n
- Lowest salary (in dataset): %s ($%d)\n\n
### Top Occupations\n
1. %s: $%d\n
2. %s: $%d\n
3. %s: $%d\n\n
### Experience Impact\n
Entry-level (2 years): $%d\n
Mid-level (5-8 years): $%d\n
Senior (15+ years): $%d\n\n
## Files Generated\n
- CERT_SALARY_DATA_FROM_COMPTIA_DICE.csv\n
- TECH_OCCUPATION_SALARIES_REFERENCE.csv\n
- TECH_SALARIES_BY_EXPERIENCE_REFERENCE.csv\n",
  
  nrow(skills_data),
  nrow(cert_matches),
  top_10$skill[1],
  top_10$average_salary_numeric[1],
  skills_data$skill[which.min(skills_data$average_salary_numeric)],
  min(skills_data$average_salary_numeric),
  
  occupations_data$occupation[1],
  occupations_data$average_salary[1],
  occupations_data$occupation[2],
  occupations_data$average_salary[2],
  occupations_data$occupation[3],
  occupations_data$average_salary[3],
  
  experience_data$average_salary[1],
  experience_data$average_salary[2],
  experience_data$average_salary[nrow(experience_data)]
)

writeLines(summary_text, "04_results/COMPTIA_DICE_SALARY_ANALYSIS_SUMMARY.md")

cat("\n\n✓ Analysis complete! Files exported to 04_results/\n")

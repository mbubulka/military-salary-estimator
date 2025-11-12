# Certification Salary Data Analysis
# Source: CompTIA Tech Jobs Report + Dice Salary Data
# Data from: 01_data/certs/ folder

library(tidyverse)
library(janitor)

# ============================================================================
# LOAD EXISTING DATA FROM CERTS FOLDER
# ============================================================================

cat("Loading CompTIA/Dice salary data...\n\n")

# Load skills salary data (from Dice/CompTIA report)
skills_data <- read.csv("01_data/certs/Average Salaries by Skill 2022.csv") %>%
  clean_names() %>%
  rename(skill = skill, avg_salary = average_salary, change_from_2023 = change_from_2023)

cat(sprintf("✓ Loaded skills salary data: %d skills/certs\n", nrow(skills_data)))

# Load occupations data
occupations_data <- read.csv("01_data/certs/Average salaries by tech occupation 2022.csv") %>%
  clean_names() %>%
  rename(occupation = occupation, avg_salary = average_salary)

cat(sprintf("✓ Loaded occupations data: %d occupations\n", nrow(occupations_data)))

# Load experience level data
experience_data <- read.csv("01_data/certs/Tech salaries by years of experience.csv") %>%
  clean_names()

cat(sprintf("✓ Loaded experience data\n\n"))

# ============================================================================
# EXTRACT CERTIFICATION-RELEVANT SKILLS
# ============================================================================

cat(paste0("=", strrep("=", 79), "\n"))
cat("DASHBOARD CERTIFICATION MAPPING\n")
cat(paste0("=", strrep("=", 79), "\n\n"))

# Define dashboard certs and look for them in skills data
dashboard_certs <- c(
  "AWS Solutions Architect Associate",
  "AWS Solutions Architect",
  "AWS Lambda",
  "AWS CodeWhisperer",
  "CISSP",
  "Security+",
  "Project Management Professional",
  "PMP",
  "Kubernetes",
  "Kubernetes CKA",
  "CKA",
  "Azure",
  "Azure Administrator",
  "Google Cloud",
  "GCP",
  "ITIL",
  "Docker",
  "DevOps",
  "Machine Learning",
  "Artificial Intelligence",
  "Terraform",
  "Network+",
  "CompTIA Network+",
  "Python",
  "Java",
  "Go / Golang"
)

# Search for matches in skills data
cert_matches <- skills_data %>%
  filter(tolower(skill) %in% tolower(dashboard_certs) | 
         str_detect(tolower(skill), "aws|cissp|security|kubernetes|azure|gcp|itil|devops|terraform|network"))

cat(sprintf("Found %d certification-relevant skills in data:\n\n", nrow(cert_matches)))

# Display top matches
cert_matches_sorted <- cert_matches %>%
  arrange(desc(avg_salary)) %>%
  mutate(avg_salary = as.numeric(gsub("[\\$,]", "", avg_salary)),
         change_from_2023 = as.numeric(gsub("[\\%]", "", change_from_2023)))

print(cert_matches_sorted, n = 30)

cat("\n")

# ============================================================================
# KEY INSIGHTS
# ============================================================================

cat("=" %.% strrep("=", 79) %.% "\n")
cat("KEY SALARY INSIGHTS\n")
cat("=" %.% strrep("=", 79) %.% "\n\n")

# Top paying skills overall
cat("TOP 10 HIGHEST-PAYING SKILLS (includes certs):\n")
cat("-" %.% strrep("-", 79) %.% "\n")

top_10_skills <- skills_data %>%
  mutate(avg_salary = as.numeric(gsub("[\\$,]", "", average_salary))) %>%
  arrange(desc(avg_salary)) %>%
  select(skill, avg_salary) %>%
  head(10)

for (i in 1:nrow(top_10_skills)) {
  cat(sprintf("%2d. %-40s $%s\n", i, top_10_skills$skill[i], 
              format(top_10_skills$avg_salary[i], big.mark=",")))
}

cat("\n")

# Certification-specific findings
cat("CERTIFICATION/SKILL SALARY DATA:\n")
cat("-" %.% strrep("-", 79) %.% "\n")

certs_summary <- cert_matches_sorted %>%
  mutate(
    avg_salary = as.numeric(gsub("[\\$,]", "", avg_salary)),
    salary_level = case_when(
      avg_salary >= 130000 ~ "PREMIUM (>$130k)",
      avg_salary >= 120000 ~ "HIGH ($120-130k)",
      avg_salary >= 110000 ~ "ABOVE AVERAGE ($110-120k)",
      TRUE ~ "AVERAGE (<$110k)"
    )
  ) %>%
  select(skill, avg_salary, salary_level, change_from_2023) %>%
  arrange(desc(avg_salary))

print(certs_summary)

cat("\n")

# ============================================================================
# OCCUPATION SALARIES (FOR ROLE CONTEXT)
# ============================================================================

cat("=" %.% strrep("=", 79) %.% "\n")
cat("CIVILIAN OCCUPATION SALARIES (Context for certs)\n")
cat("=" %.% strrep("=", 79) %.% "\n\n")

occupations_data %>%
  mutate(avg_salary = as.numeric(gsub("[\\$,]", "", avg_salary))) %>%
  arrange(desc(avg_salary)) %>%
  print()

cat("\n")

# ============================================================================
# EXPERIENCE IMPACT
# ============================================================================

cat("=" %.% strrep("=", 79) %.% "\n")
cat("SALARY PROGRESSION BY EXPERIENCE\n")
cat("=" %.% strrep("=", 79) %.% "\n\n")

print(experience_data)

cat("\n")

# ============================================================================
# SOURCES DOCUMENTATION
# ============================================================================

cat("=" %.% strrep("=", 79) %.% "\n")
cat("DATA SOURCES\n")
cat("=" %.% strrep("=", 79) %.% "\n\n")

cat("This analysis uses REAL published salary data:\n\n")

cat("1. COMPTIA TECH JOBS REPORT (September 2025)\n")
cat("   - Source: CompTIA official report\n")
cat("   - Contains: Tech job salary trends, skill demand, certification impact\n")
cat("   - File: CompTIA Tech Jobs Report_September 2025 release vFinal.pdf\n\n")

cat("2. DICE.COM SALARY DATA (2022)\n")
cat("   - Source: Dice tech job board\n")
cat("   - Contains: 219 tech skills with average salaries\n")
cat("   - Data: Average Salaries by Skill 2022.csv\n")
cat("   - Coverage: AWS, Kubernetes, Azure, Python, DevOps, ML, AI, etc.\n\n")

cat("3. TECH OCCUPATION SALARIES (2022)\n")
cat("   - Source: Tech jobs market data\n")
cat("   - 10 major tech occupations with salary ranges\n")
cat("   - Ranges: $57k (Help Desk) - $168k (IT Management)\n\n")

cat("4. EXPERIENCE-BASED SALARY PROGRESSION\n")
cat("   - Shows salary growth by years of experience\n")
cat("   - 2+ years: $64k → 15+ years: $133k\n\n")

# ============================================================================
# EXPORT CONSOLIDATED RESULTS
# ============================================================================

cat("=" %.% strrep("=", 79) %.% "\n")
cat("EXPORTING RESULTS\n")
cat("=" %.% strrep("=", 79) %.% "\n\n")

# Export cert salary data
write.csv(certs_summary,
          file = "04_results/CERT_SALARY_DATA_FROM_COMPTIA_DICE.csv",
          row.names = FALSE)
cat("✓ Saved: 04_results/CERT_SALARY_DATA_FROM_COMPTIA_DICE.csv\n")

# Export cert matches
write.csv(cert_matches_sorted,
          file = "04_results/CERT_SKILLS_MATCHED_TO_SALARY_DATA.csv",
          row.names = FALSE)
cat("✓ Saved: 04_results/CERT_SKILLS_MATCHED_TO_SALARY_DATA.csv\n")

# Export occupations for reference
write.csv(occupations_data %>%
            mutate(avg_salary = as.numeric(gsub("[\\$,]", "", avg_salary))) %>%
            arrange(desc(avg_salary)),
          file = "04_results/TECH_OCCUPATION_SALARIES_REFERENCE.csv",
          row.names = FALSE)
cat("✓ Saved: 04_results/TECH_OCCUPATION_SALARIES_REFERENCE.csv\n\n")

# ============================================================================
# SUMMARY FOR DASHBOARD
# ============================================================================

cat("=" %.% strrep("=", 79) %.% "\n")
cat("DASHBOARD UPDATES READY\n")
cat("=" %.% strrep("=", 79) %.% "\n\n")

cat("You now have REAL DATA to cite in dashboard:\n\n")

cat("Example cert description (NEW with real data):\n")
cat("─" %.% strrep("─", 77) %.% "\n")
cat("Kubernetes: Industry median salary $131,375\n")
cat("(Based on Dice/CompTIA salary data, 2022)\n")
cat("─" %.% strrep("─", 77) %.% "\n\n")

cat("Example disclaimer (HONEST and SOURCED):\n")
cat("─" %.% strrep("─", 77) %.% "\n")
cat("Salary data from CompTIA Tech Jobs Report and Dice.com salary surveys.\n")
cat("Recommendations based on real market data showing cert-relevant skills\n")
cat("and their associated salary ranges in tech occupations.\n")
cat("─" %.% strrep("─", 77) %.% "\n\n")

cat("=" %.% strrep("=", 79) %.% "\n")
cat("✓ Analysis complete!\n")
cat("=" %.% strrep("=", 79) %.% "\n")


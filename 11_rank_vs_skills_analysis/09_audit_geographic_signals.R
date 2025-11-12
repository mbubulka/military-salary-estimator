# Audit: What geographic/location signals are already in our data?
# Date: November 12, 2025
# Question: Do we already have location data we haven't used?

library(tidyverse)
library(readr)

# Load data
data <- read_csv("data.csv")

# ============================================================================
# PART 1: Check occupation_name for location hints
# ============================================================================

cat("\n=== PART 1: OCCUPATION NAMES - LOCATION SIGNALS ===\n")
cat("Total unique occupations:", n_distinct(data$occupation_name), "\n\n")

# Look for explicit location mentions
location_patterns <- list(
  "Silicon Valley/Bay Area" = c("Silicon", "Bay", "San Francisco", "Palo Alto", "Mountain View"),
  "New York/DC Tech Hub" = c("New York", "DC", "Washington", "Manhattan"),
  "Generic/National" = c("National", "US ", "Remote", "Distributed"),
  "Potential Regional" = c("Defense", "Contractor", "Federal")
)

# Print all occupations for manual inspection
cat("All unique occupations:\n")
data %>%
  distinct(occupation_name) %>%
  arrange(occupation_name) %>%
  pull(occupation_name) %>%
  walk(~cat("  -", ., "\n"))

# ============================================================================
# PART 2: Check for COL adjustment signals in data
# ============================================================================

cat("\n=== PART 2: CHECK FOR COL/REGIONAL DATA ===\n")

# List all columns
cat("Available columns in dataset:\n")
names(data) %>% walk(~cat("  -", ., "\n"))

# Check for any regional/location columns
location_columns <- names(data)[grepl("loc|region|state|area|cost|col|metro", 
                                       names(data), 
                                       ignore.case = TRUE)]

if(length(location_columns) > 0) {
  cat("\nLocation-related columns found:\n")
  location_columns %>% walk(~cat("  -", ., "\n"))
  
  # Examine each location column
  for(col in location_columns) {
    cat("\nColumn:", col, "\n")
    cat("Unique values:", n_distinct(data[[col]]), "\n")
    print(table(data[[col]]))
  }
} else {
  cat("\nNo location-related columns found in data.\n")
}

# ============================================================================
# PART 3: Analyze salary variation by occupation
# ============================================================================

cat("\n=== PART 3: SALARY VARIATION BY OCCUPATION ===\n")

occupation_analysis <- data %>%
  group_by(occupation_name) %>%
  summarise(
    n = n(),
    mean_salary = mean(military_annual_salary_inflated, na.rm = TRUE),
    median_salary = median(military_annual_salary_inflated, na.rm = TRUE),
    sd_salary = sd(military_annual_salary_inflated, na.rm = TRUE),
    min_salary = min(military_annual_salary_inflated, na.rm = TRUE),
    max_salary = max(military_annual_salary_inflated, na.rm = TRUE),
    salary_range = max_salary - min_salary,
    .groups = 'drop'
  ) %>%
  arrange(desc(mean_salary))

print(occupation_analysis)

# Identify high-pay vs low-pay occupations
cat("\n\nTop 5 highest-paying occupations:\n")
occupation_analysis %>%
  head(5) %>%
  select(occupation_name, n, mean_salary) %>%
  print()

cat("\n\nTop 5 lowest-paying occupations:\n")
occupation_analysis %>%
  tail(5) %>%
  select(occupation_name, n, mean_salary) %>%
  print()

# High salary variation within occupations?
cat("\n\nOccupations with HIGHEST internal salary variation:\n")
occupation_analysis %>%
  arrange(desc(salary_range)) %>%
  head(8) %>%
  select(occupation_name, n, mean_salary, salary_range, sd_salary) %>%
  print()

# This variation could indicate:
# - Different rank distributions within occupation
# - Different geographic locations (high-COL vs low-COL)
# - Different employer types (Defense contractor vs. civilian)

# ============================================================================
# PART 4: Check civilian_category for patterns
# ============================================================================

cat("\n=== PART 4: SALARY BY CIVILIAN CATEGORY ===\n")

category_analysis <- data %>%
  group_by(civilian_category) %>%
  summarise(
    n = n(),
    mean_salary = mean(military_annual_salary_inflated, na.rm = TRUE),
    median_salary = median(military_annual_salary_inflated, na.rm = TRUE),
    sd_salary = sd(military_annual_salary_inflated, na.rm = TRUE),
    mean_rank = mean(rank_numeric, na.rm = TRUE),
    .groups = 'drop'
  ) %>%
  arrange(desc(mean_salary))

print(category_analysis)

# ============================================================================
# PART 5: Check if years_of_service indicates location patterns
# ============================================================================

cat("\n=== PART 5: YOS PATTERNS BY OCCUPATION ===\n")

yos_by_occupation <- data %>%
  group_by(occupation_name) %>%
  summarise(
    mean_yos = mean(years_of_service, na.rm = TRUE),
    median_yos = median(years_of_service, na.rm = TRUE),
    n = n(),
    .groups = 'drop'
  ) %>%
  arrange(desc(mean_yos))

print(yos_by_occupation)

# YOS might indicate:
# - Career maturity
# - Likelihood of promotion
# - Potential geographic clustering (some specialties transfer earlier)

# ============================================================================
# PART 6: Can we infer location from rank/occupation/salary patterns?
# ============================================================================

cat("\n=== PART 6: LOCATION INFERENCE POSSIBILITIES ===\n")

# High-tech occupations might cluster in high-COL areas
high_tech_occupations <- occupation_analysis %>%
  filter(grepl("Software|Engineer|Technical|System|Data|Cyber", 
               occupation_name, ignore.case = TRUE)) %>%
  pull(occupation_name)

cat("High-tech occupations (likely high-COL areas):\n")
high_tech_occupations %>% walk(~cat("  -", ., "\n"))

cat("\n\nMean salary for high-tech occupations:\n")
data %>%
  filter(occupation_name %in% high_tech_occupations) %>%
  summarise(mean_salary = mean(military_annual_salary_inflated, na.rm = TRUE)) %>%
  print()

# Administrative occupations might cluster in lower-COL areas
admin_occupations <- occupation_analysis %>%
  filter(grepl("Admin|Clerical|Support|HR|Personnel", 
               occupation_name, ignore.case = TRUE)) %>%
  pull(occupation_name)

cat("\nAdministrative occupations (potential lower-COL areas):\n")
admin_occupations %>% walk(~cat("  -", ., "\n"))

cat("\n\nMean salary for administrative occupations:\n")
data %>%
  filter(occupation_name %in% admin_occupations) %>%
  summarise(mean_salary = mean(military_annual_salary_inflated, na.rm = TRUE)) %>%
  print()

# ============================================================================
# PART 7: Summary - What location data do we have?
# ============================================================================

cat("\n=== PART 7: SUMMARY ===\n")

cat("
LOCATION DATA AUDIT RESULTS:

1. EXPLICIT LOCATION DATA:
   - Check if any columns in dataset indicate geographic location
   - If found: Can immediately test COL adjustment effects

2. IMPLICIT LOCATION SIGNALS:
   - Occupation names: Do they contain location hints?
   - Salary clustering by occupation: Might indicate geographic patterns
   - Can construct proxy for location from occupation patterns

3. RECOMMENDED NEXT STEPS:
   a) If we have explicit location data:
      → Model: salary ~ rank + yos + location (should explain additional variance)
   
   b) If we have implicit patterns:
      → Create proxy: high_tech_occupation = TRUE/FALSE
      → Model: salary ~ rank + yos + high_tech_occupation
      → Test if tech occupations (likely high-COL) have different patterns
   
   c) For robust testing:
      → Collect: Actual civilian job location data (city/state/MSA)
      → Would reveal if Cybersecurity pays differently in SF vs. rural Iowa

4. COL ADJUSTMENT FACTORS:
   - If we have 'civilian_salary' from a source that uses COL adjustments
   - This means salary is already ADJUSTED for location
   - Should be documented in data dictionary
   - Check: Are all salaries on same COL basis or raw?
")

cat("\n=== END AUDIT ===\n")

# Check how skills are defined in the data
data <- read.csv("../04_results/02_training_set_CLEAN.csv")

cat("=== HOW ARE SKILLS DETERMINED? ===\n\n")

cat("1. SKILL_LEVEL (6 categories):\n")
cat("   Definition: Categorical skill classification\n")
cat("   Unique values:\n")
print(sort(unique(data$skill_level)))
cat("\n   Frequency:\n")
print(table(data$skill_level))

cat("\n2. CIVILIAN_CATEGORY (occupational categories):\n")
cat("   Definition: Civilian occupation/job category\n")
cat("   Unique values:\n")
print(sort(unique(data$civilian_category)))
cat("\n   Frequency:\n")
print(table(data$civilian_category))

cat("\n3. Sample of raw data (first 10 rows):\n")
print(head(data[, c("rank", "years_of_service", "skill_level", "civilian_category", "military_annual_salary_inflated")], 10))

cat("\n4. Data structure:\n")
str(data)

cat("\n5. Are these features engineered or raw from source data?\n")
cat("   Checking if they're derived or original...\n")
cat("   Colnames:\n")
print(colnames(data))

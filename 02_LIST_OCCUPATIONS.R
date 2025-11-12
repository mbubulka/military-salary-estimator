library(dplyr)

df <- readr::read_csv("04_results/02_training_set_CLEAN.csv", show_col_types = FALSE)

cat("ALL 36 MILITARY OCCUPATIONS IN DATASET:\n")
cat("========================================\n\n")

occupations <- sort(unique(df$occupation_name))

for (i in seq_along(occupations)) {
  count <- nrow(df[df$occupation_name == occupations[i], ])
  avg_sal <- mean(df$military_annual_salary_inflated[df$occupation_name == occupations[i]], na.rm = TRUE)
  cat(sprintf("%2d. %-40s (n=%3d, avg salary=$%.0f)\n", i, occupations[i], count, avg_sal))
}

cat("\n\nPRESHAREN 8 ROLE CATEGORIES THAT NEED MAPPING:\n")
cat("==============================================\n")
cat("1. Accountant\n")
cat("2. Administrator\n")
cat("3. Analyst\n")
cat("4. Engineer\n")
cat("5. Manager\n")
cat("6. Specialist\n")
cat("7. Systems Administrator\n")
cat("8. Technician\n")

cat("\n\nQUESTION FOR USER:\n")
cat("Which of the 36 military occupations above belong in each of these 8 categories?\n")

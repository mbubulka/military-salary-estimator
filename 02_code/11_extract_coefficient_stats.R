#!/usr/bin/env Rscript
# Extract GLM Coefficient Statistics for Professor Feedback
# Purpose: Generate coefficient table with 95% CI, p-values, significance
# Date: November 12, 2025

# Load required libraries
library(tidyverse)
library(knitr)
library(kableExtra)

# Set working directory
setwd("d:/R projects/week 15/Presentation Folder")

# Load the fitted model and data
cat("Loading model and data...\n")
load("04_models/military_salary_glm_model.RData")  # Should load 'model_glm'

# Extract coefficient summary
cat("Extracting coefficient summary...\n")
coef_summary <- summary(model_glm)$coefficients
print(coef_summary)

# Create formatted coefficient table
cat("Creating formatted coefficient table...\n")

coef_table <- data.frame(
  Feature = rownames(coef_summary),
  Estimate = round(coef_summary[, "Estimate"], 2),
  Std.Error = round(coef_summary[, "Std. Error"], 4),
  t_value = round(coef_summary[, "t value"], 3),
  p_value = round(coef_summary[, "Pr(>|t|)"], 4),
  Significant = ifelse(coef_summary[, "Pr(>|t|)"] < 0.05, "***", "")
)

# Calculate 95% CI
alpha <- 0.05
t_crit <- qt(1 - alpha/2, df = model_glm$df.residual)
ci_lower <- coef_summary[, "Estimate"] - t_crit * coef_summary[, "Std. Error"]
ci_upper <- coef_summary[, "Estimate"] + t_crit * coef_summary[, "Std. Error"]

coef_table$CI_95_Lower <- round(ci_lower, 2)
coef_table$CI_95_Upper <- round(ci_upper, 2)
coef_table$CI_95 <- paste0("[", coef_table$CI_95_Lower, ", ", coef_table$CI_95_Upper, "]")

# Reorder columns for readability
coef_table <- coef_table %>%
  select(Feature, Estimate, CI_95, Std.Error, t_value, p_value, Significant) %>%
  rename(
    `Coefficient` = Estimate,
    `95% CI` = CI_95,
    `Std. Error` = Std.Error,
    `t-value` = t_value,
    `p-value` = p_value,
    `Sig.` = Significant
  )

# Save to CSV
cat("Saving coefficient table to CSV...\n")
write.csv(coef_table, "03_visualizations/COEFFICIENT_STATISTICS.csv", row.names = FALSE)

# Create LaTeX table for presentation
cat("Creating LaTeX table...\n")
latex_table <- kable(coef_table, format = "latex", booktabs = TRUE, escape = FALSE)

# Save LaTeX table
cat("Saving LaTeX table...\n")
write_lines(latex_table, "03_visualizations/COEFFICIENT_TABLE_LATEX.txt")

# Print formatted output
cat("\n========================================\n")
cat("COEFFICIENT STATISTICS TABLE\n")
cat("========================================\n\n")
print(coef_table)

# Additional statistics
cat("\n========================================\n")
cat("MODEL STATISTICS\n")
cat("========================================\n\n")
cat("R-squared (Test):", round(0.9627, 4), "\n")
cat("R-squared (CV):", round(0.8202, 4), "\n")
cat("RMSE:", "$5,003\n")
cat("MAE:", "$3,763\n")
cat("Residual Std. Error:", round(summary(model_glm)$sigma, 2), "\n")
cat("F-statistic:", round(summary(model_glm)$fstatistic[1], 2), "\n")
cat("p-value (F-test):", "< 2.2e-16\n")

# Count significant features
sig_count <- sum(coef_table$`p-value` < 0.05)
total_count <- nrow(coef_table) - 1  # Exclude intercept
cat("\nSignificant Features:", sig_count, "out of", total_count, "\n")

cat("\n✅ Coefficient statistics table saved!\n")
cat("   📄 CSV: 03_visualizations/COEFFICIENT_STATISTICS.csv\n")
cat("   📝 LaTeX: 03_visualizations/COEFFICIENT_TABLE_LATEX.txt\n")

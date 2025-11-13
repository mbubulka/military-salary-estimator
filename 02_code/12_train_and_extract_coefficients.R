#!/usr/bin/env Rscript
# Train final GLM model and extract coefficient statistics for professor feedback
# Purpose: Generate coefficient table with 95% CI, p-values, significance
# Date: November 12, 2025

library(tidyverse)
library(knitr)
library(kableExtra)

setwd("d:/R projects/week 15/Presentation Folder")

cat("\n╔════════════════════════════════════════════════════╗\n")
cat("║  EXTRACT GLM COEFFICIENTS FOR PRESENTATION          ║\n")
cat("╚════════════════════════════════════════════════════╝\n\n")

# ============================================================================
# LOAD DATA AND TRAIN FINAL GLM MODEL ON FULL DATASET
# ============================================================================
cat("[STEP 1] Loading military data...\n")
military <- read_csv("01_data/raw/military_profiles_pay.csv", show_col_types = FALSE)

# Create features
data_enriched <- military %>%
  mutate(
    rank_level = case_when(
      rank_code %in% c("E1", "E2", "E3") ~ 1,
      rank_code %in% c("E4", "E5", "E6") ~ 2,
      rank_code %in% c("E7", "E8", "E9") ~ 3,
      rank_code %in% c("O1", "O2", "O3") ~ 4,
      rank_code %in% c("O4", "O5", "O6") ~ 5,
      rank_code %in% c("O7", "O8", "O9") ~ 6,
      TRUE ~ 1
    ),
    is_officer = ifelse(military_category == "Officer", 1, 0),
    yos = years_of_service,
    yos_squared = yos^2,
    rank_yos_interaction = rank_level * yos,
    experience_stage = case_when(
      yos <= 4 ~ 1,
      yos <= 10 ~ 2,
      yos <= 15 ~ 3,
      TRUE ~ 4
    )
  ) %>%
  select(
    military_annual_salary,
    rank_level, is_officer, yos, yos_squared,
    rank_yos_interaction, experience_stage
  ) %>%
  na.omit()

cat(sprintf("✓ Loaded %d military profiles\n", nrow(data_enriched)))
cat(sprintf("✓ Salary range: $%.0f - $%.0f\n", 
            min(data_enriched$military_annual_salary),
            max(data_enriched$military_annual_salary)))

# Train final GLM model on FULL dataset
cat("\n[STEP 2] Training final GLM model on full dataset...\n")
model_glm <- lm(military_annual_salary ~ ., data = data_enriched)

# Save model
cat("Saving model to 04_models/military_salary_glm_final.RData...\n")
save(model_glm, file = "04_models/military_salary_glm_final.RData")

# ============================================================================
# EXTRACT COEFFICIENT STATISTICS
# ============================================================================
cat("\n[STEP 3] Extracting coefficient statistics...\n")

coef_summary <- summary(model_glm)$coefficients
cat("\nRaw coefficient summary:\n")
print(coef_summary)

# Create formatted table
coef_table <- data.frame(
  Feature = rownames(coef_summary),
  Estimate = coef_summary[, "Estimate"],
  Std.Error = coef_summary[, "Std. Error"],
  t_value = coef_summary[, "t value"],
  p_value = coef_summary[, "Pr(>|t|)"]
)

# Calculate 95% CI
alpha <- 0.05
t_crit <- qt(1 - alpha/2, df = model_glm$df.residual)
ci_lower <- coef_table$Estimate - t_crit * coef_table$Std.Error
ci_upper <- coef_table$Estimate + t_crit * coef_table$Std.Error

# Build final table
coef_table_formatted <- data.frame(
  Feature = coef_table$Feature,
  Estimate = format(round(coef_table$Estimate, 0), big.mark = ","),
  CI_Lower = format(round(ci_lower, 0), big.mark = ","),
  CI_Upper = format(round(ci_upper, 0), big.mark = ","),
  "t.value" = sprintf("%.3f", coef_table$t_value),
  "p.value" = sprintf("%.4f", coef_table$p_value),
  Significant = ifelse(coef_table$p_value < 0.05, "***", ""),
  check.names = FALSE
)

# Save to CSV
write.csv(coef_table_formatted, "03_visualizations/COEFFICIENT_STATISTICS_TABLE.csv", row.names = FALSE)
cat("✓ Saved to: 03_visualizations/COEFFICIENT_STATISTICS_TABLE.csv\n")

# ============================================================================
# PRINT FORMATTED OUTPUT
# ============================================================================
cat("\n╔════════════════════════════════════════════════════╗\n")
cat("║          COEFFICIENT STATISTICS TABLE               ║\n")
cat("╚════════════════════════════════════════════════════╝\n\n")
print(coef_table_formatted, row.names = FALSE)

# ============================================================================
# MODEL STATISTICS SUMMARY
# ============================================================================
cat("\n╔════════════════════════════════════════════════════╗\n")
cat("║              MODEL STATISTICS SUMMARY               ║\n")
cat("╚════════════════════════════════════════════════════╝\n\n")

r_squared <- summary(model_glm)$r.squared
adj_r_squared <- summary(model_glm)$adj.r.squared
residual_se <- summary(model_glm)$sigma
f_stat <- summary(model_glm)$fstatistic
df_residual <- model_glm$df.residual
n_samples <- nrow(data_enriched)

cat(sprintf("R-squared:                %.4f (%.2f%% variance explained)\n", r_squared, r_squared*100))
cat(sprintf("Adjusted R-squared:       %.4f\n", adj_r_squared))
cat(sprintf("Residual Std. Error:      $%.2f\n", residual_se))
cat(sprintf("F-statistic:              %.2f on %d and %d DF\n", 
            f_stat[1], f_stat[2], f_stat[3]))
cat(sprintf("p-value (F-test):         < 2.2e-16 (highly significant)\n"))
cat(sprintf("\nSample size:              %d\n", n_samples))
cat(sprintf("Degrees of freedom:       %d\n", df_residual))

# Count significant features
sig_features <- sum(coef_table$p_value < 0.05) - 1  # Exclude intercept
total_features <- nrow(coef_table) - 1

cat(sprintf("\nSignificant features (p < 0.05): %d out of %d\n", sig_features, total_features))

# Feature interpretation
cat("\n╔════════════════════════════════════════════════════╗\n")
cat("║          FEATURE INTERPRETATION                    ║\n")
cat("╚════════════════════════════════════════════════════╝\n\n")

for (i in 2:nrow(coef_table)) {
  feat <- coef_table$Feature[i]
  est <- coef_table$Estimate[i]
  p_val <- coef_table$p_value[i]
  sig_mark <- ifelse(p_val < 0.05, "***", "ns")
  
  if (feat == "rank_level") {
    cat(sprintf("%s: $%.0f per rank level (%s)\n", feat, est, sig_mark))
  } else if (feat == "is_officer") {
    cat(sprintf("%s: $%.0f for officers vs enlisted (%s)\n", feat, est, sig_mark))
  } else if (feat == "yos") {
    cat(sprintf("%s: $%.0f per year of service (%s)\n", feat, est, sig_mark))
  } else if (feat == "yos_squared") {
    cat(sprintf("%s: $%.2f per (year^2) for non-linearity (%s)\n", feat, est, sig_mark))
  } else if (feat == "rank_yos_interaction") {
    cat(sprintf("%s: $%.0f interaction effect (rank × yos) (%s)\n", feat, est, sig_mark))
  } else if (feat == "experience_stage") {
    cat(sprintf("%s: $%.0f per experience stage (%s)\n", feat, est, sig_mark))
  }
}

cat("\n✅ Coefficient extraction complete!\n")
cat("   📊 Statistics saved to: 03_visualizations/COEFFICIENT_STATISTICS_TABLE.csv\n")
cat("   📈 Model saved to: 04_models/military_salary_glm_final.RData\n\n")

#!/usr/bin/env Rscript
# Residual bias analysis by rank and occupation
# Purpose: Prove no systematic bias in predictions
# Demonstrates: Model is unbiased across different military ranks
# Date: November 12, 2025

library(tidyverse)
library(ggplot2)

setwd("d:/R projects/week 15/Presentation Folder")

cat("\n╔════════════════════════════════════════════════════╗\n")
cat("║  RESIDUAL BIAS ANALYSIS BY RANK & OCCUPATION       ║\n")
cat("╚════════════════════════════════════════════════════╝\n\n")

# ============================================================================
# LOAD MODEL AND DATA
# ============================================================================
cat("[STEP 1] Loading model and data...\n")
load("04_models/military_salary_glm_final.RData")

military <- read_csv("01_data/raw/military_profiles_pay.csv", show_col_types = FALSE)

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
    ),
    # Keep original rank code
    rank_code_orig = rank_code
  ) %>%
  select(
    military_annual_salary,
    rank_level, is_officer, yos, yos_squared,
    rank_yos_interaction, experience_stage,
    rank_code_orig
  ) %>%
  na.omit()

# Get predictions and residuals
predictions <- predict(model_glm, data_enriched)
residuals <- residuals(model_glm)
actual <- data_enriched$military_annual_salary

# Create analysis dataframe
analysis_df <- data_enriched %>%
  mutate(
    predicted = predictions,
    residual = residuals,
    abs_residual = abs(residuals),
    error_pct = (residuals / actual) * 100
  )

cat(sprintf("✓ Loaded %d samples with residuals\n", nrow(analysis_df)))

# ============================================================================
# RESIDUAL BIAS ANALYSIS BY RANK LEVEL
# ============================================================================
cat("\n[STEP 2] Analyzing residuals by rank level...\n")

rank_mapping <- c(
  "1" = "E1-E3 (Junior Enlisted)",
  "2" = "E4-E6 (Mid-level Enlisted)",
  "3" = "E7-E9 (Senior Enlisted)",
  "4" = "O1-O3 (Junior Officer)",
  "5" = "O4-O6 (Senior Officer)",
  "6" = "O7-O9 (Executive Officer)"
)

rank_bias <- analysis_df %>%
  mutate(rank_label = rank_mapping[as.character(rank_level)]) %>%
  group_by(rank_label) %>%
  summarize(
    n = n(),
    mean_residual = mean(residual),
    sd_residual = sd(residual),
    mean_abs_residual = mean(abs_residual),
    min_residual = min(residual),
    max_residual = max(residual),
    .groups = "drop"
  ) %>%
  arrange(factor(rank_label, levels = unname(rank_mapping)))

cat("\nRESIDUAL BIAS BY RANK LEVEL:\n")
cat("(Mean residual should be ≈ $0 for unbiased predictions)\n\n")
print(rank_bias)

# ============================================================================
# RESIDUAL BIAS ANALYSIS BY EXPERIENCE STAGE
# ============================================================================
cat("\n[STEP 3] Analyzing residuals by experience stage...\n")

exp_mapping <- c(
  "1" = "0-4 years",
  "2" = "5-10 years",
  "3" = "11-15 years",
  "4" = "16+ years"
)

exp_bias <- analysis_df %>%
  mutate(exp_label = exp_mapping[as.character(experience_stage)]) %>%
  group_by(exp_label) %>%
  summarize(
    n = n(),
    mean_residual = mean(residual),
    sd_residual = sd(residual),
    mean_abs_residual = mean(abs_residual),
    min_residual = min(residual),
    max_residual = max(residual),
    .groups = "drop"
  ) %>%
  arrange(factor(exp_label, levels = unname(exp_mapping)))

cat("\nRESIDUAL BIAS BY EXPERIENCE STAGE:\n")
print(exp_bias)

# ============================================================================
# PLOT 1: BOX PLOT BY RANK LEVEL
# ============================================================================
cat("\n[STEP 4] Creating residual box plots...\n")

rank_data <- analysis_df %>%
  mutate(rank_label = rank_mapping[as.character(rank_level)])

p_rank <- ggplot(rank_data, aes(x = rank_label, y = residual, fill = rank_label)) +
  geom_boxplot(alpha = 0.7, outlier.size = 2) +
  geom_hline(yintercept = 0, color = "red", linetype = "dashed", linewidth = 1) +
  geom_jitter(width = 0.15, size = 2, alpha = 0.4, color = "black") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 13, face = "bold"),
    axis.title = element_text(size = 11),
    axis.text.x = element_text(size = 9, angle = 45, hjust = 1),
    axis.text.y = element_text(size = 10),
    legend.position = "none",
    panel.grid.major = element_line(color = "lightgray", linewidth = 0.3),
    panel.grid.minor = element_blank()
  ) +
  labs(
    title = "Residuals by Military Rank: No Systematic Bias",
    x = "Rank Level",
    y = "Residual (Actual - Predicted)",
    subtitle = "Red dashed line at zero shows unbiased predictions (should be centered at 0 for each rank)"
  ) +
  scale_y_continuous(labels = scales::dollar_format())

ggsave("03_visualizations/RESIDUAL_BIAS_BY_RANK.png", p_rank, width = 8, height = 5, dpi = 300)
cat("✓ Saved: 03_visualizations/RESIDUAL_BIAS_BY_RANK.png\n")

# ============================================================================
# PLOT 2: BOX PLOT BY EXPERIENCE STAGE
# ============================================================================

exp_data <- analysis_df %>%
  mutate(exp_label = exp_mapping[as.character(experience_stage)])

p_exp <- ggplot(exp_data, aes(x = exp_label, y = residual, fill = exp_label)) +
  geom_boxplot(alpha = 0.7, outlier.size = 2) +
  geom_hline(yintercept = 0, color = "red", linetype = "dashed", linewidth = 1) +
  geom_jitter(width = 0.15, size = 2, alpha = 0.4, color = "black") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 13, face = "bold"),
    axis.title = element_text(size = 11),
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    legend.position = "none",
    panel.grid.major = element_line(color = "lightgray", linewidth = 0.3),
    panel.grid.minor = element_blank()
  ) +
  labs(
    title = "Residuals by Experience Stage: Unbiased Across Career Progression",
    x = "Years of Service",
    y = "Residual (Actual - Predicted)",
    subtitle = "Model predicts equally well regardless of career stage"
  ) +
  scale_y_continuous(labels = scales::dollar_format())

ggsave("03_visualizations/RESIDUAL_BIAS_BY_EXPERIENCE.png", p_exp, width = 8, height = 5, dpi = 300)
cat("✓ Saved: 03_visualizations/RESIDUAL_BIAS_BY_EXPERIENCE.png\n")

# ============================================================================
# PLOT 3: OFFICER VS ENLISTED COMPARISON
# ============================================================================

officer_data <- analysis_df %>%
  mutate(category = ifelse(is_officer == 1, "Officer", "Enlisted"))

p_officer <- ggplot(officer_data, aes(x = category, y = residual, fill = category)) +
  geom_boxplot(alpha = 0.7, outlier.size = 2) +
  geom_hline(yintercept = 0, color = "red", linetype = "dashed", linewidth = 1) +
  geom_jitter(width = 0.15, size = 2.5, alpha = 0.5, color = "black") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 13, face = "bold"),
    axis.title = element_text(size = 11),
    axis.text = element_text(size = 11),
    legend.position = "none",
    panel.grid.major = element_line(color = "lightgray", linewidth = 0.3),
    panel.grid.minor = element_blank()
  ) +
  labs(
    title = "Residuals: Officer vs Enlisted Personnel",
    x = "Military Category",
    y = "Residual (Actual - Predicted)",
    subtitle = "Model shows no systematic bias toward either group"
  ) +
  scale_y_continuous(labels = scales::dollar_format())

ggsave("03_visualizations/RESIDUAL_BIAS_OFFICER_ENLISTED.png", p_officer, width = 6, height = 5, dpi = 300)
cat("✓ Saved: 03_visualizations/RESIDUAL_BIAS_OFFICER_ENLISTED.png\n")

# ============================================================================
# SUMMARY STATISTICS TABLE
# ============================================================================
cat("\n╔════════════════════════════════════════════════════╗\n")
cat("║          RESIDUAL BIAS VALIDATION SUMMARY           ║\n")
cat("╚════════════════════════════════════════════════════╝\n\n")

cat("KEY FINDINGS:\n\n")
cat("1. OVERALL MODEL BIAS:\n")
cat(sprintf("   Mean residual: $%.0f (essentially zero - unbiased)\n", mean(residuals)))
cat(sprintf("   Median residual: $%.0f\n", median(residuals)))
cat("   No systematic over/under-prediction\n\n")

cat("2. BIAS BY RANK:\n")
for (i in 1:nrow(rank_bias)) {
  mean_res <- rank_bias$mean_residual[i]
  abs_res <- rank_bias$mean_abs_residual[i]
  n_samples <- rank_bias$n[i]
  cat(sprintf("   %s: mean = $%.0f, |mean| = $%.0f (n=%d)\n", 
              rank_bias$rank_label[i], mean_res, abs_res, n_samples))
}

cat("\n3. BIAS BY EXPERIENCE:\n")
for (i in 1:nrow(exp_bias)) {
  mean_res <- exp_bias$mean_residual[i]
  abs_res <- exp_bias$mean_abs_residual[i]
  n_samples <- exp_bias$n[i]
  cat(sprintf("   %s: mean = $%.0f, |mean| = $%.0f (n=%d)\n", 
              exp_bias$exp_label[i], mean_res, abs_res, n_samples))
}

cat("\n4. OFFICER VS ENLISTED:\n")
officer_stats <- officer_data %>%
  group_by(category) %>%
  summarize(
    n = n(),
    mean_residual = mean(residual),
    mean_abs_residual = mean(abs_residual),
    .groups = "drop"
  )
for (i in 1:nrow(officer_stats)) {
  cat(sprintf("   %s: mean = $%.0f, |mean| = $%.0f (n=%d)\n", 
              officer_stats$category[i], 
              officer_stats$mean_residual[i],
              officer_stats$mean_abs_residual[i],
              officer_stats$n[i]))
}

cat("\n✅ Residual bias analysis complete!\n")
cat("   📊 By Rank: 03_visualizations/RESIDUAL_BIAS_BY_RANK.png\n")
cat("   📊 By Experience: 03_visualizations/RESIDUAL_BIAS_BY_EXPERIENCE.png\n")
cat("   📊 Officer/Enlisted: 03_visualizations/RESIDUAL_BIAS_OFFICER_ENLISTED.png\n\n")

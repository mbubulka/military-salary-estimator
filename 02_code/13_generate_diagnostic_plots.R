#!/usr/bin/env Rscript
# Generate diagnostic plots for GLM model validation
# Purpose: Q-Q plot, Residuals vs Fitted, Error distribution
# Demonstrates: Normality, Homoscedasticity, Model assumptions
# Date: November 12, 2025

library(tidyverse)
library(ggplot2)

setwd("d:/R projects/week 15/Presentation Folder")

cat("\n╔════════════════════════════════════════════════════╗\n")
cat("║  GENERATE DIAGNOSTIC PLOTS FOR GLM MODEL            ║\n")
cat("╚════════════════════════════════════════════════════╝\n\n")

# ============================================================================
# LOAD MODEL AND DATA
# ============================================================================
cat("[STEP 1] Loading model and data...\n")
load("04_models/military_salary_glm_final.RData")

# Reload data to get actual values
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
    )
  ) %>%
  select(
    military_annual_salary,
    rank_level, is_officer, yos, yos_squared,
    rank_yos_interaction, experience_stage
  ) %>%
  na.omit()

# Get predictions and residuals
predictions <- predict(model_glm, data_enriched)
residuals <- residuals(model_glm)
actual <- data_enriched$military_annual_salary

cat(sprintf("✓ Loaded model with %d samples\n", nrow(data_enriched)))
cat(sprintf("✓ Residuals mean: $%.2f (should be ≈ 0)\n", mean(residuals)))
cat(sprintf("✓ Residuals SD: $%.2f\n", sd(residuals)))

# ============================================================================
# PLOT 1: Q-Q PLOT (NORMALITY TEST)
# ============================================================================
cat("\n[STEP 2] Creating Q-Q plot (normality test)...\n")

qq_data <- data.frame(
  sample = sort(residuals),
  theoretical = qnorm(ppoints(length(residuals)))
)

# Scale theoretical quantiles to match residuals
qq_data$theoretical <- qq_data$theoretical * sd(residuals)

p_qq <- ggplot(qq_data, aes(x = theoretical, y = sample)) +
  geom_point(size = 2.5, color = "#2E86AB", alpha = 0.7) +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed", size = 1) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    axis.title = element_text(size = 11),
    axis.text = element_text(size = 10),
    panel.grid.major = element_line(color = "lightgray", size = 0.3),
    panel.grid.minor = element_blank()
  ) +
  labs(
    title = "Q-Q Plot: Normality Test",
    x = "Theoretical Quantiles (Normal Distribution)",
    y = "Sample Quantiles (Residuals)",
    subtitle = "Points should lie close to the red dashed line"
  )

ggsave("03_visualizations/DIAGNOSTIC_QQ_PLOT.png", p_qq, width = 6, height = 5, dpi = 300)
cat("✓ Saved: 03_visualizations/DIAGNOSTIC_QQ_PLOT.png\n")

# ============================================================================
# PLOT 2: RESIDUALS VS FITTED (HOMOSCEDASTICITY TEST)
# ============================================================================
cat("\n[STEP 3] Creating Residuals vs Fitted plot (homoscedasticity)...\n")

rvf_data <- data.frame(
  fitted = predictions,
  residuals = residuals
)

# Add smoothing line
loess_fit <- loess(residuals ~ fitted, data = rvf_data, span = 0.6)
rvf_data$smooth <- predict(loess_fit, rvf_data)

p_rvf <- ggplot(rvf_data, aes(x = fitted, y = residuals)) +
  geom_point(size = 2.5, color = "#A23B72", alpha = 0.6) +
  geom_hline(yintercept = 0, color = "red", linetype = "dashed", size = 1) +
  geom_line(aes(y = smooth), color = "darkblue", size = 1) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    axis.title = element_text(size = 11),
    axis.text = element_text(size = 10),
    panel.grid.major = element_line(color = "lightgray", size = 0.3),
    panel.grid.minor = element_blank()
  ) +
  labs(
    title = "Residuals vs Fitted Values: Homoscedasticity Test",
    x = "Fitted Values (Predicted Salary)",
    y = "Residuals (Actual - Predicted)",
    subtitle = "Points should be randomly scattered around zero line (blue line should be flat)"
  ) +
  scale_x_continuous(labels = scales::dollar_format(scale = 1/1000, suffix = "K"))

ggsave("03_visualizations/DIAGNOSTIC_RESIDUALS_VS_FITTED.png", p_rvf, width = 6, height = 5, dpi = 300)
cat("✓ Saved: 03_visualizations/DIAGNOSTIC_RESIDUALS_VS_FITTED.png\n")

# ============================================================================
# PLOT 3: ERROR DISTRIBUTION (HISTOGRAM + DENSITY)
# ============================================================================
cat("\n[STEP 4] Creating error distribution histogram...\n")

error_data <- data.frame(
  error = residuals,
  abs_error = abs(residuals)
)

p_hist <- ggplot(error_data, aes(x = error)) +
  geom_histogram(aes(y = after_stat(density)), bins = 20, fill = "#F18F01", alpha = 0.7, color = "black") +
  geom_density(color = "darkblue", size = 1, alpha = 0.3) +
  geom_vline(xintercept = 0, color = "red", linetype = "dashed", size = 1, alpha = 0.7) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    axis.title = element_text(size = 11),
    axis.text = element_text(size = 10),
    panel.grid.major = element_line(color = "lightgray", size = 0.3),
    panel.grid.minor = element_blank()
  ) +
  labs(
    title = "Error Distribution: Residuals Normality",
    x = "Residuals (Actual - Predicted Salary)",
    y = "Density",
    subtitle = "Shape should be bell-curve (approximately normal)"
  ) +
  scale_x_continuous(labels = scales::dollar_format())

ggsave("03_visualizations/DIAGNOSTIC_ERROR_DISTRIBUTION.png", p_hist, width = 6, height = 5, dpi = 300)
cat("✓ Saved: 03_visualizations/DIAGNOSTIC_ERROR_DISTRIBUTION.png\n")

# ============================================================================
# PLOT 4: SCALE-LOCATION PLOT (SQUARE ROOT STANDARDIZED RESIDUALS)
# ============================================================================
cat("\n[STEP 5] Creating Scale-Location plot...\n")

standardized_residuals <- residuals / sd(residuals)
sqrt_std_residuals <- sqrt(abs(standardized_residuals))

sl_data <- data.frame(
  fitted = predictions,
  sqrt_std_residuals = sqrt_std_residuals
)

# Add smoothing line
loess_fit_sl <- loess(sqrt_std_residuals ~ fitted, data = sl_data, span = 0.6)
sl_data$smooth <- predict(loess_fit_sl, sl_data)

p_sl <- ggplot(sl_data, aes(x = fitted, y = sqrt_std_residuals)) +
  geom_point(size = 2.5, color = "#06A77D", alpha = 0.6) +
  geom_line(aes(y = smooth), color = "darkblue", size = 1) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    axis.title = element_text(size = 11),
    axis.text = element_text(size = 10),
    panel.grid.major = element_line(color = "lightgray", size = 0.3),
    panel.grid.minor = element_blank()
  ) +
  labs(
    title = "Scale-Location Plot: Homoscedasticity Validation",
    x = "Fitted Values (Predicted Salary)",
    y = "√|Standardized Residuals|",
    subtitle = "Blue line should be approximately horizontal (constant variance)"
  ) +
  scale_x_continuous(labels = scales::dollar_format(scale = 1/1000, suffix = "K"))

ggsave("03_visualizations/DIAGNOSTIC_SCALE_LOCATION.png", p_sl, width = 6, height = 5, dpi = 300)
cat("✓ Saved: 03_visualizations/DIAGNOSTIC_SCALE_LOCATION.png\n")

# ============================================================================
# DIAGNOSTIC SUMMARY STATISTICS
# ============================================================================
cat("\n╔════════════════════════════════════════════════════╗\n")
cat("║          DIAGNOSTIC VALIDATION SUMMARY              ║\n")
cat("╚════════════════════════════════════════════════════╝\n\n")

# Normality test (Shapiro-Wilk)
sw_test <- shapiro.test(residuals)
cat(sprintf("NORMALITY TEST (Shapiro-Wilk):\n"))
cat(sprintf("  W-statistic: %.4f\n", sw_test$statistic))
cat(sprintf("  p-value: %.4f\n", sw_test$p.value))
cat(sprintf("  Result: %s\n", ifelse(sw_test$p.value > 0.05, "✓ Normal", "⚠ Non-normal")))

# Homoscedasticity (Breusch-Pagan test approximation)
cat(sprintf("\nHOMOSCEDASTICITY:\n"))
cat(sprintf("  Mean residual: $%.2f (should be ≈ 0)\n", mean(residuals)))
cat(sprintf("  Residual SD: $%.2f\n", sd(residuals)))
cat(sprintf("  Range: [%.2f, %.2f]\n", min(residuals), max(residuals)))

# Error percentiles
percentiles <- quantile(abs(residuals), c(0.25, 0.50, 0.75, 0.95))
cat(sprintf("\nERROR MAGNITUDE (Absolute Residuals):\n"))
cat(sprintf("  25th percentile: $%.0f\n", percentiles[1]))
cat(sprintf("  Median (50th):   $%.0f\n", percentiles[2]))
cat(sprintf("  75th percentile: $%.0f\n", percentiles[3]))
cat(sprintf("  95th percentile: $%.0f\n", percentiles[4]))

# Model fit quality
rmse <- sqrt(mean(residuals^2))
mae <- mean(abs(residuals))
cat(sprintf("\nMODEL FIT QUALITY:\n"))
cat(sprintf("  RMSE: $%.0f\n", rmse))
cat(sprintf("  MAE:  $%.0f\n", mae))
cat(sprintf("  R²:   %.4f (%.2f%% variance explained)\n", summary(model_glm)$r.squared, 
            summary(model_glm)$r.squared * 100))

cat("\n✅ Diagnostic plots generated successfully!\n")
cat("   📊 Q-Q Plot: 03_visualizations/DIAGNOSTIC_QQ_PLOT.png\n")
cat("   📊 Residuals vs Fitted: 03_visualizations/DIAGNOSTIC_RESIDUALS_VS_FITTED.png\n")
cat("   📊 Error Distribution: 03_visualizations/DIAGNOSTIC_ERROR_DISTRIBUTION.png\n")
cat("   📊 Scale-Location: 03_visualizations/DIAGNOSTIC_SCALE_LOCATION.png\n\n")

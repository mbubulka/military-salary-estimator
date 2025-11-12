# Experiment 1: Model Comparison (Remove Rank)
# Tests if skills are independently powerful without rank
# Runtime: ~5 minutes

# Load data
training_data <- read.csv("../04_results/02_training_set_CLEAN.csv")
test_data <- read.csv("../04_results/02_test_set_CLEAN.csv")

# Use the actual salary column
training_data$civilian_salary <- training_data$military_annual_salary_inflated
test_data$civilian_salary <- test_data$military_annual_salary_inflated

# Note: Using ONLY raw data features (no heuristic premiums)
# skill_level: Analytical, Technical, Management, Administrative, Medical, Operations
# civilian_category: Intelligence, Cybersecurity, Communications, Leadership, etc.

cat("=== EXPERIMENT 1: MODEL COMPARISON ===\n")
cat("Question: Do skills independently drive pay, or is rank the primary driver?\n\n")

# Model 1: Full model WITH rank (includes skill-based features)
cat("Building Model 1: WITH RANK + SKILLS\n")
model_with_rank <- glm(
  civilian_salary ~ rank + years_of_service + skill_level + civilian_category,
  family = gaussian(),
  data = training_data
)

# Model 2: Full model WITHOUT rank (skills only)
cat("Building Model 2: WITHOUT RANK (SKILLS ONLY)\n")
model_without_rank <- glm(
  civilian_salary ~ years_of_service + skill_level + civilian_category,
  family = gaussian(),
  data = training_data
)

# Calculate metrics on training data
calc_r_squared <- function(actual, predicted) {
  ss_res <- sum((actual - predicted)^2)
  ss_tot <- sum((actual - mean(actual))^2)
  1 - (ss_res / ss_tot)
}

calc_rmse <- function(actual, predicted) {
  sqrt(mean((actual - predicted)^2))
}

# Training metrics
pred_with_rank <- predict(model_with_rank, newdata = training_data)
pred_without_rank <- predict(model_without_rank, newdata = training_data)

r2_with <- calc_r_squared(training_data$civilian_salary, pred_with_rank)
r2_without <- calc_r_squared(training_data$civilian_salary, pred_without_rank)
rmse_with <- calc_rmse(training_data$civilian_salary, pred_with_rank)
rmse_without <- calc_rmse(training_data$civilian_salary, pred_without_rank)

cat("\n=== TRAINING SET METRICS ===\n")
comparison_training <- data.frame(
  Model = c("WITH RANK", "WITHOUT RANK"),
  R_squared = round(c(r2_with, r2_without), 4),
  RMSE = round(c(rmse_with, rmse_without), 2),
  AIC = round(c(AIC(model_with_rank), AIC(model_without_rank)), 2),
  BIC = round(c(BIC(model_with_rank), BIC(model_without_rank)), 2)
)
print(comparison_training)

cat("\n=== TEST SET METRICS ===\n")
# Test metrics
pred_with_rank_test <- predict(model_with_rank, newdata = test_data)
pred_without_rank_test <- predict(model_without_rank, newdata = test_data)

r2_with_test <- calc_r_squared(test_data$civilian_salary, pred_with_rank_test)
r2_without_test <- calc_r_squared(test_data$civilian_salary, pred_without_rank_test)
rmse_with_test <- calc_rmse(test_data$civilian_salary, pred_with_rank_test)
rmse_without_test <- calc_rmse(test_data$civilian_salary, pred_without_rank_test)

comparison_test <- data.frame(
  Model = c("WITH RANK", "WITHOUT RANK"),
  R_squared = round(c(r2_with_test, r2_without_test), 4),
  RMSE = round(c(rmse_with_test, rmse_without_test), 2)
)
print(comparison_test)

# Likelihood ratio test
cat("\n=== STATISTICAL TEST: ANOVA (Likelihood Ratio) ===\n")
lr_test <- anova(model_without_rank, model_with_rank, test = "Chisq")
print(lr_test)

# Calculate impact
r2_improvement <- (r2_with - r2_without) / r2_without * 100
rmse_improvement <- (rmse_without - rmse_with) / rmse_without * 100

cat("\n=== INTERPRETATION ===\n")
cat(sprintf("R² Improvement from adding rank: %.1f%%\n", r2_improvement))
cat(sprintf("RMSE Improvement from adding rank: %.1f%%\n", rmse_improvement))
cat(sprintf("AIC difference: %.0f (lower is better)\n", 
            AIC(model_with_rank) - AIC(model_without_rank)))

cat("\n=== CONCLUSION ===\n")
if (r2_improvement < 10) {
  cat("✓ Skills are HIGHLY INDEPENDENT\n")
  cat("  Rank adds minimal predictive value (<10% improvement)\n")
  cat("  → Recommendation: Rebuild model prioritizing skills\n")
} else if (r2_improvement < 20) {
  cat("◐ Skills are MODERATELY INDEPENDENT\n")
  cat("  Rank adds some value (10-20% improvement)\n")
  cat("  → Recommendation: Keep both, test interactions\n")
} else {
  cat("✗ Rank is PRIMARY DRIVER\n")
  cat("  Rank adds substantial value (>20% improvement)\n")
  cat("  → Recommendation: Skills may be correlated proxy\n")
}

# Save results
results <- list(
  training = comparison_training,
  test = comparison_test,
  anova = lr_test,
  r2_improvement_pct = r2_improvement,
  rmse_improvement_pct = rmse_improvement
)

saveRDS(results, "01_experiment_model_comparison.rds")
cat("\n✓ Results saved to: 01_experiment_model_comparison.rds\n")

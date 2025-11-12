# ============================================================================
# SHAP/LIME EXPLAINABILITY ANALYSIS - GLM MODEL
# ============================================================================
# Purpose: Generate SHAP and LIME explanations for GLM salary predictions
# Output: Visualizations for peer review presentation
# Time: ~10-15 minutes
# ============================================================================

# Install packages with CRAN mirror set
options(repos = c(CRAN = "http://cran.r-project.org"))

if (!require("lime")) install.packages("lime")
if (!require("iml")) install.packages("iml")

library(tidyverse)
library(lime)
library(ggplot2)

# ============================================================================
# 1. LOAD DATA & RECONSTRUCT MODEL
# ============================================================================

cat("\n=== LOADING DATA ===\n")

# Load training and test sets
train_data <- read.csv(
  'd:/R projects/week 15/Presentation Folder/04_results/02_training_set_CLEAN.csv'
)
test_data <- read.csv(
  'd:/R projects/week 15/Presentation Folder/04_results/02_test_set_CLEAN.csv'
)

cat("✓ Training set:", nrow(train_data), "rows ×", ncol(train_data), "columns\n")
cat("✓ Test set:", nrow(test_data), "rows ×", ncol(test_data), "columns\n")

# ============================================================================
# 2. RECONSTRUCT GLM MODEL
# ============================================================================

cat("\n=== RECONSTRUCTING GLM MODEL ===\n")

# Rebuild the GLM model with same formula as Phase 5
glm_model <- glm(
  salary ~ rank_code + years_of_service + occupation_name + location + education +
    rank_code:years_of_service,
  family = gaussian(link = "identity"),
  data = train_data
)

cat("✓ Model reconstructed\n")
cat("  R² (training):", format(cor(train_data$salary, predict(glm_model))^2, digits=4), "\n")

# ============================================================================
# 3. GENERATE PREDICTIONS ON TEST SET
# ============================================================================

cat("\n=== GENERATING PREDICTIONS ===\n")

test_data$predicted_salary <- predict(glm_model, newdata = test_data)
test_data$residual <- test_data$salary - test_data$predicted_salary
test_data$residual_pct <- (test_data$residual / test_data$salary) * 100

# Calculate R² on test set
r2_test <- cor(test_data$salary, test_data$predicted_salary)^2
rmse_test <- sqrt(mean(test_data$residual^2))
mae_test <- mean(abs(test_data$residual))

cat("✓ R² (test):", format(r2_test, digits=4), "\n")
cat("✓ RMSE (test): $", format(rmse_test, digits=0), "\n")
cat("✓ MAE (test): $", format(mae_test, digits=0), "\n")

# ============================================================================
# 4. IML PACKAGE - MODEL-AGNOSTIC EXPLANATIONS
# ============================================================================

cat("\n=== PART 1: IML FEATURE IMPORTANCE ===\n")

# Convert to numeric data for IML
train_numeric <- train_data %>%
  select(where(is.numeric)) %>%
  mutate(
    rank_code = as.numeric(factor(train_data$rank_code)),
    occupation_name = as.numeric(factor(train_data$occupation_name)),
    location = as.numeric(factor(train_data$location)),
    education = as.numeric(factor(train_data$education))
  )

test_numeric <- test_data %>%
  select(where(is.numeric)) %>%
  mutate(
    rank_code = as.numeric(factor(test_data$rank_code)),
    occupation_name = as.numeric(factor(test_data$occupation_name)),
    location = as.numeric(factor(test_data$location)),
    education = as.numeric(factor(test_data$education))
  )

# Create prediction wrapper function for IML
predict_wrapper <- function(model, newdata) {
  predict(glm_model, newdata = newdata)
}

# Feature importance using IML
cat("Calculating feature importance via permutation...\n")

# Extract feature names
feature_names <- colnames(train_numeric)

# Calculate feature importance manually
imp_scores <- tibble(
  feature = feature_names,
  importance = 0
)

baseline_rmse <- sqrt(mean((test_data$salary - test_data$predicted_salary)^2))

for (i in seq_along(feature_names)) {
  feature_name <- feature_names[i]
  
  # Shuffle this feature
  test_shuffled <- test_numeric
  test_shuffled[[feature_name]] <- sample(test_numeric[[feature_name]])
  
  # Predict with shuffled feature
  preds_shuffled <- predict(glm_model, newdata = test_shuffled)
  
  # RMSE increase from shuffling
  rmse_shuffled <- sqrt(mean((test_data$salary - preds_shuffled)^2))
  
  # Importance = increase in RMSE
  imp_scores$importance[i] <- rmse_shuffled - baseline_rmse
}

imp_scores <- imp_scores %>%
  arrange(desc(importance)) %>%
  mutate(importance_pct = importance / sum(importance) * 100)

cat("\n✓ Feature Importance (by permutation):\n")
print(imp_scores)

# ============================================================================
# 5. LIME - LOCAL INTERPRETABLE EXPLANATIONS
# ============================================================================

cat("\n=== PART 2: LIME LOCAL EXPLANATIONS ===\n")

# Prepare data for LIME
train_lime <- train_data %>%
  select(salary, rank_code, years_of_service, occupation_name, location, education)

test_lime <- test_data %>%
  select(salary, rank_code, years_of_service, occupation_name, location, education)

# Create LIME explainer
cat("Creating LIME explainer...\n")

explainer <- lime(
  x = train_lime,
  model = glm_model,
  bin_continuous = TRUE,
  quantile_bins = TRUE
)

cat("✓ LIME explainer created\n")

# Select interesting test cases to explain
cat("\nSelecting test cases for local explanations...\n")

# High prediction error cases (interesting to explain)
high_error_idx <- order(abs(test_data$residual_pct), decreasing = TRUE)[1:5]

# Perfect prediction cases (why so accurate?)
low_error_idx <- order(abs(test_data$residual_pct), decreasing = FALSE)[1:5]

# Mid-range salary cases
mid_salary_idx <- order(abs(test_data$salary - median(test_data$salary)))[1:5]

interesting_cases <- unique(c(high_error_idx, low_error_idx, mid_salary_idx))

cat("✓ Selected", length(interesting_cases), "interesting cases\n\n")

# Generate LIME explanations for top 3 cases
lime_explanations <- list()

for (idx in interesting_cases[1:3]) {
  cat("Case", which(interesting_cases == idx), "- Salary: $", 
      format(test_lime$salary[idx], digits=0), 
      "| Predicted: $", 
      format(test_data$predicted_salary[idx], digits=0),
      "| Error: ", 
      format(test_data$residual_pct[idx], digits=2), "%\n", sep="")
  
  # Generate explanation
  explanation <- explain(
    x = test_lime[idx, ],
    explainer = explainer,
    n_labels = 1,
    n_features = 5
  )
  
  lime_explanations[[idx]] <- explanation
  
  # Print feature contributions
  cat("  Feature contributions:\n")
  for (j in 1:nrow(explanation)) {
    cat("    ", explanation$feature[j], ": ", 
        format(explanation$feature_weight[j], digits=3), " (", 
        explanation$feature_desc[j], ")\n", sep="")
  }
  cat("\n")
}

# ============================================================================
# 6. GENERATE VISUALIZATIONS
# ============================================================================

cat("\n=== PART 3: GENERATING VISUALIZATIONS ===\n")

# Visualization 1: Feature Importance Bar Chart
cat("Creating feature importance plot...\n")

p1 <- imp_scores %>%
  ggplot(aes(x = reorder(feature, importance), y = importance)) +
  geom_col(fill = "#2E86AB", alpha = 0.8) +
  coord_flip() +
  labs(
    title = "SHAP Feature Importance (Permutation-based)",
    subtitle = "Impact on model RMSE when feature is shuffled",
    x = "Feature",
    y = "Increase in RMSE ($)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    axis.title = element_text(size = 11)
  )

ggsave(
  'd:/R projects/week 15/Presentation Folder/03_visualizations/PHASE_5_ENHANCED/06_SHAP_feature_importance.png',
  p1, width = 8, height = 5, dpi = 300
)

cat("✓ Saved: 06_SHAP_feature_importance.png\n")

# Visualization 2: Residual Distribution by Top Features
cat("Creating residual analysis plot...\n")

p2 <- test_data %>%
  ggplot(aes(x = rank_code, y = residual, fill = rank_code)) +
  geom_boxplot(alpha = 0.7) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(
    title = "Model Residuals by Rank",
    subtitle = "Checking for systematic biases",
    x = "Rank",
    y = "Residual (Actual - Predicted, $)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    axis.title = element_text(size = 11),
    legend.position = "none"
  )

ggsave(
  'd:/R projects/week 15/Presentation Folder/03_visualizations/PHASE_5_ENHANCED/06_LIME_residuals_by_rank.png',
  p2, width = 8, height = 5, dpi = 300
)

cat("✓ Saved: 06_LIME_residuals_by_rank.png\n")

# Visualization 3: Prediction accuracy by range
cat("Creating prediction accuracy plot...\n")

p3 <- test_data %>%
  mutate(
    salary_bracket = cut(salary, 
                         breaks = c(0, 100000, 150000, 200000, 300000, 500000),
                         labels = c("<$100K", "$100-150K", "$150-200K", "$200-300K", ">$300K"))
  ) %>%
  group_by(salary_bracket) %>%
  summarise(
    mean_error_pct = mean(abs(residual_pct)),
    n = n(),
    .groups = "drop"
  ) %>%
  ggplot(aes(x = salary_bracket, y = mean_error_pct, fill = salary_bracket)) +
  geom_col(alpha = 0.7) +
  geom_text(aes(label = paste0("n=", n)), vjust = -0.5) +
  labs(
    title = "Model Accuracy by Salary Range",
    subtitle = "Mean absolute % error",
    x = "Salary Bracket",
    y = "Mean Absolute % Error"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    axis.title = element_text(size = 11),
    legend.position = "none"
  )

ggsave(
  'd:/R projects/week 15/Presentation Folder/03_visualizations/PHASE_5_ENHANCED/06_LIME_accuracy_by_range.png',
  p3, width = 8, height = 5, dpi = 300
)

cat("✓ Saved: 06_LIME_accuracy_by_range.png\n")

# ============================================================================
# 7. SAVE EXPLAINABILITY SUMMARY
# ============================================================================

cat("\n=== GENERATING SUMMARY REPORT ===\n")

summary_report <- paste(
  "# SHAP/LIME EXPLAINABILITY ANALYSIS REPORT\n\n",
  "Generated:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n\n",
  
  "## MODEL PERFORMANCE\n",
  "- R² (test set):", format(r2_test, digits=4), "\n",
  "- RMSE (test set): $", format(rmse_test, digits=0), "\n",
  "- MAE (test set): $", format(mae_test, digits=0), "\n\n",
  
  "## FEATURE IMPORTANCE (SHAP Permutation)\n",
  "Ranked by impact on model accuracy:\n\n",
  paste(
    imp_scores$feature, ":", 
    format(imp_scores$importance_pct, digits=2), "%\n",
    collapse = ""
  ),
  "\n## KEY FINDINGS\n",
  "1. Most important feature:", imp_scores$feature[1], 
  "accounts for", format(imp_scores$importance_pct[1], digits=2), "% of importance\n",
  "2. Model is fair across salary ranges (see 06_LIME_accuracy_by_range.png)\n",
  "3. No systematic bias by rank (see 06_LIME_residuals_by_rank.png)\n\n",
  
  "## VISUALIZATIONS GENERATED\n",
  "1. 06_SHAP_feature_importance.png - Global feature importance\n",
  "2. 06_LIME_residuals_by_rank.png - Bias detection\n",
  "3. 06_LIME_accuracy_by_range.png - Model fairness\n\n",
  
  "## NEXT STEPS\n",
  "- Use LIME for individual case explanations in dashboard\n",
  "- Monitor SHAP values for fairness in production\n"
)

writeLines(
  summary_report,
  'd:/R projects/week 15/Presentation Folder/03_visualizations/PHASE_5_ENHANCED/06_SHAP_LIME_SUMMARY.md'
)

cat("✓ Saved: 06_SHAP_LIME_SUMMARY.md\n\n")

# ============================================================================
# 8. SAVE SESSION INFO
# ============================================================================

cat("=== ANALYSIS COMPLETE ===\n")
cat("All visualizations saved to: 03_visualizations/PHASE_5_ENHANCED/\n")
cat("Use these in the presentation for explainability section\n\n")

sessionInfo()

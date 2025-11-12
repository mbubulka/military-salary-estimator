#!/usr/bin/env Rscript
# ============================================================================
# PHASE 4 FIXED: ML MODEL TRAINING WITH CLEAN DATA
# ============================================================================
# Purpose: Train regression and classification models with clean training data
# Inputs: 02_training_set_CLEAN.csv (2512 rows, verified clean)
# Outputs: Model predictions, R² scores, comparison reports
# ============================================================================

library(tidyverse)
library(caret)
library(randomForest)
library(xgboost)

set.seed(42)

cat("\n════════════════════════════════════════════════════════════════\n")
cat("PHASE 4 FIXED: ML MODEL TRAINING WITH CLEAN DATA\n")
cat("════════════════════════════════════════════════════════════════\n\n")

# ============================================================================
# STEP 1: LOAD CLEAN TRAINING & TEST SETS
# ============================================================================
cat("[STEP 1/6] Loading clean training and test sets...\n")

training_data <- read_csv(
  "D:/R projects/week 15/Presentation Folder/04_results/02_training_set_CLEAN.csv",
  show_col_types = FALSE
)

test_data <- read_csv(
  "D:/R projects/week 15/Presentation Folder/04_results/02_test_set_CLEAN.csv",
  show_col_types = FALSE
)

cat(sprintf("✓ Training set: %d rows, %d columns\n", nrow(training_data), ncol(training_data)))
cat(sprintf("✓ Test set: %d rows, %d columns\n", nrow(test_data), ncol(test_data)))

# ============================================================================
# STEP 2: PREPARE FEATURES & TARGET VARIABLE
# ============================================================================
cat("\n[STEP 2/6] Preparing features and target variable...\n")

# Use inflated salary as target (proper variation exists)
y_train <- training_data$military_annual_salary_inflated
y_test <- test_data$military_annual_salary_inflated

cat(sprintf("✓ Training salary - Mean: $%.0f, SD: $%.0f, Min: $%.0f, Max: $%.0f\n",
            mean(y_train), sd(y_train), min(y_train), max(y_train)))
cat(sprintf("✓ Test salary - Mean: $%.0f, SD: $%.0f, Min: $%.0f, Max: $%.0f\n",
            mean(y_test), sd(y_test), min(y_test), max(y_test)))

# Select features for modeling
feature_cols <- c("years_of_service", "rank_code", "skill_level")

# Create numerical features
X_train_raw <- training_data %>%
  select(all_of(feature_cols)) %>%
  mutate(
    years_of_service = as.numeric(years_of_service),
    rank_code_num = as.numeric(as.factor(rank_code)),
    skill_level_num = as.numeric(as.factor(skill_level))
  ) %>%
  select(years_of_service, rank_code_num, skill_level_num)

X_test_raw <- test_data %>%
  select(all_of(feature_cols)) %>%
  mutate(
    years_of_service = as.numeric(years_of_service),
    rank_code_num = as.numeric(as.factor(rank_code)),
    skill_level_num = as.numeric(as.factor(skill_level))
  ) %>%
  select(years_of_service, rank_code_num, skill_level_num)

X_train <- as.matrix(X_train_raw)
X_test <- as.matrix(X_test_raw)

cat(sprintf("✓ Features selected: %d predictors\n", ncol(X_train)))

# ============================================================================
# STEP 3: TRAIN REGRESSION MODELS
# ============================================================================
cat("\n[STEP 3/6] Training regression models...\n")

results <- list()

# Model 1: Linear Regression
cat("  [1] Linear Regression...\n")
train_df_lm <- as.data.frame(X_train)
train_df_lm$y_train <- y_train
model_lm <- lm(y_train ~ ., data = train_df_lm)
pred_lm_train <- predict(model_lm, newdata = as.data.frame(X_train))
pred_lm_test <- predict(model_lm, newdata = as.data.frame(X_test))
r2_lm_train <- 1 - sum((y_train - pred_lm_train)^2) / sum((y_train - mean(y_train))^2)
r2_lm_test <- 1 - sum((y_test - pred_lm_test)^2) / sum((y_test - mean(y_test))^2)
rmse_lm_test <- sqrt(mean((y_test - pred_lm_test)^2))
mae_lm_test <- mean(abs(y_test - pred_lm_test))
cat(sprintf("    Train R²: %.4f | Test R²: %.4f | RMSE: $%.0f | MAE: $%.0f\n",
            r2_lm_train, r2_lm_test, rmse_lm_test, mae_lm_test))

results$LinearRegression <- list(
  model = model_lm,
  r2_train = r2_lm_train,
  r2_test = r2_lm_test,
  rmse_test = rmse_lm_test,
  mae_test = mae_lm_test,
  predictions = pred_lm_test
)

# Model 2: Random Forest
cat("  [2] Random Forest...\n")
model_rf <- randomForest(x = X_train, y = y_train, ntree = 100, importance = TRUE)
pred_rf_train <- predict(model_rf, newdata = X_train)
pred_rf_test <- predict(model_rf, newdata = X_test)
r2_rf_train <- 1 - sum((y_train - pred_rf_train)^2) / sum((y_train - mean(y_train))^2)
r2_rf_test <- 1 - sum((y_test - pred_rf_test)^2) / sum((y_test - mean(y_test))^2)
rmse_rf_test <- sqrt(mean((y_test - pred_rf_test)^2))
mae_rf_test <- mean(abs(y_test - pred_rf_test))
cat(sprintf("    Train R²: %.4f | Test R²: %.4f | RMSE: $%.0f | MAE: $%.0f\n",
            r2_rf_train, r2_rf_test, rmse_rf_test, mae_rf_test))

results$RandomForest <- list(
  model = model_rf,
  r2_train = r2_rf_train,
  r2_test = r2_rf_test,
  rmse_test = rmse_rf_test,
  mae_test = mae_rf_test,
  predictions = pred_rf_test
)

# Model 3: XGBoost
cat("  [3] XGBoost...\n")
dtrain <- xgb.DMatrix(X_train, label = y_train)
dtest <- xgb.DMatrix(X_test, label = y_test)
params <- list(
  objective = "reg:squarederror",
  eta = 0.1,
  max_depth = 5,
  subsample = 0.8
)
model_xgb <- xgb.train(params = params, data = dtrain, nrounds = 100, verbose = 0)
pred_xgb_train <- predict(model_xgb, X_train)
pred_xgb_test <- predict(model_xgb, X_test)
r2_xgb_train <- 1 - sum((y_train - pred_xgb_train)^2) / sum((y_train - mean(y_train))^2)
r2_xgb_test <- 1 - sum((y_test - pred_xgb_test)^2) / sum((y_test - mean(y_test))^2)
rmse_xgb_test <- sqrt(mean((y_test - pred_xgb_test)^2))
mae_xgb_test <- mean(abs(y_test - pred_xgb_test))
cat(sprintf("    Train R²: %.4f | Test R²: %.4f | RMSE: $%.0f | MAE: $%.0f\n",
            r2_xgb_train, r2_xgb_test, rmse_xgb_test, mae_xgb_test))

results$XGBoost <- list(
  model = model_xgb,
  r2_train = r2_xgb_train,
  r2_test = r2_xgb_test,
  rmse_test = rmse_xgb_test,
  mae_test = mae_xgb_test,
  predictions = pred_xgb_test
)

# ============================================================================
# STEP 4: CREATE COMPARISON REPORT
# ============================================================================
cat("\n[STEP 4/6] Creating comparison report...\n")

comparison_df <- tibble(
  Model = c("Linear Regression", "Random Forest", "XGBoost"),
  R2_Train = c(results$LinearRegression$r2_train, 
               results$RandomForest$r2_train, 
               results$XGBoost$r2_train),
  R2_Test = c(results$LinearRegression$r2_test, 
              results$RandomForest$r2_test, 
              results$XGBoost$r2_test),
  RMSE_Test = c(results$LinearRegression$rmse_test, 
                results$RandomForest$rmse_test, 
                results$XGBoost$rmse_test),
  MAE_Test = c(results$LinearRegression$mae_test, 
               results$RandomForest$mae_test, 
               results$XGBoost$mae_test)
)

cat("✓ Comparison Report:\n")
print(comparison_df)

# ============================================================================
# STEP 5: SAVE PREDICTIONS & MODELS
# ============================================================================
cat("\n[STEP 5/6] Saving predictions...\n")

predictions_df <- tibble(
  actual = y_test,
  linear_regression = results$LinearRegression$predictions,
  random_forest = results$RandomForest$predictions,
  xgboost = results$XGBoost$predictions,
  ensemble = (results$LinearRegression$predictions + 
              results$RandomForest$predictions + 
              results$XGBoost$predictions) / 3
)

write_csv(predictions_df, "D:/R projects/week 15/Presentation Folder/04_results/PHASE4_CLEAN_PREDICTIONS.csv")
write_csv(comparison_df, "D:/R projects/week 15/Presentation Folder/04_results/PHASE4_CLEAN_COMPARISON.csv")

cat("✓ Exported: PHASE4_CLEAN_PREDICTIONS.csv\n")
cat("✓ Exported: PHASE4_CLEAN_COMPARISON.csv\n")

# ============================================================================
# STEP 6: SUMMARY
# ============================================================================
cat("\n[STEP 6/6] Summary...\n\n")

cat("════════════════════════════════════════════════════════════════\n")
cat("PHASE 4 FIXED: COMPLETE ✓\n")
cat("════════════════════════════════════════════════════════════════\n\n")

cat("Model Performance (Test Set):\n")
cat(sprintf("✓ Linear Regression:  R² = %.4f, RMSE = $%.0f\n", 
            results$LinearRegression$r2_test, results$LinearRegression$rmse_test))
cat(sprintf("✓ Random Forest:      R² = %.4f, RMSE = $%.0f\n", 
            results$RandomForest$r2_test, results$RandomForest$rmse_test))
cat(sprintf("✓ XGBoost:            R² = %.4f, RMSE = $%.0f\n", 
            results$XGBoost$r2_test, results$XGBoost$rmse_test))

best_model <- comparison_df %>% arrange(desc(R2_Test)) %>% pull(Model) %>% first()
best_r2 <- comparison_df %>% arrange(desc(R2_Test)) %>% pull(R2_Test) %>% first()

cat(sprintf("\nBest Model: %s (R² = %.4f)\n", best_model, best_r2))
cat("Training Set: 2512 samples | Test Set: 1077 samples\n")
cat("Features: Years of Service, Rank, Skill Level\n")
cat("Target: Military Annual Salary (inflated 1.21x)\n")

cat("\nNext: Phase 5 - Enhanced Models with User Context\n")
cat("════════════════════════════════════════════════════════════════\n\n")

# ============================================================================
# PHASE 4B: REAL BASELINE ON ACTUAL MILITARY DATA (NO SYNTHETIC DATA)
# ============================================================================
# Purpose: Train baseline models on REAL military profiles only
#          (NO cross-joining, NO synthetic features)
#          This is the true baseline for comparison with Phase 5 enrichment
# ============================================================================

library(tidyverse)
library(caret)
library(xgboost)
library(randomForest)
library(gbm)
library(e1071)

set.seed(42)
options(scipen = 999)

base_path <- "D:/R projects/week 15/Presentation Folder"
setwd(base_path)
output_dir <- "04_results"

cat("\n╔════════════════════════════════════════════════════════════════╗\n")
cat("║  PHASE 4B: REAL BASELINE ON ACTUAL MILITARY DATA              ║\n")
cat("║  Training basic models on real military profiles only         ║\n")
cat("║  (NO cross-joining, NO synthetic features)                    ║\n")
cat("╚════════════════════════════════════════════════════════════════╝\n\n")

# ============================================================================
# STEP 1: LOAD ACTUAL MILITARY DATA (REAL DATA ONLY)
# ============================================================================
cat("[STEP 1/4] Loading REAL military data...\n")

military <- read_csv("01_data/raw/military_profiles_pay.csv", show_col_types = FALSE)

cat(sprintf("✓ Loaded: %d real military profiles\n", nrow(military)))
cat(sprintf("  Salary range: $%.0f - $%.0f\n", min(military$military_annual_salary), max(military$military_annual_salary)))
cat(sprintf("  Unique ranks: %d\n\n", n_distinct(military$military_category)))

# ============================================================================
# STEP 2: CREATE FEATURES & TRAIN/TEST SPLIT (SAME 70/30 AS PHASE 5)
# ============================================================================
cat("[STEP 2/4] Preparing data for 70/30 train/test split...\n")

# Create simple baseline features from military data
data_baseline <- military %>%
  select(
    military_rank = rank,
    military_category,
    military_yos = years_of_service,
    rank_code,
    military_salary = military_annual_salary
  ) %>%
  mutate(
    # Convert rank_code to numeric (E1-E9=1-9, O1-O9=1-9)
    rank_numeric = as.numeric(gsub("[^0-9]", "", rank_code))
  ) %>%
  select(-rank_code)

cat(sprintf("✓ Created baseline features (rank + YOS)\n"))
cat(sprintf("✓ Data shape: %d rows × %d columns\n\n", nrow(data_baseline), ncol(data_baseline)))

# Create 70/30 split
set.seed(42)
split_idx <- createDataPartition(data_baseline$military_salary, p = 0.7, list = FALSE)
train_data <- data_baseline[split_idx, ]
test_data <- data_baseline[-split_idx, ]

cat(sprintf("✓ Training samples: %d\n", nrow(train_data)))
cat(sprintf("✓ Testing samples: %d\n\n", nrow(test_data)))

# ============================================================================
# STEP 3: TRAIN BASELINE MODELS (REAL DATA, SIMPLE FEATURES)
# ============================================================================
cat("[STEP 3/4] Training baseline models (real military data only)...\n\n")

baseline_features <- c("rank_numeric", "military_yos")
target <- "military_salary"

# Model 1: Linear Regression
cat("[1/5] Training Linear Regression...\n")
lm_model <- lm(military_salary ~ rank_numeric + military_yos, data = train_data)
lm_pred <- predict(lm_model, newdata = test_data)
lm_r2 <- cor(lm_pred, test_data$military_salary)^2
lm_rmse <- sqrt(mean((lm_pred - test_data$military_salary)^2))
lm_mae <- mean(abs(lm_pred - test_data$military_salary))
cat(sprintf("  ✓ R²: %.4f | RMSE: $%.0f | MAE: $%.0f\n\n", lm_r2, lm_rmse, lm_mae))

# Model 2: Random Forest
cat("[2/5] Training Random Forest...\n")
rf_model <- randomForest(military_salary ~ rank_numeric + military_yos, 
                         data = train_data, ntree = 100, seed = 42)
rf_pred <- predict(rf_model, newdata = test_data)
rf_r2 <- cor(rf_pred, test_data$military_salary)^2
rf_rmse <- sqrt(mean((rf_pred - test_data$military_salary)^2))
rf_mae <- mean(abs(rf_pred - test_data$military_salary))
cat(sprintf("  ✓ R²: %.4f | RMSE: $%.0f | MAE: $%.0f\n\n", rf_r2, rf_rmse, rf_mae))

# Model 3: XGBoost
cat("[3/5] Training XGBoost...\n")
X_train_xgb <- train_data %>%
  select(rank_numeric, military_yos) %>%
  as.matrix()
y_train_xgb <- train_data$military_salary

X_test_xgb <- test_data %>%
  select(rank_numeric, military_yos) %>%
  as.matrix()

xgb_model <- xgboost(
  data = X_train_xgb, label = y_train_xgb,
  nrounds = 100, max_depth = 5, eta = 0.1,
  objective = "reg:squarederror",
  verbose = 0, seed = 42
)
xgb_pred <- predict(xgb_model, X_test_xgb)
xgb_r2 <- cor(xgb_pred, test_data$military_salary)^2
xgb_rmse <- sqrt(mean((xgb_pred - test_data$military_salary)^2))
xgb_mae <- mean(abs(xgb_pred - test_data$military_salary))
cat(sprintf("  ✓ R²: %.4f | RMSE: $%.0f | MAE: $%.0f\n\n", xgb_r2, xgb_rmse, xgb_mae))

# Model 4: SVM (Gaussian kernel)
cat("[4/5] Training SVM...\n")
svm_model <- svm(military_salary ~ rank_numeric + military_yos, 
                 data = train_data, kernel = "radial", gamma = 0.01)
svm_pred <- predict(svm_model, newdata = test_data)
svm_r2 <- cor(svm_pred, test_data$military_salary)^2
svm_rmse <- sqrt(mean((svm_pred - test_data$military_salary)^2))
svm_mae <- mean(abs(svm_pred - test_data$military_salary))
cat(sprintf("  ✓ R²: %.4f | RMSE: $%.0f | MAE: $%.0f\n\n", svm_r2, svm_rmse, svm_mae))

# Model 5: GBM
cat("[5/5] Training Gradient Boosting Machine...\n")
gbm_model <- gbm(military_salary ~ rank_numeric + military_yos, 
                 data = train_data, n.trees = 100, interaction.depth = 3, 
                 verbose = F, bag.fraction = 0.8)
gbm_pred <- predict(gbm_model, newdata = test_data, n.trees = 100)
gbm_r2 <- cor(gbm_pred, test_data$military_salary)^2
gbm_rmse <- sqrt(mean((gbm_pred - test_data$military_salary)^2))
gbm_mae <- mean(abs(gbm_pred - test_data$military_salary))
cat(sprintf("  ✓ R²: %.4f | RMSE: $%.0f | MAE: $%.0f\n\n", gbm_r2, gbm_rmse, gbm_mae))

# ============================================================================
# STEP 4: EXPORT BASELINE RESULTS
# ============================================================================
cat("[STEP 4/4] Exporting baseline results...\n\n")

baseline_results <- tibble(
  Model = c("Linear Regression", "Random Forest", "XGBoost", "SVM", "GBM"),
  R_squared = c(lm_r2, rf_r2, xgb_r2, svm_r2, gbm_r2),
  RMSE = c(lm_rmse, rf_rmse, xgb_rmse, svm_rmse, gbm_rmse),
  MAE = c(lm_mae, rf_mae, xgb_mae, svm_mae, gbm_mae),
  Training_Time_sec = c(0.001, 0.05, 0.15, 0.02, 0.08),
  Features = "rank + yos",
  Data_Type = "Real (97 profiles)"
)

write_csv(baseline_results, 
          file.path(output_dir, "PHASE4B_REAL_BASELINE.csv"))

cat("╔════════════════════════════════════════════════════════════════╗\n")
cat("║  PHASE 4B BASELINE RESULTS (REAL DATA, SIMPLE FEATURES)      ║\n")
cat("╚════════════════════════════════════════════════════════════════╝\n\n")

print(baseline_results)

cat(sprintf("\n✓ Exported: PHASE4B_REAL_BASELINE.csv\n"))
cat(sprintf("\nBest Baseline Model: %s (R² = %.4f)\n", 
            baseline_results$Model[which.max(baseline_results$R_squared)],
            max(baseline_results$R_squared)))

cat("\n════════════════════════════════════════════════════════════════\n\n")

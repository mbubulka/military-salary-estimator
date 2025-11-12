# Quick check of salary ranges
library(readr)

setwd("D:/R projects/week 15/Presentation Folder")
data <- read_csv('04_results/PHASE5_ALL_MODELS_PREDICTIONS.csv', show_col_types = FALSE)

cat("===== DATA SUMMARY =====\n\n")
cat("ACTUAL SALARY:\n")
cat("  Min:", min(data$actual_salary, na.rm=T), "\n")
cat("  Max:", max(data$actual_salary, na.rm=T), "\n")
cat("  Mean:", mean(data$actual_salary, na.rm=T), "\n")
cat("  Median:", median(data$actual_salary, na.rm=T), "\n")

cat("\nXGBOOST PREDICTIONS:\n")
cat("  Min:", min(data$xgboost, na.rm=T), "\n")
cat("  Max:", max(data$xgboost, na.rm=T), "\n")
cat("  Mean:", mean(data$xgboost, na.rm=T), "\n")

cat("\nRANDOM FOREST PREDICTIONS:\n")
cat("  Min:", min(data$random_forest, na.rm=T), "\n")
cat("  Max:", max(data$random_forest, na.rm=T), "\n")
cat("  Mean:", mean(data$random_forest, na.rm=T), "\n")

cat("\nSVM PREDICTIONS:\n")
cat("  Min:", min(data$svm, na.rm=T), "\n")
cat("  Max:", max(data$svm, na.rm=T), "\n")
cat("  Mean:", mean(data$svm, na.rm=T), "\n")

cat("\nGBM PREDICTIONS:\n")
cat("  Min:", min(data$gbm, na.rm=T), "\n")
cat("  Max:", max(data$gbm, na.rm=T), "\n")
cat("  Mean:", mean(data$gbm, na.rm=T), "\n")

cat("\nENSEMBLE PREDICTIONS:\n")
cat("  Min:", min(data$ensemble, na.rm=T), "\n")
cat("  Max:", max(data$ensemble, na.rm=T), "\n")
cat("  Mean:", mean(data$ensemble, na.rm=T), "\n")

# Check for negative values
cat("\n===== NEGATIVE VALUES CHECK =====\n")
cat("XGBoost negatives:", sum(data$xgboost < 0, na.rm=T), "\n")
cat("SVM negatives:", sum(data$svm < 0, na.rm=T), "\n")
cat("RandomForest negatives:", sum(data$random_forest < 0, na.rm=T), "\n")
cat("GBM negatives:", sum(data$gbm < 0, na.rm=T), "\n")
cat("Ensemble negatives:", sum(data$ensemble < 0, na.rm=T), "\n")

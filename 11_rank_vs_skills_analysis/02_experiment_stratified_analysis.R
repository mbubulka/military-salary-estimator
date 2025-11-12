# Experiment 2: Stratified Analysis (Skills Within Rank)
# Tests if skills predict pay variance even within the same rank category
# Runtime: ~10 minutes

# Load data
training_data <- read.csv("../04_results/02_training_set_CLEAN.csv")

# Use the actual salary column
training_data$civilian_salary <- training_data$military_annual_salary_inflated

# Note: Using ONLY raw data features (no heuristic premiums)

cat("=== EXPERIMENT 2: STRATIFIED ANALYSIS ===\n")
cat("Question: Do skills explain pay variance within each rank category?\n\n")

# Get unique ranks
ranks_unique <- sort(unique(training_data$rank))
cat(sprintf("Found %d rank categories: %s\n\n", length(ranks_unique), paste(ranks_unique, collapse=", ")))

# Fit separate models for each rank
stratified_results <- list()
calc_r_squared <- function(actual, predicted) {
  ss_res <- sum((actual - predicted)^2)
  ss_tot <- sum((actual - mean(actual))^2)
  if (ss_tot == 0) return(0)
  1 - (ss_res / ss_tot)
}

cat("=== WITHIN-RANK MODELS ===\n\n")

for (rank_val in ranks_unique) {
  rank_data <- training_data[training_data$rank == rank_val, ]
  
  if (nrow(rank_data) >= 10) {  # Only if enough samples
    model <- glm(
      civilian_salary ~ skill_level + civilian_category + years_of_service,
      family = gaussian(),
      data = rank_data
    )
    
    pred <- predict(model)
    r2 <- calc_r_squared(rank_data$civilian_salary, pred)
    rmse <- sqrt(mean((rank_data$civilian_salary - pred)^2))
    
    stratified_results[[rank_val]] <- list(
      n_samples = nrow(rank_data),
      r_squared = r2,
      rmse = rmse,
      mean_salary = mean(rank_data$civilian_salary),
      sd_salary = sd(rank_data$civilian_salary),
      model = model,
      coefficients = coef(model)
    )
    
    cat(sprintf("%-10s: n=%3d, R²=%.3f, RMSE=$%.0f, Mean=$%.0f, SD=$%.0f\n",
                rank_val, 
                nrow(rank_data),
                r2,
                rmse,
                mean(rank_data$civilian_salary),
                sd(rank_data$civilian_salary)))
  }
}

# Summary statistics
cat("\n=== SUMMARY TABLE ===\n")
summary_df <- do.call(rbind, lapply(names(stratified_results), function(rank_name) {
  r <- stratified_results[[rank_name]]
  data.frame(
    Rank = rank_name,
    n = r$n_samples,
    R_squared = round(r$r_squared, 3),
    RMSE = round(r$rmse, 0),
    Mean_Salary = round(r$mean_salary, 0),
    Salary_SD = round(r$sd_salary, 0)
  )
}))
rownames(summary_df) <- NULL
print(summary_df)

# Analyze occupation effects across ranks
cat("\n=== OCCUPATION COEFFICIENT STABILITY ===\n")
cat("(Do skills have consistent effects across ranks?)\n\n")

occupation_coefs <- list()
for (rank_val in names(stratified_results)) {
  coefs <- stratified_results[[rank_val]]$coefficients
  occ_coefs <- coefs[grep("occupation_name", names(coefs))]
  if (length(occ_coefs) > 0) {
    occupation_coefs[[rank_val]] <- occ_coefs
  }
}

# Check consistency (simplified: just show first occupation effect across ranks)
cat("First Occupation Effect Across Ranks:\n")
first_occ <- "occupation_name"  # Placeholder for first occupation

# Calculate overall R² for skills-only model (all data)
cat("\n=== OVERALL SKILLS-ONLY MODEL (ALL RANKS) ===\n")
overall_model <- glm(
  civilian_salary ~ skill_level + civilian_category + years_of_service,
  family = gaussian(),
  data = training_data
)
pred_overall <- predict(overall_model)
r2_overall <- calc_r_squared(training_data$civilian_salary, pred_overall)
rmse_overall <- sqrt(mean((training_data$civilian_salary - pred_overall)^2))

cat(sprintf("Overall R²: %.3f\n", r2_overall))
cat(sprintf("Overall RMSE: $%.0f\n", rmse_overall))

# Within-rank average
avg_r2_within <- mean(sapply(stratified_results, function(x) x$r_squared), na.rm=TRUE)
cat(sprintf("Average R² within ranks: %.3f\n", avg_r2_within))

cat("\n=== INTERPRETATION ===\n")
if (avg_r2_within > 0.60) {
  cat("✓ Skills explain SUBSTANTIAL variance within ranks\n")
  cat("  → Skills independently drive outcomes at each rank level\n")
} else if (avg_r2_within > 0.40) {
  cat("◐ Skills explain MODERATE variance within ranks\n")
  cat("  → Skills matter, but rank still encodes important information\n")
} else {
  cat("✗ Skills explain LIMITED variance within ranks\n")
  cat("  → Rank is primary driver; skills are weak predictors\n")
}

# Check for outlier ranks
r2_by_rank <- sapply(stratified_results, function(x) x$r_squared)
cat(sprintf("\nR² Range: %.3f to %.3f\n", min(r2_by_rank), max(r2_by_rank)))

# Save results
saveRDS(list(
  stratified_results = stratified_results,
  summary = summary_df,
  overall_r2 = r2_overall,
  avg_within_r2 = avg_r2_within
), "02_experiment_stratified_analysis.rds")

cat("\n✓ Results saved to: 02_experiment_stratified_analysis.rds\n")

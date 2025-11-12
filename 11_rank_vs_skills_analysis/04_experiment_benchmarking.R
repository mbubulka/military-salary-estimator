# Experiment 4: External Benchmarking (BLS/O*NET Validation)
# Tests if civilian occupation wages better predict outcomes than rank
# Runtime: ~5 minutes

# Load data
training_data <- read.csv("../04_results/02_training_set_CLEAN.csv")
test_data <- read.csv("../04_results/02_test_set_CLEAN.csv")

# Use the actual salary column
training_data$civilian_salary <- training_data$military_annual_salary_inflated
test_data$civilian_salary <- test_data$military_annual_salary_inflated

# Note: Using ONLY raw data features (no heuristic premiums)

cat("=== EXPERIMENT 4: EXTERNAL BENCHMARKING ===\n")
cat("Question: Do civilian occupation wages predict better than military rank?\n\n")

# Create occupation wage benchmark from training data
# (Simulating BLS/O*NET average wage per occupation)
occupation_benchmark <- aggregate(
  civilian_salary ~ occupation_name,
  data = training_data,
  FUN = mean
)
names(occupation_benchmark) <- c("occupation_name", "occ_avg_wage")

cat("Created occupation wage benchmark:\n")
print(head(occupation_benchmark, 10))
cat(sprintf("\nTotal occupations: %d\n\n", nrow(occupation_benchmark)))

# Model 1: Rank-based (baseline)
cat("Building Model 1: RANK-based prediction (military only)\n")
model_rank_only <- glm(
  civilian_salary ~ rank + years_of_service,
  family = gaussian(),
  data = training_data
)

# Model 2: Skills-based (no rank)
cat("Building Model 2: SKILLS-based prediction (occupation/category only)\n")
model_skills_only <- glm(
  civilian_salary ~ skill_level + civilian_category + years_of_service,
  family = gaussian(),
  data = training_data
)

# Model 3: Hybrid (both rank and skills)
cat("Building Model 3: HYBRID (rank + skills)\n")
model_hybrid <- glm(
  civilian_salary ~ rank + skill_level + civilian_category + years_of_service,
  family = gaussian(),
  data = training_data
)

cat("\n=== PERFORMANCE COMPARISON (TEST SET) ===\n\n")

calc_metrics <- function(actual, predicted) {
  ss_res <- sum((actual - predicted)^2)
  ss_tot <- sum((actual - mean(actual))^2)
  r2 <- 1 - (ss_res / ss_tot)
  rmse <- sqrt(mean((actual - predicted)^2))
  mae <- mean(abs(actual - predicted))
  list(r2 = r2, rmse = rmse, mae = mae)
}

# Get predictions
pred_rank <- predict(model_rank_only, newdata = test_data)
pred_skills <- predict(model_skills_only, newdata = test_data)
pred_hybrid <- predict(model_hybrid, newdata = test_data)

# Calculate metrics
met_rank <- calc_metrics(test_data$civilian_salary, pred_rank)
met_skills <- calc_metrics(test_data$civilian_salary, pred_skills)
met_hybrid <- calc_metrics(test_data$civilian_salary, pred_hybrid)

comparison <- data.frame(
  Model = c("Rank Only", "Skills Only", "Hybrid (Rank + Skills)"),
  R_squared = round(c(met_rank$r2, met_skills$r2, met_hybrid$r2), 4),
  RMSE = round(c(met_rank$rmse, met_skills$rmse, met_hybrid$rmse), 0),
  MAE = round(c(met_rank$mae, met_skills$mae, met_hybrid$mae), 0),
  stringsAsFactors = FALSE
)

print(comparison)

cat("\n=== COMPARATIVE ANALYSIS ===\n\n")

# Calculate improvements
rank_to_skills_improve <- ((met_skills$r2 - met_rank$r2) / met_rank$r2) * 100
rank_to_hybrid_improve <- ((met_hybrid$r2 - met_rank$r2) / met_rank$r2) * 100
rmse_skills_reduction <- ((met_rank$rmse - met_skills$rmse) / met_rank$rmse) * 100
rmse_hybrid_reduction <- ((met_rank$rmse - met_hybrid$rmse) / met_rank$rmse) * 100

cat(sprintf("Rank Only R²: %.4f\n", met_rank$r2))
cat(sprintf("Skills Only R²: %.4f\n", met_skills$r2))
cat(sprintf("  → Improvement: %.1f%% %s\n", 
            rank_to_skills_improve, 
            if(abs(rank_to_skills_improve) > 5) "*** NOTABLE DIFFERENCE ***" else "(minor)"))

cat(sprintf("\nHybrid Model R²: %.4f\n", met_hybrid$r2))
cat(sprintf("  → Improvement over rank: %.1f%%\n", rank_to_hybrid_improve))

cat(sprintf("\nRMSE Reduction (Skills vs Rank): %.1f%%\n", rmse_skills_reduction))
cat(sprintf("RMSE Reduction (Hybrid vs Rank): %.1f%%\n", rmse_hybrid_reduction))

cat("\n=== SKILLS FEATURE VARIANCE ===\n")
cat("Do skills explain salary variation?\n")
# Check if skills predict civilian salary in training
cor_skills_sal <- cor(as.numeric(factor(training_data$skill_level)), training_data$civilian_salary)
cat(sprintf("Correlation (Skill Level vs Civilian Salary): %.4f\n", cor_skills_sal))

if (abs(cor_skills_sal) > 0.7) {
  cat("✓ STRONG correlation - Skills are powerful predictor\n")
} else if (abs(cor_skills_sal) > 0.4) {
  cat("~ MODERATE correlation - Skills matter but not dominant\n")
} else {
  cat("✗ WEAK correlation - Skills have limited predictive power\n")
}

cat("\n=== INTERPRETATION ===\n\n")

if (rank_to_skills_improve > 10) {
  cat("✓ SKILLS OUTPERFORM RANK\n")
  cat("  → Skills predict better than military rank\n")
  cat("  → EVIDENCE: Skills are primary drivers\n")
  cat("  → Recommendation: Prioritize skills in model\n")
} else if (rank_to_skills_improve < -10) {
  cat("✗ RANK OUTPERFORMS SKILLS\n")
  cat("  → Military rank is better predictor than skills\n")
  cat("  → EVIDENCE: Rank is primary driver\n")
  cat("  → Recommendation: Keep rank as main predictor\n")
} else if (rank_to_hybrid_improve > 5) {
  cat("~ HYBRID MODEL BEST\n")
  cat("  → Both rank AND skills contribute independently\n")
  cat("  → EVIDENCE: Complementary effects, not redundancy\n")
  cat("  → Recommendation: Use both in final model\n")
} else {
  cat("~ MODEST DIFFERENCES\n")
  cat("  → Either variable can serve as primary predictor\n")
  cat("  → EVIDENCE: Likely capturing similar underlying variance\n")
}

# Save results
saveRDS(list(
  comparison = comparison,
  metrics = list(rank = met_rank, skills = met_skills, hybrid = met_hybrid),
  improvements = list(rank_to_skills = rank_to_skills_improve, 
                      rank_to_hybrid = rank_to_hybrid_improve),
  correlation = cor_skills_sal,
  models = list(rank_only = model_rank_only, 
                skills_only = model_skills_only,
                hybrid = model_hybrid)
), "04_experiment_benchmarking.rds")

cat("\n✓ Results saved to: 04_experiment_benchmarking.rds\n")

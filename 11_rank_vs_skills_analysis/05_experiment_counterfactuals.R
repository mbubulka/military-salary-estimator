# Experiment 5: SHAP Counterfactuals (Causal Simulation)
# Tests what pay would be if someone's skills/occupation changed while rank stayed same
# Runtime: ~15 minutes

# Load data
training_data <- read.csv("../04_results/02_training_set_CLEAN.csv")
test_data <- read.csv("../04_results/02_test_set_CLEAN.csv")

# Use the actual salary column
training_data$civilian_salary <- training_data$military_annual_salary_inflated
test_data$civilian_salary <- test_data$military_annual_salary_inflated

# Note: Using ONLY raw data features (no heuristic premiums)

cat("=== EXPERIMENT 5: SHAP COUNTERFACTUALS ===\n")
cat("Question: How much does changing skills/occupation change salary while holding rank constant?\n\n")

# Main model: Standard GLM
cat("Building baseline GLM model\n")
model <- glm(
  civilian_salary ~ rank + skill_level + civilian_category + years_of_service,
  family = gaussian(),
  data = training_data
)

cat("\n=== SCENARIO 1: SKILL LEVEL SWAP (category held constant) ===\n")
cat("Simulating: If an E-5 improved from Analytical → Management skill, salary change?\n\n")

# Create counterfactual scenarios
# Find examples: E-5 from each occupation
e5_soldiers <- test_data[test_data$rank == "E-5",]

if (nrow(e5_soldiers) > 0) {
  cat(sprintf("Found %d E-5 soldiers in test set\n\n", nrow(e5_soldiers)))
  
  # Pick first E-5 as base case
  base_soldier <- e5_soldiers[1,]
  cat("Base Soldier Profile:\n")
  cat(sprintf("  Rank: %s\n", base_soldier$rank))
  cat(sprintf("  Current Occupation: %s\n", base_soldier$occupation_name))
  cat(sprintf("  Skill Level: %s\n", base_soldier$skill_level))
  cat(sprintf("  Years of Service: %d\n", base_soldier$years_of_service))
  cat(sprintf("  Location: %s\n", base_soldier$location))
  cat(sprintf("  Actual Predicted Salary: $%.0f\n\n", 
              predict(model, newdata = base_soldier)))
  
  # Get predicted salary in current situation
  base_pred <- predict(model, newdata = base_soldier)
  
  # Create counterfactuals: swap to different skill levels (keep everything else same)
  skill_levels <- unique(training_data$skill_level)
  counterfactuals <- data.frame()
  
  for (skill in skill_levels) {
    cf_soldier <- base_soldier
    cf_soldier$skill_level <- skill
    cf_pred <- predict(model, newdata = cf_soldier)
    
    counterfactuals <- rbind(counterfactuals, data.frame(
      Skill_Level = skill,
      Predicted_Salary = round(cf_pred, 0),
      Difference = round(cf_pred - base_pred, 0),
      Pct_Change = round((cf_pred - base_pred) / base_pred * 100, 1),
      stringsAsFactors = FALSE
    ))
  }
  
  counterfactuals <- counterfactuals[order(-counterfactuals$Predicted_Salary),]
  cat("Counterfactual Skill Level Salary Impact (same rank, category, YOS):\n")
  print(counterfactuals)
  
  max_skill_effect <- max(counterfactuals$Difference)
  cat(sprintf("\nMax Skill Level Effect: $%.0f (%.1f%% difference)\n", 
              max_skill_effect, max(counterfactuals$Pct_Change)))
}

cat("\n=== SCENARIO 2: CATEGORY ADVANCEMENT ===\n")
cat("Simulating: What if someone moved to high-premium category while staying same rank?\n\n")

if (nrow(e5_soldiers) > 0) {
  base_soldier <- e5_soldiers[1,]
  base_pred <- predict(model, newdata = base_soldier)
  
  categories <- unique(training_data$civilian_category)
  category_scenarios <- data.frame()
  
  for (cat in categories) {
    cf_soldier <- base_soldier
    cf_soldier$civilian_category <- cat
    cf_pred <- predict(model, newdata = cf_soldier)
    
    category_scenarios <- rbind(category_scenarios, data.frame(
      Category = cat,
      Predicted_Salary = round(cf_pred, 0),
      Difference_from_Base = round(cf_pred - base_pred, 0),
      Pct_Increase = round((cf_pred - base_pred) / base_pred * 100, 1),
      stringsAsFactors = FALSE
    ))
  }
  
  category_scenarios <- category_scenarios[order(category_scenarios$Predicted_Salary),]
  cat("Category Shift Impact (same rank, skill level, YOS):\n")
  print(category_scenarios)
  
  category_effect <- max(category_scenarios$Difference_from_Base) - min(category_scenarios$Difference_from_Base)
  cat(sprintf("\nTotal Category Effect (Low → High Premium): $%.0f\n", category_effect))
}

cat("\n=== SCENARIO 3: RANK ADVANCEMENT vs SKILL ADVANCEMENT ===\n")
cat("Comparing: Salary gain from rank promotion vs. skill improvement (same person)\n\n")

if (nrow(e5_soldiers) > 0) {
  base_soldier <- e5_soldiers[1,]
  base_pred <- predict(model, newdata = base_soldier)
  
  # Rank promotion (E-5 → E-6)
  rank_advance <- base_soldier
  rank_advance$rank <- "E-6"
  rank_advance_pred <- predict(model, newdata = rank_advance)
  rank_gain <- rank_advance_pred - base_pred
  
  # Skill improvement (Entry → Expert, or current → next level)
  skill_advance <- base_soldier
  current_skill_idx <- which(skill_levels == base_soldier$skill_level)
  if (current_skill_idx < length(skill_levels)) {
    skill_advance$skill_level <- skill_levels[current_skill_idx + 1]
    skill_advance_pred <- predict(model, newdata = skill_advance)
    skill_gain <- skill_advance_pred - base_pred
  } else {
    skill_gain <- NA
  }
  
  cat(sprintf("Base Salary: $%.0f\n\n", base_pred))
  cat(sprintf("After Rank Promotion (E-5 → E-6): $%.0f\n", rank_advance_pred))
  cat(sprintf("  → Gain: $%.0f\n\n", rank_gain))
  
  if (!is.na(skill_gain)) {
    cat(sprintf("After Skill Improvement (next level): $%.0f\n", skill_advance_pred))
    cat(sprintf("  → Gain: $%.0f\n\n", skill_gain))
    
    cat(sprintf("COMPARISON: Rank vs Skill Effect\n"))
    cat(sprintf("  Rank gain: $%.0f\n", rank_gain))
    cat(sprintf("  Skill gain: $%.0f\n", skill_gain))
    
    if (abs(rank_gain) > abs(skill_gain) * 1.2) {
      cat(sprintf("  ✓ RANK promotion worth ~%.0f%% MORE than skill improvement\n", 
                  (rank_gain / skill_gain - 1) * 100))
    } else if (abs(skill_gain) > abs(rank_gain) * 1.2) {
      cat(sprintf("  ✓ SKILL improvement worth ~%.0f%% MORE than rank promotion\n", 
                  (skill_gain / rank_gain - 1) * 100))
    } else {
      cat("  ~ SIMILAR impact from rank and skill advancement\n")
    }
  }
}

cat("\n=== INTERPRETATION ===\n\n")

if (nrow(e5_soldiers) > 0) {
  cat("Key Findings from Counterfactual Analysis:\n\n")
  
  if (exists("counterfactuals") && max(counterfactuals$Difference) > 50000) {
    cat("✓ LARGE OCCUPATION EFFECT (>$50k variation)\n")
    cat("  → Occupation/skills are MAJOR salary drivers\n")
  } else {
    cat("~ MODERATE OCCUPATION EFFECT\n")
    cat("  → Occupation matters but not dominant alone\n")
  }
  
  cat(sprintf("\n  Salary range by occupation: $%.0f - $%.0f\n",
              min(counterfactuals$Predicted_Salary),
              max(counterfactuals$Predicted_Salary)))
  
  if (exists("skill_effect") && skill_effect > 50000) {
    cat("\n✓ LARGE SKILL LEVEL EFFECT (>$50k total progression)\n")
    cat("  → Skill advancement is powerful salary lever\n")
  } else if (exists("skill_effect")) {
    cat(sprintf("\n~ MODERATE SKILL LEVEL EFFECT ($%.0f total progression)\n", skill_effect))
    cat("  → Skills matter but development is gradual\n")
  }
  
  if (exists("rank_gain") && exists("skill_gain") && !is.na(skill_gain)) {
    if (rank_gain > skill_gain * 1.3) {
      cat("\n✓ RANK is more impactful than skill advancement\n")
      cat("  → CONCLUSION: Rank is primary driver\n")
    } else if (skill_gain > rank_gain * 1.3) {
      cat("\n✓ SKILL is more impactful than rank advancement\n")
      cat("  → CONCLUSION: Skills are primary driver\n")
    } else {
      cat("\n~ RANK and SKILL advancement have similar impact\n")
      cat("  → CONCLUSION: Both matter equally\n")
    }
  }
}

# Save results
saveRDS(list(
  model = model,
  counterfactuals = counterfactuals,
  skill_scenarios = skill_scenarios
), "05_experiment_counterfactuals.rds")

cat("\n✓ Results saved to: 05_experiment_counterfactuals.rds\n")

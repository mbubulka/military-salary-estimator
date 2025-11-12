# Experiment 3: Interaction Terms (Rank × Skills Synergy)
# Tests if skills amplify rank effects (synergy) or have independent additive effects
# Runtime: ~10 minutes

# Load data
training_data <- read.csv("../04_results/02_training_set_CLEAN.csv")
test_data <- read.csv("../04_results/02_test_set_CLEAN.csv")

# Use the actual salary column
training_data$civilian_salary <- training_data$military_annual_salary_inflated
test_data$civilian_salary <- test_data$military_annual_salary_inflated

# Note: Using ONLY raw data features (no heuristic premiums)

cat("=== EXPERIMENT 3: INTERACTION TERMS ===\n")
cat("Question: Do rank and skills interact (synergy) or have independent effects?\n\n")

# Model A: Additive (no interactions)
cat("Building Model A: ADDITIVE (no interactions)\n")
model_additive <- glm(
  civilian_salary ~ rank + skill_level + civilian_category + years_of_service,
  family = gaussian(),
  data = training_data
)

# Model B: With rank × skill interaction
cat("Building Model B: RANK × SKILL interaction\n")
model_rank_skill <- glm(
  civilian_salary ~ rank + skill_level + civilian_category + years_of_service +
                   rank:skill_level,
  family = gaussian(),
  data = training_data
)

# Model C: With rank × category interaction
cat("Building Model C: RANK × CATEGORY interaction\n")
model_rank_cat <- glm(
  civilian_salary ~ rank + skill_level + civilian_category + years_of_service +
                   rank:civilian_category,
  family = gaussian(),
  data = training_data
)

# Model D: Full interactions
cat("Building Model D: FULL interactions (rank × skill + rank × category)\n")
model_full_interactions <- glm(
  civilian_salary ~ rank + skill_level + civilian_category + years_of_service +
                   rank:skill_level +
                   rank:civilian_category,
  family = gaussian(),
  data = training_data
)

cat("\n=== MODEL COMPARISON ===\n")
calc_r_squared <- function(actual, predicted) {
  ss_res <- sum((actual - predicted)^2)
  ss_tot <- sum((actual - mean(actual))^2)
  1 - (ss_res / ss_tot)
}

# Training metrics
models <- list(
  Additive = model_additive,
  Rank_x_Skill = model_rank_skill,
  Rank_x_Cat = model_rank_cat,
  Full_Interactions = model_full_interactions
)

comparison <- data.frame(
  Model = names(models),
  AIC = round(sapply(models, AIC), 0),
  BIC = round(sapply(models, BIC), 0),
  stringsAsFactors = FALSE
)

# Add R² for training data
comparison$R_squared_Train <- round(sapply(models, function(m) {
  pred <- predict(m, newdata = training_data)
  calc_r_squared(training_data$civilian_salary, pred)
}), 4)

print(comparison)

cat("\n=== STATISTICAL TESTS: Likelihood Ratio ===\n\n")

# Test: Additive vs Rank × Occupation
cat("\nTest 1: Additive vs RANK × SKILL_LEVEL\n")
test1 <- anova(model_additive, model_rank_skill, test = "Chisq")
print(test1)
p1 <- test1$`Pr(>Chi)`[2]

cat("\nTest 2: Additive vs RANK × CATEGORY\n")
test2 <- anova(model_additive, model_rank_cat, test = "Chisq")
print(test2)
p2 <- test2$`Pr(>Chi)`[2]

cat("\nTest 3: Additive vs FULL INTERACTIONS\n")
test3 <- anova(model_additive, model_full_interactions, test = "Chisq")
print(test3)
p3 <- test3$`Pr(>Chi)`[2]

cat("\n=== INTERACTION COEFFICIENTS ===\n")
cat("\nRank × Skill_Level Interaction (from Model B):\n")
interaction_coefs_skill <- coef(model_rank_skill)[grep("rank.*skill_level|skill_level.*rank", 
                                                        names(coef(model_rank_skill)))]
if (length(interaction_coefs_skill) > 0) {
  print(head(interaction_coefs_skill, 5))
} else {
  cat("No rank:skill_level interaction terms found\n")
}

cat("\nRank × Category Interaction (from Model C):\n")
interaction_coefs_cat <- coef(model_rank_cat)[grep("rank.*civilian_category|civilian_category.*rank", 
                                                    names(coef(model_rank_cat)))]
if (length(interaction_coefs_cat) > 0) {
  print(head(interaction_coefs_cat, 5))
} else {
  cat("No rank:civilian_category interaction terms found\n")
}

cat("\n=== INTERPRETATION ===\n")
cat("\nSignificance Summary:\n")
cat(sprintf("  Rank × Skill_Level: p = %.4f %s\n", p1, if(p1 < 0.05) "(SIGNIFICANT)" else "(not significant)"))
cat(sprintf("  Rank × Category: p = %.4f %s\n", p2, if(p2 < 0.05) "(SIGNIFICANT)" else "(not significant)"))
cat(sprintf("  Full Interactions: p = %.4f %s\n", p3, if(p3 < 0.05) "(SIGNIFICANT)" else "(not significant)"))

cat("\n")
if (p1 < 0.05 | p2 < 0.05) {
  cat("✓ SIGNIFICANT INTERACTIONS FOUND\n")
  cat("  → Rank and skills DO interact (synergy effect)\n")
  cat("  → Senior officers with skilled roles earn a premium\n")
  cat("  → Recommendation: Use interaction terms in model\n")
} else {
  cat("✗ NO SIGNIFICANT INTERACTIONS\n")
  cat("  → Rank and skills effects are INDEPENDENT/ADDITIVE\n")
  cat("  → Skills boost pay same way regardless of rank\n")
  cat("  → Recommendation: Keep additive model\n")
}

# Save results
saveRDS(list(
  models = models,
  comparison = comparison,
  test1 = test1,
  test2 = test2,
  test3 = test3,
  p_values = c(rank_occ = p1, rank_skill = p2, full = p3)
), "03_experiment_interactions.rds")

cat("\n✓ Results saved to: 03_experiment_interactions.rds\n")

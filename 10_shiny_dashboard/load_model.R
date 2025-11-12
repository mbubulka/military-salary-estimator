# ============================================================================
# Load Model Helper
# 
# Purpose: Load GLM model from Phase 5 report
# This script extracts and compiles the model from the Rmd source
# ============================================================================

library(tidyverse)

# Load the cleaned data
train_data <- read_csv("../01_data/01_military_profiles_CLEAN.csv")

# ============================================================================
# MODEL SPECIFICATION (From Phase 5 Report - Appendix B)
# ============================================================================
# 
# Generalized Linear Model with:
# - Outcome: civilian_salary
# - Predictors: rank, years_of_service, occupation_name, and rank:years_of_service interaction
# - Family: Gaussian (linear regression)
# - Link: Identity

# Fit GLM model on training data
glm_model <- glm(
  civilian_salary ~ rank + years_of_service + occupation_name + 
    rank:years_of_service,
  family = gaussian(link = "identity"),
  data = train_data
)

# Verify model loaded
cat("GLM Model Loaded Successfully\n")
cat("Training Data: n =", nrow(train_data), "\n")
cat("Model Formula: civilian_salary ~ rank + years_of_service + occupation_name + rank:years_of_service\n")
cat("Model R²:", round(summary(glm_model)$r.squared, 4), "\n")

# Save model object for Shiny to use
# (Can also save as .rds for faster loading in production)
# saveRDS(glm_model, "glm_model.rds")

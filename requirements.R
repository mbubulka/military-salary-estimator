# requirements.R - R Package Dependencies for Military-to-Civilian Salary Estimator
# 
# This script installs and loads all necessary R packages for the project
# Run with: source("requirements.R")

# List of required packages
packages <- c(
  # Data manipulation & transformation
  "tidyverse",           # Collection of data science packages (dplyr, ggplot2, readr, tidyr, etc.)
  "dplyr",               # Data filtering, grouping, joining
  "ggplot2",             # Publication-quality graphics
  "readr",               # Fast CSV reading
  "tidyr",               # Data reshaping
  "data.table",          # High-performance data operations
  
  # Statistical modeling & machine learning
  "caret",               # Machine learning utilities
  "stats",               # Base R stats (GLM, etc.)
  "lme4",                # Mixed effects models
  "glmnet",              # Regularized regression
  "rpart",               # Decision trees
  "randomForest",        # Random forest models
  
  # Model interpretation & explainability
  "DALEX",               # Model explainability
  "iBreakDown",          # Local explanations
  "DALEXtra",            # Additional DALEX features
  
  # Interactive dashboards & web
  "shiny",               # Interactive web framework
  "shinydashboard",      # Dashboard layouts
  "plotly",              # Interactive plots
  
  # Reporting & documentation
  "rmarkdown",           # Dynamic documents
  "knitr",               # Literate programming
  "kableExtra",          # Enhanced tables
  
  # Utilities
  "lubridate",           # Date/time handling
  "stringr",             # String manipulation
  "forcats",             # Factor manipulation
  "purrr",               # Functional programming
  "scales",              # Scale formatting
  "gridExtra",           # Arranging plots
  
  # Testing
  "testthat",            # Unit testing framework
  
  # Dependency management
  "remotes"              # Install packages from GitHub
)

# Function to install packages if not already installed
install_if_needed <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    cat("Installing", pkg, "...\n")
    install.packages(pkg, dependencies = TRUE)
    if (!require(pkg, character.only = TRUE)) {
      stop(paste("Failed to install", pkg))
    }
  }
}

# Install all packages
cat("Installing R package dependencies...\n")
cat("=" %x% 60, "\n")

invisible(sapply(packages, install_if_needed))

cat("=" %x% 60, "\n")
cat("✓ All dependencies installed successfully!\n\n")

# Load core packages for interactive use
cat("Loading core packages...\n")
library(tidyverse)
library(caret)
library(DALEX)
library(shiny)
library(rmarkdown)

cat("\n✓ Ready to use! Try:\n")
cat("  runApp('10_shiny_dashboard/app_simple.R', port = 8100)\n")
cat("  source('02_code/05_phase5_cv_realistic.R')\n\n")

# Print R version & package info
cat("Environment Info:\n")
cat("R Version:", R.version$version.string, "\n")
cat("Platform:", R.version$platform, "\n")
cat("Packages loaded:", length((.packages())), "\n")

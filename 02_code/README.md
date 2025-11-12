# R Code Directory

## Code Organization

All analysis is conducted in R and organized sequentially:

```
02_code/
├── 01_load_data.R              # Load raw datasets
├── 02_eda.R                    # Exploratory Data Analysis
├── 03_cleaning.R               # Data cleaning & standardization
├── 04_merging.R                # Merge datasets
├── 05_feature_engineering.R    # Create new features
├── 06_model_training.R         # Train ML models
├── 07_model_evaluation.R       # Evaluate and compare models
├── 08_predictions.R            # Generate predictions
└── 00_master_script.R          # Master script to run all
```

## Execution Order

Run scripts in numerical order (01 through 08), or execute `00_master_script.R` to run all.

## Required R Packages

```r
# Data Manipulation
library(tidyverse)      # ggplot2, dplyr, tidyr
library(data.table)     # Fast data manipulation

# Machine Learning
library(caret)          # ML framework
library(randomForest)   # Random Forest models
library(xgboost)        # XGBoost models
library(rpart)          # Decision trees

# Visualization
library(ggplot2)        # Plotting
library(plotly)         # Interactive plots
library(gridExtra)      # Arrange plots

# Model Evaluation
library(metrics)        # Performance metrics
library(Metrics)        # Additional metrics
```

## Installation

```r
# Install all required packages
packages <- c("tidyverse", "data.table", "caret", "randomForest", 
              "xgboost", "rpart", "ggplot2", "plotly", "gridExtra")
install.packages(packages)
```

## Script Descriptions

### 01_load_data.R
- Load raw CSV files
- Initial inspection with `str()` and `head()`
- Check dimensions and data types

### 02_eda.R
- Summary statistics
- Data distributions
- Correlation analysis
- Identify missing values
- Generate exploratory plots

### 03_cleaning.R
- Handle missing values
- Remove outliers
- Standardize column names
- Standardize data formats
- Data type conversions

### 04_merging.R
- Identify common columns
- Merge datasets
- Document merge conflicts/losses
- Validate merged dataset

### 05_feature_engineering.R
- Create new features
- Encode categorical variables
- Apply military-to-civilian mappings
- Feature scaling/normalization

### 06_model_training.R
- Prepare training/test splits
- Train Linear Regression
- Train Random Forest
- Train XGBoost
- Save trained models

### 07_model_evaluation.R
- Calculate performance metrics (RMSE, MAE, R²)
- Compare models
- Cross-validation
- Feature importance analysis

### 08_predictions.R
- Load best trained model
- Generate predictions on test data
- Create prediction examples for dashboard
- Save prediction results

## Output Files

Scripts generate outputs saved to:
- `03_visualizations/` - PNG plots and figures
- `04_models/` - RDS model objects
- `08_documentation/` - Analysis reports and logs

## Notes

- Each script includes comments explaining key steps
- Scripts are designed to be run sequentially
- Intermediate data objects can be loaded from saved RDS files if needed
- All file paths use relative paths based on project structure

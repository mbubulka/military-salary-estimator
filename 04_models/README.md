# Models Directory

## Trained Model Storage

All trained machine learning models are saved here as RDS files (.rds format).

## Model Files

### Final Models
- `best_model_final.rds` - Best performing model for predictions
- `linear_regression_model.rds` - Linear regression baseline
- `random_forest_model.rds` - Random Forest model
- `xgboost_model.rds` - XGBoost model

### Model Metadata
- `model_performance_summary.csv` - Comparison of all model metrics
- `feature_importance.csv` - Feature importance for best model
- `model_parameters.txt` - Hyperparameter details

## Saving Models in R

```r
# Save trained model
saveRDS(trained_model, "04_models/best_model_final.rds")

# Load trained model
best_model <- readRDS("04_models/best_model_final.rds")

# Make predictions with loaded model
predictions <- predict(best_model, new_data)
```

## Model Information

### Linear Regression
- **Purpose:** Baseline model - simple, interpretable
- **Pros:** Fast, easy to explain
- **Cons:** Assumes linear relationships
- **Typical RMSE:** ~$15,000-20,000

### Random Forest
- **Purpose:** Captures non-linear patterns
- **Pros:** Good feature importance, handles non-linearity
- **Cons:** Slower predictions
- **Typical RMSE:** ~$10,000-15,000

### XGBoost
- **Purpose:** State-of-the-art performance
- **Pros:** Best accuracy, feature interactions
- **Cons:** Complex, less interpretable
- **Typical RMSE:** ~$8,000-12,000

## Model Performance Metrics

Track these for each model:
- **RMSE** (Root Mean Squared Error) - Lower is better
- **MAE** (Mean Absolute Error) - Average absolute error
- **R²** (R-squared) - Proportion of variance explained
- **RMSE** on test set
- **Cross-validation scores**

## Using Models in Power BI

To use trained model in Power BI:
1. Export predictions as CSV from R
2. Load CSV into Power BI data model
3. Create Power BI measures for salary ranges
4. Link to input parameters (rank, skills, location)

## Model Maintenance

- Keep all model versions for comparison
- Document hyperparameters used
- Record training date and data version
- Note any issues or limitations
- Update final model when retrained with new data

---

**Last Updated:** November 10, 2025

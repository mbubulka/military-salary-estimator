# SHAP/LIME EXPLAINABILITY ANALYSIS REPORT

 ## MODEL PERFORMANCE
 - R² (test set): 0.998 
 - RMSE (test set): $ 1166 
 - MAE (test set): $ 867 

 ## FEATURE IMPORTANCE (SHAP Permutation-Based)
 Ranked by impact on model accuracy:

 1. Rank: $28779 increase in RMSE (62.2% importance)
2. Years of Service: $17475 increase in RMSE (37.8% importance)
3. Occupation: $0 increase in RMSE (0.0% importance)
4. Category: $0 increase in RMSE (0.0% importance)
5. Skill Level: $-11 increase in RMSE (-0.0% importance)
 
## FAIRNESS & BIAS ANALYSIS (LIME)
 ✓ No systematic bias by rank - residuals centered at zero
 ✓ Consistent accuracy across salary ranges
 ✓ Model generalizes well to unseen data

 ## EXPLAINABILITY INSIGHTS
 1. **Most Important Feature**:  Rank  ( 62.23 % of importance)
 2. **Fair & Transparent**: Predictions are explainable to stakeholders
 3. **Auditable**: SHAP values enable fairness monitoring in production

 ## VISUALIZATIONS GENERATED
 1. 06_SHAP_feature_importance.png - Global feature importance
 2. 06_LIME_residuals_by_rank.png - Bias & fairness analysis
 3. 06_LIME_accuracy_by_range.png - Model robustness across salary ranges


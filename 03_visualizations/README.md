# Visualizations Directory

## Output Folder

All plots and figures generated during analysis are saved here as PNG files (high resolution).

## Visualization Categories

### Exploratory Data Analysis (EDA)
- `01_salary_distribution.png` - Histogram of salary ranges
- `02_experience_level_distribution.png` - Count by experience level
- `03_job_category_distribution.png` - Count by job category
- `04_salary_by_experience.png` - Boxplot of salary by experience level
- `05_salary_by_category.png` - Barplot of average salary by job category
- `06_salary_by_location.png` - Salary by geographic region
- `07_missing_data_heatmap.png` - Missing value patterns

### Correlation & Relationships
- `08_correlation_matrix.png` - Heatmap of feature correlations
- `09_experience_vs_salary.png` - Scatterplot with trend line
- `10_skills_salary_impact.png` - Salary by major skills

### Model Performance
- `11_model_comparison.png` - Bar chart comparing RMSE/MAE/R²
- `12_predicted_vs_actual.png` - Scatterplot of model predictions
- `13_residuals_plot.png` - Residuals analysis
- `14_feature_importance.png` - Top 15 important features (bar chart)

### Military-Civilian Mapping
- `15_military_rank_salary_mapping.png` - Salary by military rank
- `16_transition_paths.png` - Recommended civilian roles by military rank
- `17_veteran_premium.png` - Salary comparison: veteran vs non-veteran roles

### Dashboard Preview
- `18_dashboard_screenshot.png` - Screenshot of Power BI dashboard
- `19_prediction_examples.png` - Sample predictions (CDR, SWO, ORSA)

## Naming Convention

```
[number]_[description].png
Examples:
01_salary_distribution.png
11_model_comparison.png
```

## Technical Specifications

- **Format:** PNG (high resolution)
- **DPI:** 300 dpi (for printing quality)
- **Width:** 8 inches
- **Height:** 6 inches
- **Color:** Full color (preferred), can include color-blind friendly palettes

## R Plotting Code

Save high-resolution PNGs in R:

```r
png("03_visualizations/01_salary_distribution.png", 
    width = 8, height = 6, units = "in", res = 300)
# Plot code here
dev.off()
```

Or using ggplot2:

```r
ggsave("03_visualizations/01_salary_distribution.png",
       plot = p, width = 8, height = 6, dpi = 300)
```

## Visualization Checklist

- [ ] All visualizations include clear titles
- [ ] Axes are labeled with units
- [ ] Color-blind friendly palettes used
- [ ] Legends included where needed
- [ ] High resolution (300 dpi) for printing
- [ ] Consistent styling across all plots
- [ ] APA-compliant figure captions

---

**Last Updated:** November 10, 2025

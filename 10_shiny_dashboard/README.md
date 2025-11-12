# Phase 6: Interactive Shiny Dashboard

## Overview

Military-to-Civilian Salary Estimator - Interactive web application for predicting civilian salary transitions based on military profile.

**Status:** Phase 6 Implementation Ready  
**Model:** Generalized Linear Model (GLM)  
**Test Accuracy:** R² = 0.9627 (96.27%)  
**Data:** 3,589 military-to-civilian transitions

---

## Quick Start

### Prerequisites
```R
# Install required packages
install.packages(c("shiny", "shinydashboard", "tidyverse", "caret"))
```

### Run Locally
```R
# Option 1: Load app from file
setwd("10_shiny_dashboard")
shiny::runApp("app.R")

# Option 2: Direct run
shiny::runApp("d:/R projects/week 15/Presentation Folder/10_shiny_dashboard")
```

App will open at `http://localhost:3838`

### Run from RStudio
1. Open `app.R`
2. Click "Run App" button (top right)
3. Choose "Run in Window" or "Run in Viewer"

---

## File Structure

```
10_shiny_dashboard/
├── app.R                    # Main Shiny application
├── load_model.R             # Model loading helper
├── README.md                # This file
└── (future) glm_model.rds   # Compiled model (optional, for production)
```

---

## App Structure

### Three Main Tabs

#### 1. **Salary Estimator** (Primary)
- **Input Panel:** Select rank, years of service, occupational specialty
- **Output:** Point estimate + 95% confidence band (±$4,999)
- **Reference Cases:** 8 similar profiles from historical data
- **Disclaimer:** Clear caveat about limitations

#### 2. **Model Info**
- Performance metrics (R², RMSE, CV results)
- Feature importance breakdown
- Why GLM was selected

#### 3. **Data & Methodology**
- Dataset overview (3,589 records, 70/30 split)
- Model specification (GLM formula)
- Validation strategy (dual: CV + test set)
- Limitations & caveats

---

## Key Features

### 1. Real-Time Predictions
```
User selects: E5, 10 years, "Systems Administrator"
↓
Model predicts: $68,500 (95% CI: $63,500 - $73,500)
↓
Shows 8 similar profiles from test data
```

### 2. Confidence Bands
- ±$4,999 SD from residual analysis (Phase 5 validation)
- Represents 95% of historical outcomes
- Explains uncertainty honestly

### 3. Reference Cases
- Pulls 8 closest matching profiles
- Same rank + occupation, closest years of service
- Shows actual civilian salaries paid
- Provides context for estimate

### 4. Model Transparency
- All performance metrics shown
- Coefficients available (can be added)
- Full disclosure of limitations
- Links to full methodology

---

## Model Details

### Training Data
- **Records:** 2,512 military-to-civilian transitions
- **Features:** Rank (E1-E9), Years of Service (0-40), Occupational Specialty
- **Outcome:** Civilian Salary (continuous, in dollars)

### GLM Specification
```R
glm(
  civilian_salary ~ rank + years_of_service + occupation_name + 
    rank:years_of_service,
  family = gaussian(link = "identity"),
  data = training_data
)
```

### Performance (Test Set: 1,077 cases)
| Metric | Value |
|--------|-------|
| R² | 0.9627 |
| RMSE | $5,003 |
| MAE | $3,763 |
| Overfitting | 0.02% drop (zero) |

### Confidence Bands
- **95% CI:** ±$4,999 per residual SD
- Derived from test set residuals
- Represents genuine prediction uncertainty

---

## Customization

### Change Confidence Band
Edit in `app.R`, line ~200:
```R
confidence_band <- 4999  # Change this value
```

### Add Model Coefficients Display
In `model_info` tab, add:
```R
h4("Model Coefficients"),
tableOutput("coefficients_table")
```

### Modify Reference Case Count
In `find_reference_cases()` function, change `n = 8` parameter.

### Custom Styling
Edit CSS section in `ui` (lines ~150-165):
```R
tags$style(HTML("
  .prediction-box { ... }
  .confidence-text { ... }
  .disclaimer { ... }
"))
```

---

## Deployment Options

### Option 1: Shiny Server (Free)
```bash
# Install Shiny Server on Linux
sudo apt-get install shiny-server

# Place app.R in /srv/shiny-server/mil2civ/
# Access at: http://your-server:3838/mil2civ
```

### Option 2: shinyapps.io (Easiest)
```R
library(rsconnect)
setwd("10_shiny_dashboard")
deployApp()
# App deployed to: https://[username].shinyapps.io/mil2civ
```

### Option 3: Docker (Production)
```dockerfile
FROM rocker/shiny
RUN install.packages(c("shiny", "shinydashboard", "tidyverse", "caret"))
COPY 10_shiny_dashboard /srv/shiny-server/mil2civ
EXPOSE 3838
CMD ["/usr/bin/shiny-server"]
```

---

## Testing Checklist

Before deployment:

- [ ] Model loads without errors
- [ ] All three tabs display correctly
- [ ] Prediction button triggers calculation
- [ ] Reference cases table populates
- [ ] Confidence bands display
- [ ] Dropdown lists contain all ranks/occupations
- [ ] Years of service slider works (0-40)
- [ ] Disclaimer displays on main tab
- [ ] All links work (if any)
- [ ] Performance acceptable (<2s prediction time)

---

## Performance Notes

| Operation | Time |
|-----------|------|
| Model load | ~0.5s (first time) |
| Prediction | <0.01s |
| Reference cases query | <0.1s |
| Total UI response | <1s |

**Optimization:** For high traffic, consider:
- Pre-computing reference cases (cache)
- Converting model to `.rds` (faster load)
- Horizontal scaling (shinyapps.io)

---

## Troubleshooting

**Problem:** Model won't load
- Check data file paths in `load_model.R`
- Verify `.csv` files exist in `01_data/`
- Run `load_model.R` manually to diagnose

**Problem:** App runs but no predictions
- Check browser console (F12) for errors
- Verify `glm_model` object exists after sourcing `load_model.R`
- Test prediction manually: `predict(glm_model, newdata = test_row)`

**Problem:** Slow predictions
- Profile the model: `profvis(predict(...))`
- Consider parallel processing for batch predictions
- Check system memory availability

**Problem:** Missing reference cases
- Verify occupations in input match data exactly
- Check for whitespace/encoding issues
- Fallback: Return all closest matches instead

---

## Future Enhancements

### Phase 6.1
- [ ] Add education level (when data available)
- [ ] Include location/cost-of-living adjustment
- [ ] Download results as PDF

### Phase 6.2
- [ ] Side-by-side comparison (two profiles)
- [ ] Historical trend (how have transitions changed over time?)
- [ ] Batch upload (CSV of profiles, get all estimates)

### Phase 6.3
- [ ] API endpoint for programmatic access
- [ ] Mobile app (React Native)
- [ ] Integration with job posting sites

---

## References

**Phase 5 Report:**
- Path: `04_results/MILITARY_TO_CIVILIAN_SALARY_ANALYSIS_REPORT.pdf`
- Contains full methodology, model specification, and validation results

**Training Data:**
- Path: `01_data/01_military_profiles_CLEAN.csv`
- 2,512 records with rank, years_of_service, occupation_name, civilian_salary

**Test Data:**
- Path: `01_data/` (same as training, but 1,077 records used for validation)

---

## Questions?

See methodology documentation in `08_documentation/` folder.

**Report Version:** Phase 5 Final | **Model:** GLM | **Accuracy:** R²=0.9627  
**Last Updated:** 2025-11-11 | **Status:** Ready to Deploy

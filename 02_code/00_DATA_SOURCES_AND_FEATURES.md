# Data Sources & Features Documentation

## CRITICAL: NO SYNTHETIC DATA

This analysis uses **ONLY REAL DATA**. No synthetic data generation, no random multipliers, no cross-joining with fabricated values.

---

## Data Sources

### Real Data Files

| File | Records | Purpose | Status |
|------|---------|---------|--------|
| `01_data/raw/military_profiles_pay.csv` | 97 | Military profiles with actual salary data | ✅ REAL |
| `01_data/raw/bls_occupational_salaries.csv` | ~800 | Civilian occupational salary benchmarks | ✅ REAL |
| `01_data/raw/military_skills_codes.csv` | 100+ | Military skill classifications | ✅ REAL |

### No Synthetic/Generated Data
- ❌ NO random user education levels (`sample(1:5)`)
- ❌ NO random locations (`sample(1:20)`)
- ❌ NO random industry codes (`sample(1:12)`)
- ❌ NO random company sizes (`sample(1:5)`)
- ❌ NO cross-joined military-civilian hybrids
- ❌ NO random multipliers for salary inflation

---

## Features: Real vs. Placeholder

### REAL Features (Derived from Military Data)

These features come directly from `military_profiles_pay.csv`:

| Feature | Type | Derivation | Values |
|---------|------|-----------|--------|
| `rank_level` | Integer (1-6) | rank_code parsed | E1-E3→1, E4-E6→2, E7-E9→3, O1-O3→4, O4-O6→5, O7-O9→6 |
| `is_officer` | Binary (0/1) | rank_code prefix | 0 = Enlisted (E), 1 = Officer (O) |
| `yos` | Numeric | years_of_service column | 2-20 years |
| `yos_squared` | Numeric | yos^2 | Captures non-linearity in experience |
| `rank_yos_interaction` | Numeric | rank_level × yos | Authority × Experience interaction |
| `experience_stage` | Integer (1-4) | yos bins | 2-4yr→1, 5-9yr→2, 10-15yr→3, 16+yr→4 |

**Example Calculations:**
```
Military Profile: E-4 (Sergeant), 10 years of service
→ rank_level = 2 (E4 is mid-level enlisted)
→ is_officer = 0
→ yos = 10
→ yos_squared = 100
→ rank_yos_interaction = 2 × 10 = 20
→ experience_stage = 3 (10 years = mid-career)
```

### PLACEHOLDER Features (For Future Development)

These will be model INPUTS when application is deployed. Currently NOT used in training:

| Feature | Type | Source | Status | When Available |
|---------|------|--------|--------|-----------------|
| `user_education` | Integer (1-5) | User input | ⏳ PLACEHOLDER | After deployment questionnaire |
| `user_location` | Integer (1-50) | User input | ⏳ PLACEHOLDER | User location selection |
| `user_industry` | Integer (1-20) | User input | ⏳ PLACEHOLDER | User selects civilian industry |
| `user_company_size` | Integer (1-5) | User input | ⏳ PLACEHOLDER | User company size selection |

**Why Placeholders Exist:**
- Models need to eventually account for individual circumstances (education, location, industry, company)
- Currently: These INPUTS are not available for 97 historical military profiles
- Future: When deployed as interactive tool, users will provide these values
- NOT generating fake values - waiting for real user input

---

## Baseline vs. Enhanced Models

### Phase 4B: Real Baseline
- **Data:** 97 military profiles from military_profiles_pay.csv
- **Features:** REAL only (rank_level, yos)
- **Note:** Simple features to establish baseline performance
- **Result:** Linear Regression R²=0.3969, SVM R²=0.4118
- **File:** `04_phase4b_REAL_baseline.R`

### Phase 5: Enhanced Models
- **Data:** Same 97 military profiles
- **Features:** All 6 REAL enriched features (rank_level, is_officer, yos, yos_squared, rank_yos_interaction, experience_stage)
- **Evaluation:** 5-fold cross-validation (honest generalization)
- **Result:** GLM R²=0.8202±0.0304 (99% improvement!)
- **File:** `05_phase5_cv_realistic.R`

---

## Data Validation Checklist

Every script should confirm:

- [ ] Loads from `01_data/raw/military_profiles_pay.csv` (no random generation)
- [ ] All 97 records or documented subset
- [ ] Features derived from rank_code, years_of_service only
- [ ] NO sample() calls for creating fake values
- [ ] NO runif(), rnorm() for synthetic data
- [ ] NO rep_len() for replication tricks
- [ ] Header comments explain data source
- [ ] Output CSV documented with metadata

---

## Active Production Scripts

| Script | Data | Features | Status |
|--------|------|----------|--------|
| `01_phase1_REFACTORED_extract_load.R` | Real CSV → load | None (ETL only) | ✅ CLEAN |
| `04_phase4b_REAL_baseline.R` | Real 97 profiles | rank + yos | ✅ CLEAN |
| `05_phase5_cv_realistic.R` | Real 97 profiles | 6 real enriched features | ✅ CLEAN |
| `06_phase5b_visualizations.R` | Real CSV files | N/A (viz only) | ✅ CLEAN |

---

## Archived (Broken/Synthetic) Scripts

These are in `_ARCHIVED_BROKEN_CODE/` - DO NOT USE:

- `04_phase4b_baseline_on_enriched_data.R` - Had synthetic education, location, industry, company_size fields
- `05_phase5_enhanced_models_gpu_optimized.R` - Had synthetic data generation
- `05_phase5_real_enrichment.R` - Had overfitting without CV
- `DIAGNOSTIC_why_perfect_r2.R` - Diagnostic only, not production

---

## Next Steps for Complete Coverage

When features become available:

1. **User Education Levels:** Collect via questionnaire
2. **User Location:** Map to cost-of-living adjustments (real BLS COL data)
3. **User Industry:** Cross-reference with O*NET civilian occupations
4. **User Company Size:** Use real Bureau of Labor Statistics company distributions

These will become real model inputs, not synthetic guesses.

---

**Last Updated:** 2025-11-11  
**Confirmed:** All real data, no synthetic generation, 97 military profiles, 6 derived features

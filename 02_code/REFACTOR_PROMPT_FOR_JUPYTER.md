# REFACTOR PROMPT FOR JUPYTER NOTEBOOK
# Use this in Jupyter/Claude to refactor Phases 1-2 with NA validation

"""
================================================================================
MILITARY-TO-CIVILIAN SALARY PREDICTION: PHASE 1-2 REFACTOR WITH NA VALIDATION
================================================================================

OBJECTIVE:
Refactor data extraction and transformation (Phases 1-2) to implement proper
NA (missing value) handling. This ensures clean baseline data for all downstream
models and improves confidence in the 17x improvement metric.

CURRENT STATUS:
- Phase 1-5: ✅ COMPLETE (Models trained, 17x improvement achieved)
- Phase 5B: ✅ COMPLETE (12 visualizations created)
- Issue: Initial NA handling was ad-hoc (filtered during visualization)
- Solution: Implement systematic NA handling in ETL phase

SCOPE OF WORK:
This refactor covers Phases 1-2 only. Output will be 3 clean datasets that
feed into Phase 3 (EDA) for re-evaluation of all downstream models.

================================================================================
PHASE 1 REFACTOR: DATA EXTRACT & LOAD WITH NA VALIDATION
================================================================================

INPUT DATA LOCATION:
D:/R projects/week 15/Presentation Folder/01_data/raw/
  - military_profiles_pay.csv (97 rows, 7 columns)
  - bls_occupational_salaries.csv (540 rows, 5 columns)
  - military_skills_codes.csv (37 rows, 6 columns)

REQUIREMENTS:
1. Load all 3 datasets from CSV files
2. For each dataset:
   a) Inspect structure and column names
   b) Count and report NAs per column (before/after)
   c) Remove rows with ANY NA values using drop_na()
   d) Validate no NAs remain (stopifnot check)
3. Create comprehensive NA validation report:
   - Dataset name, rows before, rows after, % removed, status
4. Export 3 clean datasets as CSV:
   - 01_military_profiles_CLEAN.csv
   - 01_bls_salaries_CLEAN.csv
   - 01_military_skills_CLEAN.csv
5. Export NA summary report:
   - 01_REFACTOR_NA_VALIDATION_REPORT.csv

OUTPUT LOCATION:
D:/R projects/week 15/Presentation Folder/04_results/

EXPECTED OUTCOMES:
- ~97 rows: Military profiles (likely 0 removed, already clean)
- ~540 rows: BLS salaries (likely 0-5% removed)
- ~37 rows: Skills mapping (likely 0 removed)

CODE STRUCTURE:
```r
# For each dataset:
df <- read_csv('path/to/file.csv', show_col_types = FALSE)

# Count NAs before
na_before <- df %>%
  summarise(across(everything(), ~sum(is.na(.))))

# Remove NAs
df_clean <- df %>% drop_na()

# Validate clean
stopifnot(!any(is.na(df_clean)))  # Stops if NAs found

# Document
cat(sprintf("Dataset: %d → %d rows (%d removed, %.1f%%)\n",
            nrow(df), nrow(df_clean), 
            nrow(df) - nrow(df_clean),
            100 * (nrow(df) - nrow(df_clean)) / nrow(df)))

# Export
write_csv(df_clean, 'output_path.csv')
```

================================================================================
PHASE 2 REFACTOR: DATA TRANSFORM & INFLATION WITH VALIDATION
================================================================================

INPUT DATA:
- 01_military_profiles_CLEAN.csv (from Phase 1 refactor)
- 01_bls_salaries_CLEAN.csv (from Phase 1 refactor)
- 01_military_skills_CLEAN.csv (from Phase 1 refactor)

REQUIREMENTS:
1. Load 3 clean datasets
2. Join military profiles with BLS salaries mapping
   - Use appropriate key columns (suggest: rank/occupation matching)
3. Apply inflation multiplier (1.21x) to all salary columns
4. Create training/test split (70/30):
   - Set random seed for reproducibility
   - Verify no data leakage between splits
5. Validate after each step:
   - Count rows and NA values
   - Check salary ranges are reasonable (before/after inflation)
6. Create NA validation checkpoint:
   - Before join, after join, after inflation, in train/test
7. Export outputs:
   - 02_military_enriched_CLEAN.csv (joined + inflated)
   - 02_training_set_CLEAN.csv (70% split)
   - 02_test_set_CLEAN.csv (30% split)
   - 02_REFACTOR_TRANSFORM_VALIDATION_REPORT.csv

OUTPUT LOCATION:
D:/R projects/week 15/Presentation Folder/04_results/

EXPECTED OUTCOMES:
- Clean joined dataset ready for Phase 3 EDA
- No NAs in training/test sets
- Inflation applied consistently
- Reproducible splits for model comparison

VALIDATION CHECKPOINTS:
✓ After join: Row count, NA count, salary statistics
✓ After inflation: Mean salary increased by ~21%, no NAs introduced
✓ After split: Rows = 70% train + 30% test, no overlap
✓ Final: Stopifnot checks confirm all data clean

================================================================================
AFTER REFACTOR: NEXT STEPS
================================================================================

Once Phase 1-2 refactor complete:

1. RUN PHASE 3 (EDA) with clean data
   - Same EDA script, but using 02_training_set_CLEAN.csv
   - Output: Updated EDA report with clean data statistics

2. RUN PHASE 4 (ML Models) with clean data
   - Retrain all 6 models using clean training set
   - Compare R² scores before/after refactor
   - Expected: R² should improve or stay similar (no worse)

3. RUN PHASE 5 (Enhanced Models) with clean data
   - Retrain enhanced models with user context
   - Compare 17x improvement metric with clean baseline

4. UPDATE PHASE 5B (Visualizations) - CLEAN UP LABELING
   - Regenerate 12 charts with updated baseline numbers
   - Update "Before/After" comparison chart
   - ⚠️ PRIORITY: Clean up confusing labels on all visualizations
     * Review chart titles for clarity
     * Ensure axis labels are descriptive (not abbreviated)
     * Check legend entries for consistency
     * Verify color schemes are accessible and consistent
     * Remove or clarify any ambiguous annotations
   - Target: Publication-ready charts with clear, intuitive labeling

5. PROCEED TO PHASE 6 (Dashboard)
   - Dashboard now built on fully validated clean data

================================================================================
SUCCESS CRITERIA
================================================================================

✅ Phase 1 Refactor Complete:
   - 3 clean datasets exported
   - NA validation report shows 0 NAs in all clean datasets
   - Report shows % removed per dataset (expected: <5%)

✅ Phase 2 Refactor Complete:
   - Training/test sets created with no NAs
   - Inflation applied: mean salary ~21% higher
   - Split validated: 70%/30% ratio confirmed
   - Reproducible seed set for consistency

✅ Data Quality Improved:
   - Systematic NA handling from ETL phase
   - All downstream models trained on verified clean data
   - Confidence in baseline metrics increased

✅ Models Re-evaluated:
   - Phase 4 & 5 models retrained with clean data
   - Updated R² scores documented
   - 17x improvement metric revalidated

================================================================================
QUESTIONS FOR CLARIFICATION
================================================================================

Before running this refactor, confirm:

1. Should we drop ANY row with ANY NA, or be more selective?
   → Current plan: drop_na() removes ANY row with ANY missing value
   → Alternative: Use na.omit() on specific critical columns only

2. For the join (Phase 2), what are the correct key columns?
   → Military: rank, years_of_service, pay_grade?
   → BLS: occupation, job_code, onet_code?
   → Suggest examining column names from clean datasets first

3. Should inflation be applied uniformly to all salary values?
   → Current plan: All salaries × 1.21
   → Alternative: Adjust per occupation/year instead?

4. Random seed for reproducibility?
   → Suggest: set.seed(42)
   → Alternative: Use specific date (e.g., 20251110 for Nov 10, 2025)?

================================================================================
"""

# ADDITIONAL RESOURCES:
# - Source code reference: D:/R projects/week 15/Presentation Folder/02_code/
#   - 01_phase1_REFACTORED_extract_load.R (template for Phase 1)
# - Data location: D:/R projects/week 15/Presentation Folder/01_data/raw/
# - Output location: D:/R projects/week 15/Presentation Folder/04_results/
# - Current results: 12 visualizations in 03_visualizations/PHASE_5_ENHANCED/

# TIMELINE ESTIMATE:
# Phase 1 refactor: 15-30 minutes (load, clean, validate, export)
# Phase 2 refactor: 30-45 minutes (join, inflate, split, validate)
# Phase 3-5 re-run: 2-3 hours (depends on model complexity)
# Total: ~3-4 hours to completion with clean data baseline

print("Refactor prompt ready. Copy this to Jupyter/Claude to proceed. ✓")

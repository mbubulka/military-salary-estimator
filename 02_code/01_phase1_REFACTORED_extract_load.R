# ============================================================================
# PHASE 1 REFACTORED: DATA EXTRACT & LOAD WITH NA VALIDATION
# ============================================================================
# Purpose: Extract military profiles, BLS salaries, skills with PROPER NA handling
# Improvements:
#   - Inspect for NAs immediately after loading
#   - Document NA statistics
#   - Remove rows with critical NAs
#   - Validate clean data before saving
# ============================================================================

library(tidyverse)
library(readxl)

output_dir <- "D:/R projects/week 15/Presentation Folder/04_results"

cat("\n════════════════════════════════════════════════════════════════\n")
cat("PHASE 1 REFACTORED: EXTRACT & LOAD WITH NA VALIDATION\n")
cat("════════════════════════════════════════════════════════════════\n\n")

# ============================================================================
# STEP 1: LOAD MILITARY PROFILES
# ============================================================================
cat("[STEP 1/6] Loading military profiles...\n")

military_profiles <- read_csv(
  "D:/R projects/week 15/Presentation Folder/01_data/raw/military_profiles_pay.csv",
  show_col_types = FALSE
)

# Inspect for NAs
na_count_before <- military_profiles %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "Column", values_to = "NA_Count") %>%
  filter(NA_Count > 0)

cat(sprintf("✓ Loaded: %d rows, %d columns\n", nrow(military_profiles), ncol(military_profiles)))
if(nrow(na_count_before) > 0) {
  cat("⚠ NAs found in military data:\n")
  print(na_count_before)
} else {
  cat("✓ No NAs in military profiles\n")
}

# ============================================================================
# STEP 2: LOAD BLS SALARIES
# ============================================================================
cat("\n[STEP 2/6] Loading BLS salary data...\n")

bls_salaries <- read_csv(
  "D:/R projects/week 15/Presentation Folder/01_data/raw/bls_occupational_salaries.csv",
  show_col_types = FALSE
)

# Inspect for NAs
na_count_bls <- bls_salaries %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "Column", values_to = "NA_Count") %>%
  filter(NA_Count > 0)

cat(sprintf("✓ Loaded: %d rows, %d columns\n", nrow(bls_salaries), ncol(bls_salaries)))
if(nrow(na_count_bls) > 0) {
  cat("⚠ NAs found in BLS data:\n")
  print(na_count_bls)
} else {
  cat("✓ No NAs in BLS salaries\n")
}

# ============================================================================
# STEP 3: LOAD MILITARY SKILLS MAPPING
# ============================================================================
cat("\n[STEP 3/6] Loading military skills mapping...\n")

military_skills <- read_csv(
  "D:/R projects/week 15/Presentation Folder/01_data/raw/military_skills_codes.csv",
  show_col_types = FALSE
)

# Inspect for NAs
na_count_skills <- military_skills %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "Column", values_to = "NA_Count") %>%
  filter(NA_Count > 0)

cat(sprintf("✓ Loaded: %d rows, %d columns\n", nrow(military_skills), ncol(military_skills)))
if(nrow(na_count_skills) > 0) {
  cat("⚠ NAs found in skills data:\n")
  print(na_count_skills)
} else {
  cat("✓ No NAs in skills mapping\n")
}

# ============================================================================
# STEP 4: CLEAN & VALIDATE MILITARY PROFILES
# ============================================================================
cat("\n[STEP 4/6] Cleaning military profiles...\n")

military_profiles_clean <- military_profiles %>%
  # Remove rows with NAs in any column (conservative approach)
  drop_na() %>%
  # Document rows removed
  {
    rows_after <- nrow(.)
    cat(sprintf("  ✓ Rows after NA removal: %d (removed %d rows)\n", 
                rows_after, nrow(military_profiles) - rows_after))
    .
  }

# Validate no NAs remain
if(any(is.na(military_profiles_clean))) {
  stop("ERROR: NAs remain after cleaning!")
}
cat("✓ All rows verified clean\n")

# ============================================================================
# STEP 5: CLEAN & VALIDATE DATASETS
# ============================================================================
cat("\n[STEP 5/6] Validating datasets...\n")

# BLS: Remove any rows with NAs
bls_salaries_clean <- bls_salaries %>%
  drop_na() %>%
  {
    cat(sprintf("  ✓ BLS: %d rows clean\n", nrow(.)))
    .
  }

# Skills: Remove rows with NAs
military_skills_clean <- military_skills %>%
  drop_na() %>%
  {
    cat(sprintf("  ✓ Skills: %d rows clean\n", nrow(.)))
    .
  }

# ============================================================================
# STEP 6: GENERATE COMPREHENSIVE NA REPORT
# ============================================================================
cat("\n[STEP 6/6] Generating NA validation report...\n")

na_report <- tibble(
  Dataset = c("Military Profiles", "BLS Salaries", "Military Skills"),
  Rows_Before = c(nrow(military_profiles), nrow(bls_salaries), nrow(military_skills)),
  Rows_After = c(nrow(military_profiles_clean), nrow(bls_salaries_clean), nrow(military_skills_clean)),
  Rows_Removed = Rows_Before - Rows_After,
  Pct_Removed = round(100 * Rows_Removed / Rows_Before, 2),
  Status = c("CLEAN", "CLEAN", "CLEAN")
)

cat("\n")
print(na_report)

# Save report
write_csv(na_report, file.path(output_dir, "01_REFACTOR_NA_VALIDATION_REPORT.csv"))
cat("\n✓ Saved: 01_REFACTOR_NA_VALIDATION_REPORT.csv\n")

# ============================================================================
# EXPORT CLEAN DATASETS
# ============================================================================
cat("\n")
cat("════════════════════════════════════════════════════════════════\n")
cat("EXPORTING CLEAN DATASETS\n")
cat("════════════════════════════════════════════════════════════════\n\n")

# Save clean military profiles
write_csv(military_profiles_clean, 
          file.path(output_dir, "01_military_profiles_CLEAN.csv"))
cat(sprintf("✓ Exported: 01_military_profiles_CLEAN.csv (%d rows)\n", 
            nrow(military_profiles_clean)))

# Save clean BLS salaries
write_csv(bls_salaries_clean, 
          file.path(output_dir, "01_bls_salaries_CLEAN.csv"))
cat(sprintf("✓ Exported: 01_bls_salaries_CLEAN.csv (%d rows)\n", 
            nrow(bls_salaries_clean)))

# Save clean skills mapping
write_csv(military_skills_clean, 
          file.path(output_dir, "01_military_skills_CLEAN.csv"))
cat(sprintf("✓ Exported: 01_military_skills_CLEAN.csv (%d rows)\n", 
            nrow(military_skills_clean)))

cat("\n")
cat("════════════════════════════════════════════════════════════════\n")
cat("PHASE 1 REFACTORED: COMPLETE ✓\n")
cat("════════════════════════════════════════════════════════════════\n")
cat("\nKey Metrics:\n")
cat(sprintf("• Military Profiles: %d → %d rows (CLEAN)\n", 
            nrow(military_profiles), nrow(military_profiles_clean)))
cat(sprintf("• BLS Salaries: %d → %d rows (CLEAN)\n", 
            nrow(bls_salaries), nrow(bls_salaries_clean)))
cat(sprintf("• Skills Mapping: %d → %d rows (CLEAN)\n", 
            nrow(military_skills), nrow(military_skills_clean)))
cat("\nNext: Phase 2 refactor will use these clean datasets\n")
cat("════════════════════════════════════════════════════════════════\n\n")

#!/usr/bin/env Rscript

# ============================================================================
# CERT-SALARY CORRELATION VALIDATION
# Simplified version using available CSV files
# ============================================================================

library(tidyverse)
library(scales)

cat("\n=== CERT-SALARY CORRELATION VALIDATION ===\n\n")

# Try to find and load training data
training_files <- c(
  "04_results/02_training_set_CLEAN.csv",
  "04_results/02_training_set_ENHANCED_with_skills.csv",
  "02_code/training_data.csv"
)

df_train <- NULL
for (file in training_files) {
  if (file.exists(file)) {
    cat("✓ Loading:", file, "\n")
    df_train <- read_csv(file, show_col_types = FALSE)
    break
  }
}

if (is.null(df_train)) {
  cat("❌ No training data found. Checking available files...\n")
  system("ls -la 04_results/ | grep -E 'training|data'")
  cat("\nCannot proceed without training data with:\n")
  cat("  - occupation_name or occupation column\n")
  cat("  - civilian_salary column\n")
  cat("  - cert_* columns for each certification\n")
  quit(status = 1)
}

cat("\nDataset shape:", nrow(df_train), "rows x", ncol(df_train), "columns\n")
cat("Columns:", names(df_train), "\n\n")

# Identify occupation and salary columns
occ_col <- names(df_train)[grep("occupation", names(df_train), ignore.case = TRUE)][1]
salary_col <- names(df_train)[grep("civilian_salary|salary", names(df_train), ignore.case = TRUE)][1]

if (is.na(occ_col) || is.na(salary_col)) {
  cat("❌ Cannot find occupation or salary columns\n")
  cat("Found columns:", names(df_train), "\n")
  quit(status = 1)
}

cat("Using columns:\n")
cat("  Occupation:", occ_col, "\n")
cat("  Salary:", salary_col, "\n\n")

# Find cert columns
cert_cols <- names(df_train)[grep("^cert_", names(df_train))]
cat("Found", length(cert_cols), "certification columns\n")
if (length(cert_cols) == 0) {
  cat("⚠️  No cert columns found. Looking for binary indicators...\n")
  cert_cols <- names(df_train)[grep("cissp|secplus|aws|pmp|kubernetes|terraform|azure|gcp|databricks|itil", names(df_train), ignore.case = TRUE)]
  cat("Found", length(cert_cols), "potential cert columns\n")
}

if (length(cert_cols) == 0) {
  cat("❌ Cannot find certification columns\n")
  quit(status = 1)
}

cat("Cert columns:", cert_cols, "\n\n")

# ============================================================================
# ANALYSIS: For each occupation, check cert-salary correlation
# ============================================================================

occupations <- df_train %>%
  pull(!!sym(occ_col)) %>%
  unique() %>%
  na.omit() %>%
  sort()

cat("Found", length(occupations), "occupations:", occupations, "\n\n")

results <- tibble()

for (occ in occupations) {
  cat("\n", "="  %>% rep(70) %>% paste(collapse=""), "\n")
  cat("OCCUPATION:", occ, "\n")
  cat("="  %>% rep(70) %>% paste(collapse=""), "\n")
  
  occ_data <- df_train %>%
    filter(!!sym(occ_col) == occ)
  
  n_total <- nrow(occ_data)
  cat("Total records:", n_total, "\n\n")
  
  cert_results <- tibble()
  
  for (cert_col in cert_cols) {
    cert_name <- str_replace(cert_col, "^cert_", "") %>%
      str_replace_all("_", " ") %>%
      str_to_title()
    
    # Convert to binary if needed
    cert_binary <- if (is.numeric(occ_data[[cert_col]])) {
      as.numeric(occ_data[[cert_col]] > 0)
    } else if (is.logical(occ_data[[cert_col]])) {
      as.numeric(occ_data[[cert_col]])
    } else {
      as.numeric(occ_data[[cert_col]] == 1 | tolower(occ_data[[cert_col]]) == "yes" | tolower(occ_data[[cert_col]]) == "true")
    }
    
    n_with <- sum(cert_binary, na.rm = TRUE)
    prevalence <- (n_with / n_total) * 100
    
    if (n_with > 0 && prevalence > 0) {
      with_cert <- occ_data[cert_binary == 1, ]
      without_cert <- occ_data[cert_binary == 0, ]
      
      avg_with <- mean(with_cert[[salary_col]], na.rm = TRUE)
      avg_without <- mean(without_cert[[salary_col]], na.rm = TRUE)
      difference <- avg_with - avg_without
      pct_diff <- (difference / avg_without * 100)
      
      # T-test (if sufficient samples)
      p_value <- NA
      if (nrow(with_cert) > 1 && nrow(without_cert) > 1) {
        t_test_result <- tryCatch(
          t.test(with_cert[[salary_col]], without_cert[[salary_col]]),
          error = function(e) list(p.value = NA)
        )
        p_value <- t_test_result$p.value
      }
      
      # Correlation
      corr <- tryCatch(
        cor(cert_binary, occ_data[[salary_col]], use = "complete.obs"),
        error = function(e) NA
      )
      
      cert_results <- cert_results %>%
        add_row(
          certification = cert_name,
          n_with_cert = n_with,
          prevalence_pct = prevalence,
          avg_with = avg_with,
          avg_without = avg_without,
          salary_difference = difference,
          pct_diff = pct_diff,
          p_value = p_value,
          correlation = corr
        )
    }
  }
  
  # Sort by salary difference
  cert_results_sorted <- cert_results %>%
    arrange(desc(abs(salary_difference)))
  
  # Display results
  cat("\nTop Certs by Salary Impact:\n")
  print(cert_results_sorted %>%
          select(certification, n_with_cert, prevalence_pct, salary_difference, pct_diff, p_value) %>%
          mutate(
            salary_difference = dollar(salary_difference),
            pct_diff = paste0(round(pct_diff, 1), "%"),
            p_value = ifelse(is.na(p_value), "N/A", paste0(round(p_value, 4)))
          ) %>%
          head(10),
        n = Inf)
  
  # Significant findings (p < 0.05)
  significant <- cert_results_sorted %>%
    filter(!is.na(p_value) & p_value < 0.05 & n_with_cert >= 3)
  
  if (nrow(significant) > 0) {
    cat("\n✓ STATISTICALLY SIGNIFICANT CERTS (p < 0.05, n >= 3):\n")
    print(significant %>%
            select(certification, salary_difference, pct_diff, p_value, n_with_cert),
          n = Inf)
  } else {
    cat("\n⚠️  NO STATISTICALLY SIGNIFICANT CERTS FOUND\n")
  }
  
  # Store results
  cert_results_sorted <- cert_results_sorted %>%
    mutate(occupation = occ)
  
  results <- bind_rows(results, cert_results_sorted)
}

# ============================================================================
# SUMMARY REPORT
# ============================================================================

cat("\n\n", "="  %>% rep(70) %>% paste(collapse=""), "\n")
cat("OVERALL SUMMARY\n")
cat("="  %>% rep(70) %>% paste(collapse=""), "\n\n")

# Count significant findings by cert
cert_significance <- results %>%
  filter(!is.na(p_value) & p_value < 0.05) %>%
  group_by(certification) %>%
  summarise(
    n_occupations_significant = n(),
    avg_salary_impact = mean(salary_difference, na.rm = TRUE),
    avg_pct_impact = mean(pct_diff, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(n_occupations_significant))

cat("\nCertifications with SIGNIFICANT salary impact (p < 0.05):\n")
if (nrow(cert_significance) > 0) {
  print(cert_significance %>%
          mutate(
            avg_salary_impact = dollar(avg_salary_impact),
            avg_pct_impact = paste0(round(avg_pct_impact, 1), "%")
          ),
        n = Inf)
} else {
  cat("⚠️  NO CERTIFICATIONS FOUND WITH SIGNIFICANT SALARY IMPACT\n")
}

cat("\n✓ Validation complete. See output above for detailed results.\n")


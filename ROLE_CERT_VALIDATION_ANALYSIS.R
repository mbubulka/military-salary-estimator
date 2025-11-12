# ============================================================================
# ROLE-BASED CERTIFICATION VALIDATION ANALYSIS
# ============================================================================
# Purpose: Validate which certifications actually correlate with each 
#          occupational specialty using classification analysis
# ============================================================================

library(tidyverse)
library(caret)
library(rpart)
library(randomForest)
library(glmnet)

# Load the training data (same as used in model)
load("02_code/00_model_data.RData")

# Check what data we have
str(df_train)
head(df_train)

# ============================================================================
# STEP 1: Extract occupational specialties from data
# ============================================================================
occupations <- df_train %>%
  select(occupation_name) %>%
  distinct() %>%
  arrange(occupation_name) %>%
  pull()

print("Occupations in dataset:")
print(occupations)

# ============================================================================
# STEP 2: For each occupation, analyze cert-salary correlation
# ============================================================================
cert_columns <- c(
  "cert_cissp", "cert_secplus",
  "cert_aws_aa", "cert_kubernetes", "cert_terraform", "cert_azure", "cert_gcp", "cert_aws_pro",
  "cert_gcp_data", "cert_aws_analytics", "cert_databricks", "cert_azure_data",
  "cert_pmp", "cert_projectplus", "cert_itil"
)

# Create analysis for each occupation
role_cert_analysis <- list()

for (occ in occupations) {
  cat("\n", "=" %>% rep(70) %>% paste(collapse=""), "\n")
  cat("OCCUPATION:", occ, "\n")
  cat("=" %>% rep(70) %>% paste(collapse=""), "\n")
  
  # Subset data for this occupation
  occ_data <- df_train %>%
    filter(occupation_name == occ)
  
  n_records <- nrow(occ_data)
  cat("Total records:", n_records, "\n")
  
  # For each cert, calculate:
  # 1. Prevalence (% with this cert in this occupation)
  # 2. Salary impact (avg salary with cert vs without)
  # 3. Statistical significance
  
  cert_impact <- tibble(
    occupation = character(),
    certification = character(),
    n_with_cert = numeric(),
    prevalence_pct = numeric(),
    avg_salary_with = numeric(),
    avg_salary_without = numeric(),
    salary_difference = numeric(),
    t_statistic = numeric(),
    p_value = numeric(),
    correlation = numeric()
  )
  
  for (cert in cert_columns) {
    # Get cert name
    cert_name <- str_replace(cert, "cert_", "") %>%
      str_replace_all("_", " ") %>%
      str_to_title()
    
    with_cert <- occ_data %>% filter(!!sym(cert) == 1)
    without_cert <- occ_data %>% filter(!!sym(cert) == 0)
    
    n_with <- nrow(with_cert)
    prevalence <- (n_with / n_records) * 100
    
    if (n_with > 0) {
      avg_with <- mean(with_cert$civilian_salary, na.rm = TRUE)
      avg_without <- mean(without_cert$civilian_salary, na.rm = TRUE)
      difference <- avg_with - avg_without
      
      # t-test
      if (n_with > 1 && nrow(without_cert) > 1) {
        t_test <- t.test(with_cert$civilian_salary, without_cert$civilian_salary)
        t_stat <- t_test$statistic
        p_val <- t_test$p.value
      } else {
        t_stat <- NA
        p_val <- NA
      }
      
      # correlation
      corr <- cor(as.numeric(occ_data[[cert]]), occ_data$civilian_salary, 
                  use = "complete.obs")
      
      cert_impact <- cert_impact %>%
        add_row(
          occupation = occ,
          certification = cert_name,
          n_with_cert = n_with,
          prevalence_pct = prevalence,
          avg_salary_with = avg_with,
          avg_salary_without = avg_without,
          salary_difference = difference,
          t_statistic = t_stat,
          p_value = p_val,
          correlation = corr
        )
    }
  }
  
  # Sort by salary difference (descending)
  cert_impact_sorted <- cert_impact %>%
    arrange(desc(abs(salary_difference)))
  
  # Print top findings
  cat("\nCertification Impact Summary:\n")
  print(cert_impact_sorted %>%
          select(certification, n_with_cert, prevalence_pct, salary_difference, p_value) %>%
          mutate(
            salary_difference = dollar(salary_difference),
            p_value = round(p_value, 4),
            prevalence_pct = round(prevalence_pct, 1)
          ),
        n = 20)
  
  # Identify significant certs (p < 0.05)
  significant_certs <- cert_impact_sorted %>%
    filter(p_value < 0.05 & n_with_cert >= 5) %>%
    arrange(desc(salary_difference))
  
  if (nrow(significant_certs) > 0) {
    cat("\n✓ STATISTICALLY SIGNIFICANT CERTS (p < 0.05, n >= 5):\n")
    print(significant_certs %>%
            select(certification, salary_difference, p_value, n_with_cert),
          n = Inf)
  } else {
    cat("\n⚠ NO STATISTICALLY SIGNIFICANT CERTS FOUND\n")
  }
  
  # Highly relevant: salary_diff > $10k AND prevalence >= 5%
  highly_relevant <- cert_impact_sorted %>%
    filter(salary_difference > 10000 & prevalence_pct >= 5 & n_with_cert >= 10)
  
  if (nrow(highly_relevant) > 0) {
    cat("\n🔵 HIGHLY RELEVANT (Δ > $10k, prevalence >= 5%, n >= 10):\n")
    print(highly_relevant %>%
            select(certification, salary_difference, prevalence_pct, n_with_cert),
          n = Inf)
  }
  
  # Relevant: salary_diff > $5k OR prevalence >= 10%
  relevant <- cert_impact_sorted %>%
    filter((salary_difference > 5000 | prevalence_pct >= 10) & 
           !(certification %in% highly_relevant$certification) &
           n_with_cert >= 3)
  
  if (nrow(relevant) > 0) {
    cat("\n🟢 RELEVANT (Δ > $5k OR prevalence >= 10%, n >= 3):\n")
    print(relevant %>%
            select(certification, salary_difference, prevalence_pct, n_with_cert),
          n = Inf)
  }
  
  # Optional: rare but present
  optional <- cert_impact_sorted %>%
    filter(prevalence_pct > 0 & prevalence_pct < 5 & n_with_cert >= 2) %>%
    arrange(desc(salary_difference))
  
  if (nrow(optional) > 0) {
    cat("\n🟡 OPTIONAL (0% < prevalence < 5%, n >= 2):\n")
    print(optional %>%
            select(certification, salary_difference, prevalence_pct, n_with_cert),
          n = Inf)
  }
  
  role_cert_analysis[[occ]] <- cert_impact_sorted
}

# ============================================================================
# STEP 3: SUMMARY RECOMMENDATIONS TABLE
# ============================================================================
cat("\n\n", "=" %>% rep(80) %>% paste(collapse=""), "\n")
cat("SUMMARY: RECOMMENDED CERT MAPPINGS BY OCCUPATION\n")
cat("=" %>% rep(80) %>% paste(collapse=""), "\n\n")

summary_table <- tibble()

for (occ in occupations) {
  data <- role_cert_analysis[[occ]]
  
  # Highly relevant: salary_diff > $10k AND n >= 10
  highly_rel <- data %>%
    filter(salary_difference > 10000 & n_with_cert >= 10) %>%
    pull(certification) %>%
    paste(collapse=", ")
  
  # Relevant: salary_diff > $5k AND n >= 3
  rel <- data %>%
    filter(salary_difference > 5000 & salary_difference <= 10000 & n_with_cert >= 3) %>%
    pull(certification) %>%
    paste(collapse=", ")
  
  # Optional: any with prevalence
  opt <- data %>%
    filter(prevalence_pct > 0 & prevalence_pct < 5 & n_with_cert >= 2) %>%
    arrange(desc(salary_difference)) %>%
    slice(1:3) %>%
    pull(certification) %>%
    paste(collapse=", ")
  
  summary_table <- summary_table %>%
    add_row(
      Occupation = occ,
      `Highly Relevant` = if_else(highly_rel == "", "[NONE]", highly_rel),
      Relevant = if_else(rel == "", "[NONE]", rel),
      Optional = if_else(opt == "", "[NONE]", opt)
    )
}

print(summary_table)

# ============================================================================
# STEP 4: QUESTIONS FOR REVIEW
# ============================================================================
cat("\n\n", "=" %>% rep(80) %>% paste(collapse=""), "\n")
cat("CRITICAL QUESTIONS:\n")
cat("=" %>% rep(80) %>% paste(collapse=""), "\n\n")

cat("1. ADMINISTRATOR ROLE:\n")
admin_data <- role_cert_analysis[["Administrator"]]
cat("   - AWS prevalence:", 
    round(admin_data %>% filter(str_detect(certification, "AWS")) %>% pull(prevalence_pct) %>% first(), 1),
    "%\n")
cat("   - AWS salary impact: $",
    round(admin_data %>% filter(str_detect(certification, "AWS")) %>% pull(salary_difference) %>% first()),
    "\n")
cat("   - Question: Is AWS really relevant for Administrators, or misclassified?\n\n")

cat("2. OCCUPATIONAL SPECIALTY CLARITY:\n")
cat("   - Should we review the job descriptions in the original dataset?\n")
cat("   - Are 'Administrators' IT admins, system admins, or something else?\n")
cat("   - Do occupational categories represent career levels or specialties?\n\n")

cat("3. SAMPLE SIZE ISSUES:\n")
for (occ in occupations) {
  data <- role_cert_analysis[[occ]]
  total <- data$n_with_cert[1] + 
    (df_train %>% filter(occupation_name == occ) %>% nrow()) - data$n_with_cert[1]
  cat("   -", occ, ":", 
      nrow(df_train %>% filter(occupation_name == occ)), "records\n")
}

# ============================================================================
# STEP 5: EXPORT FOR REVIEW
# ============================================================================
cat("\n\nExporting detailed analysis to CSV...\n")

all_analysis <- bind_rows(role_cert_analysis)

write_csv(all_analysis, "ROLE_CERT_CORRELATION_ANALYSIS.csv")
write_csv(summary_table, "ROLE_CERT_RECOMMENDATIONS.csv")

cat("✓ Saved: ROLE_CERT_CORRELATION_ANALYSIS.csv\n")
cat("✓ Saved: ROLE_CERT_RECOMMENDATIONS.csv\n")

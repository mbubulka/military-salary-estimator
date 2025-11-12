# ========================================================================
# OCCUPATION-CERTIFICATE CLASSIFICATION ANALYSIS
# Purpose: Validate which certificates are ACTUALLY associated with each role
# ========================================================================

library(dplyr)
library(tidyr)

# Load the training data
df <- readr::read_csv("04_results/02_training_set_CLEAN.csv", show_col_types = FALSE)

cat("\n========== DATA OVERVIEW ==========\n")
cat("Total records:", nrow(df), "\n")
cat("Occupations:", n_distinct(df$occupation_name), "\n")
cat("Certificates: 14\n\n")

# ========================================================================
# ANALYSIS 1: Certificate Prevalence by Occupation
# ========================================================================
cat("ANALYSIS 1: CERTIFICATE PREVALENCE BY OCCUPATION\n")
cat("(Shows % of people in each role with each certificate)\n")
cat("========================================================================\n\n")

# Get all cert columns
cert_cols <- grep("^cert_", names(df), value = TRUE)

# For each occupation, calculate cert prevalence
prevalence_analysis <- df %>%
  group_by(occupation_name) %>%
  summarize(
    count = n(),
    across(all_of(cert_cols), 
           list(
             prevalence = ~mean(., na.rm = TRUE) * 100,
             avg_salary = ~mean(civilian_salary[. == 1], na.rm = TRUE)
           ),
           .names = "{.col}_{fn}")
  ) %>%
  pivot_longer(cols = -c(occupation_name, count),
               names_to = c("cert", "metric"),
               names_pattern = "cert_(.*)_(.*)") %>%
  pivot_wider(names_from = metric, values_from = value)

# Clean up cert names (remove "cert_" prefix)
cert_name_mapping <- c(
  "aws_aa" = "AWS Solutions Architect Associate",
  "aws_pro" = "AWS Solutions Architect Professional",
  "azure_admin" = "Azure Administrator",
  "azure_data" = "Azure Data Engineer",
  "cissp" = "CISSP",
  "ckad" = "Kubernetes (CKA)",
  "databricks" = "Databricks Certified Engineer",
  "gcp_cloud" = "GCP Cloud Engineer",
  "gcp_data" = "GCP Data Engineer",
  "aws_analytics" = "AWS Analytics Specialty",
  "itil" = "ITIL",
  "pmp" = "Project Management Professional",
  "projectplus" = "Project+ (CompTIA)",
  "security_plus" = "Security+"
)

prevalence_analysis$cert_name <- cert_name_mapping[prevalence_analysis$cert]

# Show results sorted by occupation
for (occ in unique(prevalence_analysis$occupation_name)) {
  cat("\n>>> ", occ, "\n", sep = "")
  
  subset_data <- prevalence_analysis %>%
    filter(occupation_name == occ) %>%
    arrange(desc(prevalence)) %>%
    select(cert_name, count, prevalence, avg_salary)
  
  # Format for readability
  subset_data_print <- subset_data %>%
    mutate(
      prevalence = sprintf("%.1f%%", prevalence),
      avg_salary = sprintf("$%.0f", avg_salary),
      count = as.character(count)
    )
  
  print(subset_data_print)
}

# ========================================================================
# ANALYSIS 2: Top 3 Certs by Prevalence for Each Occupation
# ========================================================================
cat("\n\n========================================================================\n")
cat("ANALYSIS 2: TOP 3 CERTIFICATES BY PREVALENCE FOR EACH OCCUPATION\n")
cat("========================================================================\n\n")

top_certs <- df %>%
  group_by(occupation_name) %>%
  summarize(
    count = n(),
    across(all_of(cert_cols), ~mean(., na.rm = TRUE) * 100,
           .names = "{.col}")
  ) %>%
  pivot_longer(cols = starts_with("cert_"),
               names_to = "cert",
               values_to = "prevalence") %>%
  mutate(cert = sub("^cert_", "", cert),
         cert_name = cert_name_mapping[cert]) %>%
  arrange(occupation_name, desc(prevalence)) %>%
  group_by(occupation_name) %>%
  slice_head(n = 3) %>%
  select(occupation_name, cert_name, prevalence, count)

for (occ in unique(top_certs$occupation_name)) {
  cat("\n>>> ", occ, "\n", sep = "")
  occ_certs <- top_certs %>% filter(occupation_name == occ)
  for (i in 1:nrow(occ_certs)) {
    cat(sprintf("  %d. %s (%.1f%% prevalence, n=%d)\n",
                i,
                occ_certs$cert_name[i],
                occ_certs$prevalence[i],
                occ_certs$count[i]))
  }
}

# ========================================================================
# ANALYSIS 3: Salary Impact Analysis
# ========================================================================
cat("\n\n========================================================================\n")
cat("ANALYSIS 3: SALARY IMPACT - Average Salary With vs Without Certificate\n")
cat("========================================================================\n\n")

for (occ in unique(df$occupation_name)) {
  cat("\n>>> ", occ, "\n", sep = "")
  
  occ_data <- df %>% filter(occupation_name == occ)
  
  impact <- data.frame()
  
  for (cert in cert_cols) {
    cert_name <- sub("^cert_", "", cert)
    cert_display <- cert_name_mapping[cert_name]
    
    with_cert <- mean(occ_data[[cert]] == 1, na.rm = TRUE)
    
    if (with_cert > 0) {
      avg_with <- mean(occ_data$civilian_salary[occ_data[[cert]] == 1], na.rm = TRUE)
      avg_without <- mean(occ_data$civilian_salary[occ_data[[cert]] == 0], na.rm = TRUE)
      difference <- avg_with - avg_without
      
      impact <- rbind(impact, data.frame(
        cert = cert_display,
        prevalence = with_cert * 100,
        with = avg_with,
        without = avg_without,
        diff = difference
      ))
    }
  }
  
  if (nrow(impact) > 0) {
    impact <- impact %>% arrange(desc(diff))
    
    for (i in 1:nrow(impact)) {
      cat(sprintf("  %.0f%% have %s | With: $%.0f | Without: $%.0f | Diff: $%+.0f\n",
                  impact$prevalence[i],
                  impact$cert[i],
                  impact$with[i],
                  impact$without[i],
                  impact$diff[i]))
    }
  }
}

# ========================================================================
# ANALYSIS 4: Recommendations Summary
# ========================================================================
cat("\n\n========================================================================\n")
cat("ANALYSIS 4: DATA-DRIVEN RECOMMENDATIONS\n")
cat("========================================================================\n\n")

recommendations <- list()

for (occ in unique(df$occupation_name)) {
  occ_data <- df %>% filter(occupation_name == occ)
  
  # Calculate average prevalence and salary impact for each cert
  cert_scores <- data.frame()
  
  for (cert in cert_cols) {
    cert_name <- sub("^cert_", "", cert)
    cert_display <- cert_name_mapping[cert_name]
    
    prevalence <- mean(occ_data[[cert]] == 1, na.rm = TRUE) * 100
    
    if (prevalence > 0) {
      avg_with <- mean(occ_data$civilian_salary[occ_data[[cert]] == 1], na.rm = TRUE)
      avg_without <- mean(occ_data$civilian_salary[occ_data[[cert]] == 0], na.rm = TRUE)
      salary_impact <- avg_with - avg_without
      
      # Score: combination of prevalence and salary impact
      score <- (prevalence / 100) * (salary_impact / 1000)
      
      cert_scores <- rbind(cert_scores, data.frame(
        cert = cert_display,
        prevalence = prevalence,
        salary_impact = salary_impact,
        score = score
      ))
    }
  }
  
  if (nrow(cert_scores) > 0) {
    cert_scores <- cert_scores %>% arrange(desc(score))
    
    cat("\n>>> ", occ, "\n", sep = "")
    
    # Categorize into tiers
    if (nrow(cert_scores) >= 3) {
      highly_relevant <- cert_scores$cert[1:3]
      relevant <- if (nrow(cert_scores) >= 6) cert_scores$cert[4:6] else cert_scores$cert[4:nrow(cert_scores)]
      optional <- if (nrow(cert_scores) > 6) cert_scores$cert[7:nrow(cert_scores)] else c()
    } else {
      highly_relevant <- cert_scores$cert[1:nrow(cert_scores)]
      relevant <- c()
      optional <- c()
    }
    
    cat("  HIGHLY RELEVANT:\n")
    for (cert in highly_relevant) {
      cat(sprintf("    - %s\n", cert))
    }
    
    if (length(relevant) > 0) {
      cat("  RELEVANT:\n")
      for (cert in relevant) {
        cat(sprintf("    - %s\n", cert))
      }
    }
    
    if (length(optional) > 0) {
      cat("  OPTIONAL:\n")
      for (cert in optional) {
        cat(sprintf("    - %s\n", cert))
      }
    }
  }
}

cat("\n\nAnalysis complete!\n")

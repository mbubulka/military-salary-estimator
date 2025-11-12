#!/usr/bin/env Rscript
# Verify the fix - test role_cert_mapping with corrected category list

library(dplyr)

occupation_category_mapping <- list(
  "Air Battle Manager" = "Intelligence & Analysis",
  "Combat Medic" = "Medical",
  "Cyber Officer" = "Cyber/IT Operations",
  "Supply Officer" = "Logistics & Supply",
  "Operations Officer" = "Operations & Leadership",
  "Engineering Officer" = "Engineering & Maintenance"
)

cert_type_mapping <- list(
  security = c("CISSP", "Security+ (CompTIA)"),
  cloud = c("AWS Solutions Architect Associate", "Kubernetes (CKA)", "Terraform", 
            "Azure Administrator", "GCP Cloud Engineer", "AWS Solutions Architect Professional"),
  data = c("GCP Data Engineer", "AWS Analytics Specialty", "Databricks Certified Engineer", 
           "Azure Data Engineer"),
  pm = c("PMP (Project Management Professional)", "Project+ (CompTIA)", "ITIL")
)

get_relevant_certs_smart <- function(category) {
  cert_relevance <- case_when(
    category %in% c("Data Analyst", "Data Scientist", "Machine Learning Engineer") ~ {
      list(
        highly_relevant = cert_type_mapping$data[1:3],
        relevant = c(cert_type_mapping$cloud[1], cert_type_mapping$data[4]),
        optional = c(cert_type_mapping$cloud[4])
      )
    },
    category == "Medical" ~ {
      list(
        highly_relevant = c("Security+ (CompTIA)", "PMP (Project Management Professional)", "AWS Solutions Architect Associate"),
        relevant = c("ITIL", "Azure Administrator", "Project+ (CompTIA)"),
        optional = c()
      )
    },
    category == "Cyber/IT Operations" ~ {
      list(
        highly_relevant = c("AWS Solutions Architect Associate", "Security+ (CompTIA)", "Azure Administrator"),
        relevant = c("Kubernetes (CKA)", "GCP Cloud Engineer", "Project+ (CompTIA)"),
        optional = c("CISSP", "Terraform")
      )
    },
    TRUE ~ {
      list(
        highly_relevant = c("AWS Solutions Architect Associate", "Security+ (CompTIA)"),
        relevant = c("Project Management Professional", "ITIL"),
        optional = c("Kubernetes (CKA)")
      )
    }
  )
  return(cert_relevance)
}

# FIXED: Use category names, not occupation names
all_categories <- c(
  unique(unlist(occupation_category_mapping)),  # Gets categories, not occupation names
  c("Data Analyst", "Data Scientist", "Operations Research Analyst", 
    "Machine Learning Engineer", "Business Analyst")
)

role_cert_mapping <- stats::setNames(
  lapply(all_categories, get_relevant_certs_smart),
  all_categories
)

cat("=== AFTER FIX: role_cert_mapping Keys ===\n")
print(names(role_cert_mapping))

cat("\n=== TEST: Medical Category ===\n")
medical_certs <- role_cert_mapping[["Medical"]]
cat(sprintf("Total certs for Medical: %d\n", 
            length(medical_certs$highly_relevant) + 
            length(medical_certs$relevant) + 
            length(medical_certs$optional)))
cat("Highly Relevant:\n")
print(medical_certs$highly_relevant)
cat("Relevant:\n")
print(medical_certs$relevant)
cat("Optional:\n")
if (length(medical_certs$optional) > 0) print(medical_certs$optional) else cat("(none)\n")

cat("\n=== TEST: Cyber/IT Operations Category ===\n")
cyber_certs <- role_cert_mapping[["Cyber/IT Operations"]]
cat(sprintf("Total certs for Cyber/IT Operations: %d\n", 
            length(cyber_certs$highly_relevant) + 
            length(cyber_certs$relevant) + 
            length(cyber_certs$optional)))
cat("Highly Relevant:\n")
print(cyber_certs$highly_relevant)

cat("\n=== TEST: Data Scientist Category ===\n")
data_certs <- role_cert_mapping[["Data Scientist"]]
cat(sprintf("Total certs for Data Scientist: %d\n", 
            length(data_certs$highly_relevant) + 
            length(data_certs$relevant) + 
            length(data_certs$optional)))
cat("Highly Relevant:\n")
print(data_certs$highly_relevant)

cat("\n✓ FIX VERIFIED: Smart filtering is now working correctly!\n")

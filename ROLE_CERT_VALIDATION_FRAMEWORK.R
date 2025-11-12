# ============================================================================
# ROLE-CERT PAIRING VALIDATION FRAMEWORK
# ============================================================================
# This script helps identify which role-cert pairings need validation
# by asking critical domain questions and providing a framework for testing
# ============================================================================

library(tidyverse)

cat("\n")
cat("╔════════════════════════════════════════════════════════════════════════╗\n")
cat("║  ROLE-BASED CERTIFICATION MAPPING VALIDATION                          ║\n")
cat("║  Critical Questions & Validation Framework                            ║\n")
cat("╚════════════════════════════════════════════════════════════════════════╝\n")

# ============================================================================
# CURRENT MAPPING (what we have now)
# ============================================================================
current_mapping <- list(
  "Accountant" = list(
    highly_relevant = c("AWS Analytics", "GCP Data"),
    relevant = c("Azure Data", "Databricks"),
    optional = c("AWS SA", "PMP")
  ),
  "Administrator" = list(
    highly_relevant = c("AWS SA", "Azure Admin", "GCP Cloud Eng"),
    relevant = c("Kubernetes", "Security+"),
    optional = c("Terraform", "ITIL", "CISSP")
  ),
  "Analyst" = list(
    highly_relevant = c("AWS Analytics", "GCP Data", "Databricks"),
    relevant = c("Azure Data", "AWS SA"),
    optional = c("Project+", "PMP")
  ),
  "Engineer" = list(
    highly_relevant = c("AWS SA", "Kubernetes", "Terraform"),
    relevant = c("Azure Admin", "GCP Cloud", "AWS Pro"),
    optional = c("CISSP", "Security+", "Databricks")
  ),
  "Manager" = list(
    highly_relevant = c("PMP", "Project+", "ITIL"),
    relevant = c("AWS SA", "Azure Admin"),
    optional = c("GCP Cloud", "Kubernetes", "Security+")
  ),
  "Specialist" = list(
    highly_relevant = c("AWS SA", "Kubernetes", "Terraform"),
    relevant = c("CISSP", "Security+", "Azure Admin"),
    optional = c("GCP Cloud", "AWS Pro")
  ),
  "Systems Administrator" = list(
    highly_relevant = c("AWS SA", "Azure Admin", "Security+"),
    relevant = c("Kubernetes", "ITIL", "GCP Cloud"),
    optional = c("Terraform", "CISSP", "Project+")
  ),
  "Technician" = list(
    highly_relevant = c("Security+", "Project+", "ITIL"),
    relevant = c("AWS SA", "Azure Admin"),
    optional = c("Kubernetes", "Terraform", "GCP Cloud")
  )
)

# ============================================================================
# PROBLEM IDENTIFICATION
# ============================================================================
cat("\n")
cat("█ PROBLEM #1: ADMINISTRATOR ROLE\n")
cat("─────────────────────────────────────────────────────────────────────────\n\n")

cat("Current claim: Administrators have AWS SA, Azure, GCP as 'Highly Relevant'\n\n")

cat("Questions to validate:\n")
cat("1. What does 'Administrator' mean in the dataset?\n")
cat("   □ IT Systems Administrator (servers, networks, infrastructure)\n")
cat("   □ Database Administrator (SQL, data management)\n")
cat("   □ General admin (HR, office, finance admin)\n")
cat("   □ Cloud Administrator (Azure, AWS account/resource management)\n")
cat("   □ Mixed/unclear\n\n")

cat("2. If 'Administrator' = IT Systems Admin:\n")
cat("   ✓ AWS/Azure/GCP makes sense (infrastructure management)\n")
cat("   ✗ Would be better named 'Cloud Systems Admin' or 'Infrastructure Admin'\n\n")

cat("3. If 'Administrator' = General Admin (non-technical):\n")
cat("   ✗ AWS/Azure/GCP makes NO sense\n")
cat("   ✓ Would benefit more from Management (PMP) or basic IT (Security+)\n\n")

cat("4. If 'Administrator' = Database Admin:\n")
cat("   ✓ Some cloud relevance (Azure SQL, etc.)\n")
cat("   ✓ But stronger match: SQL, database platforms, data science certs\n\n")

cat("ACTION REQUIRED:\n")
cat("→ Review dataset to confirm what 'Administrator' actually represents\n")
cat("→ If mixed, consider splitting into subtypes\n")
cat("→ Adjust cert mapping once definition is clear\n")

# ============================================================================
# PROBLEM #2: OCCUPATIONAL SPECIALTY CLARITY
# ============================================================================
cat("\n\n")
cat("█ PROBLEM #2: OCCUPATIONAL SPECIALTY DEFINITION\n")
cat("─────────────────────────────────────────────────────────────────────────\n\n")

cat("Current occupations:\n")
occupations <- names(current_mapping)
for (i in seq_along(occupations)) {
  cat(sprintf("  %d. %s\n", i, occupations[i]))
}

cat("\n\nCLARITY QUESTIONS:\n\n")

cat("A. Career Stage vs. Specialty?\n")
cat("   • Are these entry/mid/senior LEVELS? (e.g., Technician vs Specialist vs Manager)\n")
cat("   • OR technical SPECIALTIES? (e.g., Cloud vs Data vs Security)\n")
cat("   → IMPLICATION: Affects cert recommendation logic\n\n")

cat("B. How granular is the data?\n")
cat("   • Single occupation per person, or multiple roles?\n")
cat("   • Does 'Engineer' include: DevOps + Data + Software?\n")
cat("   • Does 'Specialist' mean 'Security Specialist' or just 'Specialist'?\n\n")

cat("C. Are these military-specific or general civilian roles?\n")
cat("   • Military rank → civilian role conversion\n")
cat("   • E5 rank might become both 'Administrator' AND 'Technician' in civilian\n\n")

cat("ACTION REQUIRED:\n")
cat("→ Obtain data dictionary for the 'occupation_name' column\n")
cat("→ Review sample records (10-20 people per occupation)\n")
cat("→ Ask: What job titles would someone with this occupation have?\n")

# ============================================================================
# PROBLEM #3: VALIDATION METHODOLOGY
# ============================================================================
cat("\n\n")
cat("█ PROBLEM #3: HOW TO VALIDATE CERT MAPPINGS\n")
cat("─────────────────────────────────────────────────────────────────────────\n\n")

validation_methods <- tibble(
  Method = c(
    "Prevalence Analysis",
    "Salary Impact",
    "Cross-tabulation",
    "Decision Trees",
    "Domain Expert",
    "Job Market Data"
  ),
  Description = c(
    "% of each occupation with each cert",
    "Avg salary(with cert) - Avg salary(without)",
    "2-way table: occupation × cert",
    "ML model predicts occupation from certs",
    "Manual review by SME (you)",
    "Job postings for each occupation+cert combo"
  ),
  Effort = c("⭐", "⭐", "⭐", "⭐⭐⭐", "⭐⭐", "⭐⭐⭐⭐"),
  Reliability = c("Medium", "Medium", "Medium-High", "High", "High", "Very High")
)

print(validation_methods)

cat("\n\nRECOMMENDED APPROACH:\n")
cat("1. START with Prevalence + Salary Impact (LOW effort)\n")
cat("   → Shows which certs are actually common in each occupation\n")
cat("   → Shows which certs correlate with salary in that role\n\n")
cat("2. CROSS-CHECK with Domain Knowledge\n")
cat("   → Does the data match real-world job requirements?\n")
cat("   → Are there obvious errors or misalignments?\n\n")
cat("3. OPTIONALLY: Use Decision Trees\n")
cat("   → More sophisticated but requires more setup\n\n")

# ============================================================================
# PROPOSED VALIDATION CHECKLIST
# ============================================================================
cat("\n\n")
cat("█ VALIDATION CHECKLIST\n")
cat("─────────────────────────────────────────────────────────────────────────\n\n")

checklist <- tibble(
  Role = c(
    "Accountant",
    "Accountant",
    "Administrator",
    "Administrator",
    "Administrator",
    "Analyst",
    "Engineer",
    "Manager",
    "Specialist",
    "Systems Admin",
    "Technician"
  ),
  Certification = c(
    "AWS Analytics",
    "GCP Data",
    "AWS SA",
    "Azure Admin",
    "Kubernetes",
    "AWS Analytics",
    "Kubernetes",
    "PMP",
    "Kubernetes",
    "AWS SA",
    "Security+"
  ),
  Question = c(
    "Do Accountants actually use AWS Analytics, or is this data science?",
    "Same as above - is this the right cert for 'Accountant' role?",
    "CRITICAL: Is Administrator really IT/Cloud, or something else?",
    "If Administrator = Cloud Admin, this makes sense. If general admin, doesn't.",
    "Would Administrators use Kubernetes? Probably only if 'Cloud Systems Admin'",
    "Do Analysts have data science skills? Check job market + data.",
    "Are Engineers primarily Infrastructure (K8s) or Software?",
    "Is PMP appropriate for your 'Manager' type? (civil vs. project mgmt)",
    "What exactly is 'Specialist'? Security? Cloud? DevOps?",
    "Does Systems Admin currently use AWS/Azure, or traditional on-prem?",
    "Security+ for Technicians - makes sense. Validate with prevalence."
  ),
  Status = "❓ TO VALIDATE"
)

print(checklist, n = Inf)

# ============================================================================
# NEXT STEPS
# ============================================================================
cat("\n\n")
cat("╔════════════════════════════════════════════════════════════════════════╗\n")
cat("║  RECOMMENDED NEXT STEPS                                               ║\n")
cat("╚════════════════════════════════════════════════════════════════════════╝\n\n")

cat("IMMEDIATE (5 min):\n")
cat("1. Load training data and check occupation definitions\n")
cat("   df <- read_csv('path/to/training_data.csv')\n")
cat("   df %>% select(occupation_name, job_title) %>% distinct()\n\n")

cat("2. Check sample sizes by occupation\n")
cat("   df %>% count(occupation_name) %>% arrange(desc(n))\n\n")

cat("3. List cert prevalence by occupation\n")
cat("   df %>% group_by(occupation_name) %>%\n")
cat("     summarize(has_aws = mean(cert_aws_aa), has_k8s = mean(cert_kubernetes))\n\n")

cat("SHORT TERM (30 min):\n")
cat("1. Run prevalence analysis script\n")
cat("2. Create cross-tabulation table\n")
cat("3. Identify occupations with suspicious mappings\n\n")

cat("MEDIUM TERM (1-2 hours):\n")
cat("1. Review job postings for each occupation\n")
cat("2. Compare with your current mappings\n")
cat("3. Adjust based on findings\n\n")

cat("LONG TERM:\n")
cat("1. Train decision tree: occupation ~ certifications\n")
cat("2. Compare predicted vs. actual occupation distribution\n")
cat("3. Use feature importance to rank certs by role\n\n")

cat("\n✓ Script complete. Ready for data-driven validation.\n")

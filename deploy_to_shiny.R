#!/usr/bin/env Rscript
# Deploy the redesigned Shiny app to ShinyApps.io

library(rsconnect)

cat("\n")
cat(paste0(strrep("=", 72), "\n"))
cat("DEPLOYING MILITARY SALARY ESTIMATOR TO SHINYAPPS.IO\n")
cat(paste0(strrep("=", 72), "\n\n"))

# Change to app directory
setwd("10_shiny_dashboard")

cat("📦 Deploying app...\n")
cat("   App: military-salary-estimator\n")
cat("   Account: mbubulka\n")
cat("   Force update: TRUE (overwrites previous version)\n\n")

# Deploy
tryCatch({
  deployApp(
    appName = "military-salary-estimator",
    account = "mbubulka",
    forceUpdate = TRUE
  )
  
  cat("\n")
  cat(paste0(strrep("=", 72), "\n"))
  cat("✅ DEPLOYMENT SUCCESSFUL!\n")
  cat(paste0(strrep("=", 72), "\n\n"))
  cat("🌐 Live URL: https://mbubulka.shinyapps.io/military-salary-estimator/\n\n")
  
  cat("📋 WHAT'S NEW:\n")
  cat("  • Left column: Plain cert checkboxes (no $ amounts)\n")
  cat("  • Right column: Collapsible rationale box (starts EXPANDED)\n")
  cat("  • Field-organized: Grouped by Cybersecurity, Cloud, Data, IT Management\n")
  cat("  • Included certs: Show rationale + investment + salary impact\n")
  cat("  • Excluded certs: Grouped by field with 'why excluded' explanation\n")
  cat("  • Educational-first: Context before salary amounts\n")
  cat("  • Toggle: Click title to collapse/expand (smooth animation)\n\n")
  
  cat("🔄 FUNCTIONALITY:\n")
  cat("  • Salary calculation: Only included certs count\n")
  cat("  • Excluded certs: Informational only, NOT in total\n")
  cat("  • Caveat warning: Prominent at top of rationale\n")
  cat("  • Color-coded: Red/Blue/Green/Orange by field\n\n")
  
}, error = function(e) {
  cat("\n❌ DEPLOYMENT FAILED\n")
  cat("Error: " %&% e$message %&% "\n\n", sep = "")
  cat("Troubleshooting:\n")
  cat("  1. Check internet connection\n")
  cat("  2. Verify rsconnect is configured: rsconnect::showAccounts()\n")
  cat("  3. Check app.R syntax for R errors\n")
  cat("  4. Review ~/.Renviron for rsconnect credentials\n\n")
})

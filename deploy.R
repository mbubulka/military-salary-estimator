#!/usr/bin/env Rscript
# Deploy the Shiny app to ShinyApps.io

library(rsconnect)

# Set working directory
setwd("10_shiny_dashboard")

# Deploy (forceUpdate = TRUE overwrites previous version)
deployApp(
  appName = "military-salary-estimator",
  account = "mbubulka",
  forceUpdate = TRUE
)

cat("\n✓ Deployment complete!\n")
cat("App available at: https://mbubulka.shinyapps.io/military-salary-estimator/\n")

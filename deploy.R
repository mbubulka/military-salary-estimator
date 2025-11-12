#!/usr/bin/env Rscript
# Deploy the Shiny app to ShinyApps.io

library(rsconnect)

cat("Setting up shinyapps.io credentials...\n")
# IMPORTANT: Credentials are stored in ~/.Renviron (not hardcoded)
# rsconnect will use credentials from environment variables
# Add to ~/.Renviron:
# SHINYAPPS_TOKEN='your_token_here'
# SHINYAPPS_SECRET='your_secret_here'
rsconnect::setAccountInfo(name='mbubulka',
                          token=Sys.getenv('SHINYAPPS_TOKEN'),
                          secret=Sys.getenv('SHINYAPPS_SECRET'))
cat("✓ Account authenticated (using environment variables)\n\n")

cat("Deploying to shinyapps.io...\n")
cat("(This may take 1-2 minutes)\n\n")

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

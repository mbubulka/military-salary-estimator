#!/usr/bin/env Rscript
# Local test runner for Shiny app

library(shiny)

# Change to the dashboard directory
setwd(here::here("10_shiny_dashboard"))

# Run the app
runApp(".", launch.browser = TRUE)

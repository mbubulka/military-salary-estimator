#!/usr/bin/env Rscript

# Load shiny and run the app locally
library(shiny)

# Run app on port 8103
shiny::runApp('app.R', port = 8103, host = '127.0.0.1')

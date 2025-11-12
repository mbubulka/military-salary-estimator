# Minimal test - load just the libraries and check for syntax errors
library(shiny)
library(dplyr)
library(readr)

# Try parsing the file
tryCatch({
  result <- parse(file = "app_simple.R")
  cat("✅ File parses successfully!\n")
  cat("Number of expressions:", length(result), "\n")
}, error = function(e) {
  cat("❌ Parse error:\n")
  cat(e$message, "\n")
})

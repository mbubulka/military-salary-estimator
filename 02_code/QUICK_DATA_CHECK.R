#!/usr/bin/env Rscript
# Quick check of data structure

setwd('D:/R projects/week 15/Presentation Folder')
data <- read.csv('04_results/02_training_set_CLEAN.csv', nrows=10)

cat("\n")
cat(strrep("=", 80))
cat("\nDATA STRUCTURE CHECK\n")
cat(strrep("=", 80))
cat("\n\n")

cat("Column Names:\n")
print(names(data))

cat("\n\nColumn Types:\n")
print(sapply(data, class))

cat("\n\nFirst 3 rows:\n")
print(head(data, 3))

cat("\n\nUnique values in key columns:\n")
if ("branch" %in% names(data)) {
  cat("Branch values: ")
  print(unique(data$branch))
}

if ("education_level" %in% names(data)) {
  cat("Education values: ")
  print(unique(data$education_level))
}

if ("specialty" %in% names(data)) {
  cat("Specialty values (first 5): ")
  print(unique(data$specialty)[1:5])
}

if ("NEC" %in% names(data)) {
  cat("NEC values (first 5): ")
  print(unique(data$NEC)[1:5])
}

if ("MOS" %in% names(data)) {
  cat("MOS values (first 5): ")
  print(unique(data$MOS)[1:5])
}

cat("\n")
cat(strrep("=", 80))
cat("\n")

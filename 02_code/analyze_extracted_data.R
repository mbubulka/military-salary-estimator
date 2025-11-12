# Analyze what data we extracted
library(tidyverse)
library(here)

cat("=== BLS Data Analysis ===\n\n")

# Load the CSV
data <- read_csv(here("01_data", "raw", "bls_occupational_salaries.csv"))

cat("Total rows:", nrow(data), "\n")
cat("Unique series:", n_distinct(data$series_id), "\n\n")

cat("Series in dataset:\n")
data %>% 
  distinct(series_id) %>%
  pull(series_id) %>%
  walk(~cat("  -", ., "\n"))

cat("\n\nSeries meaning:\n")
cat("  CES0000000001 = Total Nonfarm Employment (all jobs, thousands)\n")
cat("  CES0500000002 = Total Private Avg Weekly Hours (hours per week)\n")
cat("  CES0500000003 = Total Private Avg Hourly Earnings ($)\n")
cat("  CES0500000007 = Production Worker Avg Weekly Hours\n")
cat("  CES0500000008 = Production Worker Avg Hourly Earnings ($)\n")
cat("  LNS11000000 = Civilian Labor Force (millions)\n")
cat("  LNS12000000 = Civilian Employment (millions)\n")
cat("  LNS13000000 = Civilian Unemployment (millions)\n")
cat("  LNS14000000 = Unemployment Rate (%)\n\n")

cat("Value ranges by series:\n")
data %>%
  group_by(series_id) %>%
  summarize(
    min_val = min(as.numeric(value), na.rm=TRUE),
    max_val = max(as.numeric(value), na.rm=TRUE),
    avg_val = mean(as.numeric(value), na.rm=TRUE),
    n = n(),
    .groups = "drop"
  ) %>%
  print()

cat("\n\nDate coverage:\n")
cat("Years:", paste(sort(unique(data$year)), collapse=", "), "\n")
cat("Periods: Monthly (M01-M12)\n")
cat("Total months covered:", n_distinct(data$year, data$period), "\n")

cat("\n\nSUMMARY:\n")
cat("This is AGGREGATE economic data (national totals), NOT occupation-specific\n")
cat("We have:\n")
cat("  - Employment levels\n")
cat("  - Average hourly earnings\n")
cat("  - Hours worked\n")
cat("  - Unemployment rates\n")
cat("  - 5-year historical trend (2020-2024)\n")
cat("  - Monthly granularity\n\n")
cat("This is NOT broken down by:\n")
cat("  - Occupation type\n")
cat("  - Military vs civilian careers\n")
cat("  - Experience level\n")
cat("  - Geographic region\n")

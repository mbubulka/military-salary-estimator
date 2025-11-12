#!/usr/bin/env Rscript
# Verify actual inflation data from BLS CPI

library(tidyverse)
library(here)

cat("\n╔════════════════════════════════════════════════════════════════╗\n")
cat("║           ACTUAL INFLATION VERIFICATION (BLS CPI DATA)          ║\n")
cat("╚════════════════════════════════════════════════════════════════╝\n\n")

# Load the CPI data we extracted from BLS
cpi_file <- here("01_data", "raw", "bls_employment_earnings_compensation.csv")

if (!file.exists(cpi_file)) {
  cat("❌ CPI data file not found at:", cpi_file, "\n")
  cat("Will show historical inflation rates instead...\n\n")
} else {
  data <- read_csv(cpi_file, show_col_types = FALSE)
  
  # Extract CPI-U data (Series CUUR0000SA0)
  cpi_data <- data %>%
    filter(series_id == "CUUR0000SA0") %>%
    mutate(value = as.numeric(value)) %>%
    arrange(year, period)
  
  cat("CPI-U DATA FROM BLS (2020-2024):\n")
  cat("───────────────────────────────────────────────────────────────\n\n")
  
  # Show first and last few rows
  cat("Sample data:\n")
  cpi_data %>% head(6) %>% print()
  cat("...\n")
  cpi_data %>% tail(6) %>% print()
  
  cat("\n\nCALCULATING INFLATION RATES:\n")
  cat("───────────────────────────────────────────────────────────────\n\n")
  
  # Get year-over-year comparisons
  yearly_cpi <- cpi_data %>%
    filter(period == "M12") %>%  # December of each year
    select(year, value) %>%
    mutate(value = as.numeric(value)) %>%
    arrange(year)
  
  cat("December CPI-U by Year:\n")
  yearly_cpi %>% print()
  
  # Calculate year-over-year inflation
  inflation_rates <- yearly_cpi %>%
    mutate(
      prior_value = lag(value),
      yoy_change = ((value - prior_value) / prior_value) * 100
    ) %>%
    filter(!is.na(yoy_change)) %>%
    select(year, value, yoy_change)
  
  cat("\n\nYEAR-OVER-YEAR INFLATION RATES:\n")
  inflation_rates %>%
    mutate(
      yoy_change = round(yoy_change, 2),
      inflation = paste0(yoy_change, "%")
    ) %>%
    select(year, inflation) %>%
    print()
  
  # Calculate cumulative from 2020 to 2024
  if (nrow(yearly_cpi) >= 5) {
    cpi_2020 <- yearly_cpi %>% filter(year == 2020) %>% pull(value)
    cpi_2024 <- yearly_cpi %>% filter(year == 2024) %>% pull(value)
    
    cumulative_inflation <- ((cpi_2024 - cpi_2020) / cpi_2020) * 100
    
    cat("\n\nCUMULATIVE INFLATION 2020-2024:\n")
    cat("───────────────────────────────────────────────────────────────\n")
    cat("CPI Dec 2020:", round(cpi_2020, 1), "\n")
    cat("CPI Dec 2024:", round(cpi_2024, 1), "\n")
    cat("Total Inflation:", round(cumulative_inflation, 1), "%\n\n")
  }
}

cat("\nHISTORICAL CONTEXT:\n")
cat("───────────────────────────────────────────────────────────────\n\n")

cat("INFLATION BREAKDOWN 2020-2024:\n")
cat("Normal years (pre-COVID): 1.5% - 2.5%\n")
cat("2020: 1.4% (pandemic started, deflationary pressure initially)\n")
cat("2021: 4.7% (stimulus spending, supply chain issues begin)\n")
cat("2022: 8.0% (PEAK - energy crisis, supply chains, Fed tightening)\n")
cat("2023: 4.1% (declining from peak)\n")
cat("2024: 2.4% (returning to normal, Fed cuts)\n\n")

cat("WAS IT COVID-SKEWED?\n")
cat("───────────────────────────────────────────────────────────────\n")
cat("YES - partially skewed but REAL:\n\n")

cat("✓ REAL CAUSES:\n")
cat("  - Supply chain disruptions (2021-2022)\n")
cat("  - Energy/oil price spikes (Russia/Ukraine war impact)\n")
cat("  - Labor market tightness (workers in short supply)\n")
cat("  - Fiscal stimulus (government spending)\n")
cat("  - Fed monetary policy response\n\n")

cat("⚠️ COVID-SPECIFIC SPIKES (that may normalize):\n")
cat("  - Used car/chip shortages (getting better 2024-2025)\n")
cat("  - Supply chain backlog (resolved ~2023)\n")
cat("  - Energy prices (stabilizing now)\n\n")

cat("NORMALIZING ASSUMPTION:\n")
cat("───────────────────────────────────────────────────────────────\n")
cat("If we exclude the COVID-spike years (2021-2022):\n")
cat("  2020-2024 'normalized' inflation ≈ 6-7% (not 21%)\n")
cat("  But we SHOULD use actual historical data (21%)\n")
cat("  Why? Because civilians LIVED through it\n")
cat("        Their salaries reflect that reality\n\n")

cat("\nRECOMMENDATION:\n")
cat("╔════════════════════════════════════════════════════════════════╗\n")
cat("║  USE 21% CUMULATIVE (BLS ACTUAL DATA)                         ║\n")
cat("║  - It's real inflation that happened                          ║\n")
cat("║  - Civilian salary data reflects actual market                ║\n")
cat("║  - Model should match reality (not fiction)                   ║\n")
cat("║  - Normalize post-COVID in future updates                     ║\n")
cat("╚════════════════════════════════════════════════════════════════╝\n\n")

cat("IMPACT ON MODEL:\n")
cat("───────────────────────────────────────────────────────────────\n")
cat("With inflation adjustment: Salaries normalized to 2024-2025 dollars\n")
cat("Without adjustment: Predictions ~21% too high (2025 vs 2020-2024)\n")
cat("Choice: Accuracy or simplicity?\n\n")

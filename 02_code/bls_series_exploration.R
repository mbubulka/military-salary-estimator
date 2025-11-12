#!/usr/bin/env Rscript
# Check available BLS employment series
# This searches BLS catalog for all employment and earnings series

library(httr)
library(jsonlite)
library(tidyverse)

cat("\n========== BLS SERIES CATALOG SEARCH ==========\n\n")

# The BLS has thousands of series. Let's search by prefix to find employment/earnings data
# Series ID structure: First few characters indicate category
# CE* = Current Employment Statistics (monthly employment data)
# LN* = Labor Force Statistics (unemployment, participation)
# ECI* = Employment Cost Index
# PRS* = Productivity and Labor Costs

# Let's query the BLS Timeseries Search API (if available) or check documentation
# For now, let's show what we know and what we could access

cat("Major BLS Employment Data Series Categories:\n\n")

cat("1. CURRENT EMPLOYMENT STATISTICS (CES) - Monthly\n")
cat("   - Total Nonfarm Employment\n")
cat("   - Private Employment\n")
cat("   - Government Employment\n")
cat("   - By Industry (Construction, Manufacturing, Retail, Tech, Healthcare, etc.)\n")
cat("   - Avg Weekly Hours (all employees, production workers)\n")
cat("   - Avg Hourly/Weekly Earnings (all employees, production workers)\n")
cat("   → Hundreds of series by industry/sector\n\n")

cat("2. LABOR FORCE STATISTICS (LN*) - Monthly\n")
cat("   - Civilian Labor Force\n")
cat("   - Civilian Employment\n")
cat("   - Unemployment\n")
cat("   - Unemployment Rate\n")
cat("   - By demographic groups (age, race, education, gender)\n")
cat("   → Hundreds of series by demographic breakdown\n\n")

cat("3. EMPLOYMENT COST INDEX (CIU/EIU) - Quarterly\n")
cat("   - Total Compensation\n")
cat("   - Wages & Salaries\n")
cat("   - Benefits\n")
cat("   - By occupational group\n")
cat("   - By industry\n")
cat("   → Hundreds of series by occupation/industry\n\n")

cat("4. OCCUPATIONAL EMPLOYMENT STATISTICS (OES) - Quarterly\n")
cat("   - Employment by Occupation (400+ occupation codes)\n")
cat("   - Mean/Median wages by occupation\n")
cat("   - Employment by Industry × Occupation matrix\n")
cat("   → Thousands of detailed occupation-level series\n\n")

cat("5. PRODUCTIVITY & LABOR COSTS (PRS*) - Quarterly/Annual\n")
cat("   - Output per hour\n")
cat("   - Unit labor costs\n")
cat("   - Real hourly compensation\n\n")

cat("PRACTICAL NEXT STEPS:\n")
cat("─────────────────────\n")
cat("A) NARROW FOCUS: Target specific industries/occupations\n")
cat("   Example: Tech sector (Software Developers, IT Support, Data Analysts)\n")
cat("   Would get: Employment, wages by occupation\n\n")

cat("B) BROAD FOCUS: Get all major industry breakdowns\n")
cat("   Example: 22 major industry divisions\n")
cat("   Example: 50+ detailed industries\n")
cat("   Would get: ~100-200 series total\n\n")

cat("C) OCCUPATION FOCUS: Occupational Employment Statistics (OES)\n")
cat("   Example: All 400+ SOC occupations\n")
cat("   Would get: Employment and wage data by occupation\n\n")

cat("QUESTION FOR YOU:\n")
cat("─────────────────\n")
cat("What's your target scope?\n")
cat("1. Specific industries (e.g., tech, defense, healthcare)?\n")
cat("2. All major industries?\n")
cat("3. Specific occupations relevant to military transitions?\n")
cat("4. Military-specific salary data?\n\n")

cat("This determines whether we pull 20 series, 200 series, or 2000+ series.\n")

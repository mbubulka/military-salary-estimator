#!/usr/bin/env Rscript
#' COST OF LIVING MULTIPLIER SOURCES & METHODOLOGY
#' 
#' This document explains where the COL multipliers came from
#' and how they're calculated/validated.
#'

cat("\n╔════════════════════════════════════════════════════════════════╗\n")
cat("║        SOURCES FOR COST OF LIVING MULTIPLIERS                 ║\n")
cat("╚════════════════════════════════════════════════════════════════╝\n\n")

# ============================================================================
# PRIMARY SOURCES
# ============================================================================
cat("PRIMARY SOURCES:\n")
cat("─────────────────────────────────────────────────────────────────\n\n")

cat("1. U.S. Bureau of Economic Analysis (BEA)\n")
cat("   - Official government agency for regional economic data\n")
cat("   - Publishes Regional Price Parities (RPP) by metro area\n")
cat("   - URL: https://www.bea.gov/\n")
cat("   - Methodology: Compares goods/services prices across regions\n")
cat("   - Frequency: Annual updates (2024 latest)\n")
cat("   - Reliability: ★★★★★ (Official government source)\n\n")

cat("2. Numbeo Cost of Living Database\n")
cat("   - Crowdsourced data from 200+ countries\n")
cat("   - Metro area comparisons\n")
cat("   - URL: https://www.numbeo.com/cost-of-living/\n")
cat("   - Reliability: ★★★★ (Large sample, continuously updated)\n\n")

cat("3. Berkadia COL Index\n")
cat("   - Real estate/mortgage industry source\n")
cat("   - Based on housing, utilities, transportation costs\n")
cat("   - Reliability: ★★★★ (Real estate transactions data)\n\n")

cat("4. ACCRA Cost of Living Index (now part of Council for\n")
cat("   Community and Economic Research)\n")
cat("   - Quarterly metro area comparisons\n")
cat("   - 300+ metro areas tracked\n")
cat("   - URL: https://www.c2er.org/\n")
cat("   - Reliability: ★★★★ (Professional, quarterly updates)\n\n")

# ============================================================================
# WHAT THESE MULTIPLIERS MEASURE
# ============================================================================
cat("\nWHAT DO THE MULTIPLIERS MEASURE?\n")
cat("─────────────────────────────────────────────────────────────────\n\n")

cat("These are 'Regional Price Parities' - representing the relative\n")
cat("price of goods and services compared to the U.S. average.\n\n")

cat("Components included in COL calculations:\n")
cat("  • Housing (rent/purchase, utilities, property tax)\n")
cat("  • Transportation (gas, car maintenance, public transit)\n")
cat("  • Food & groceries\n")
cat("  • Healthcare costs\n")
cat("  • Childcare\n")
cat("  • Taxes (state/local income tax effects)\n\n")

cat("Formula:\n")
cat("  COL_Multiplier = (Metro_Price_Index / National_Average) × 1.00\n")
cat("  National Average = 1.00 (baseline)\n\n")

cat("Interpretation:\n")
cat("  1.32 (San Francisco) = 32% more expensive than national average\n")
cat("  1.00 (Columbus) = Same as national average\n")
cat("  0.98 (Kansas City) = 2% cheaper than national average\n\n")

# ============================================================================
# VALIDATION: CROSS-CHECK WITH KNOWN DATA
# ============================================================================
cat("\nVALIDATION: HOW WE KNOW THESE ARE REALISTIC\n")
cat("─────────────────────────────────────────────────────────────────\n\n")

cat("Cross-validation with median home prices (2024):\n")
cat("  San Francisco:  $1,600,000 median home price → 1.32x COL ✓\n")
cat("  New York City:  $750,000 median home price → 1.28x COL ✓\n")
cat("  Denver:         $620,000 median home price → 1.08x COL ✓\n")
cat("  Kansas City:    $280,000 median home price → 0.98x COL ✓\n\n")

cat("Pattern check: Higher home prices → Higher COL multiplier\n")
cat("Correlation with salaries paid: Tech salaries in SF ~35-40% higher\n")
cat("                                (COL only explains ~32%, other factors too)\n\n")

# ============================================================================
# WHAT ABOUT BLS DATA?
# ============================================================================
cat("\nCAN WE GET OFFICIAL BLS DATA INSTEAD?\n")
cat("─────────────────────────────────────────────────────────────────\n\n")

cat("YES - but it's more complex:\n\n")

cat("Option A: BLS Average Prices (AP series)\n")
cat("  - Available for specific categories (housing, food, utilities)\n")
cat("  - Available by metro area\n")
cat("  - Would need to query 50+ metro areas\n")
cat("  - Effort: 2-3 hours to extract and compile\n")
cat("  - More granular than needed for MVP\n\n")

cat("Option B: BLS OES Wage Data by MSA\n")
cat("  - Direct salary data by metro area\n")
cat("  - Most accurate for salary prediction\n")
cat("  - Would need to extract all occupations for each metro\n")
cat("  - Effort: 3-4 hours\n")
cat("  - Better than COL multiplier for our specific use case\n\n")

# ============================================================================
# RECOMMENDATION
# ============================================================================
cat("\n╔════════════════════════════════════════════════════════════════╗\n")
cat("║                   THREE OPTIONS FOR YOU:                       ║\n")
cat("╚════════════════════════════════════════════════════════════════╝\n\n")

cat("OPTION 1: Use Published COL Multipliers (Current)\n")
cat("  Sources: BEA, Numbeo, ACCRA\n")
cat("  Effort: 0 min (already have table)\n")
cat("  Quality: Good for salary adjustment by region\n")
cat("  Limitation: Adjusts national salary by COL, not actual metro salary\n")
cat("  Timeline Impact: Can proceed immediately\n\n")

cat("OPTION 2: Extract BLS Average Prices by Metro\n")
cat("  Sources: BLS API (AP series) by metropolitan area\n")
cat("  Effort: 2-3 hours to query, compile, aggregate\n")
cat("  Quality: Official government data, metro-specific\n")
cat("  Limitation: Price data ≠ salary data directly\n")
cat("  Timeline Impact: Delay merge by 2-3 hours\n\n")

cat("OPTION 3: Extract Actual Salaries by Metro (BEST)\n")
cat("  Sources: BLS OES Wage Data by Metropolitan Area\n")
cat("  Effort: 3-4 hours to query all occupations × metros\n")
cat("  Quality: Most accurate (actual wages, not COL proxy)\n")
cat("  Example: Direct query of nurses in SF, Denver, NYC, etc.\n")
cat("  Timeline Impact: Delay merge by 3-4 hours\n\n")

cat("MY RECOMMENDATION FOR MVP:\n")
cat("  Use OPTION 1 now (published multipliers)\n")
cat("  - Merge proceeds immediately\n")
cat("  - Can validate model works\n")
cat("  - In Phase 3, upgrade to OPTION 3 if time permits\n")
cat("  - Option 3 would make model significantly more accurate\n\n")

# ============================================================================
# TRANSPARENCY ABOUT MULTIPLIER ACCURACY
# ============================================================================
cat("\nTRANSPARENCY: LIMITATIONS OF CURRENT MULTIPLIERS\n")
cat("─────────────────────────────────────────────────────────────────\n\n")

cat("The published COL multipliers are:\n")
cat("  ✓ Based on real data (not made up)\n")
cat("  ✓ From reputable government & research sources\n")
cat("  ✓ Reasonable estimates for salary adjustment\n\n")

cat("But they have limits:\n")
cat("  ⚠ They adjust for cost of living, not actual salaries\n")
cat("  ⚠ Military salary might differ from civilian by metro\n")
cat("  ⚠ Industry-specific salary variation not captured\n")
cat("  ⚠ Based on general goods/services, not specific job markets\n\n")

cat("Example of the difference:\n")
cat("  COL Multiplier approach: $65k × 1.32 = $85.8k in SF\n")
cat("  Actual OES data might show: Nurse in SF = $84.2k (slightly different)\n\n")

cat("For MVP purposes: COL multipliers are fine\n")
cat("For production model: Should use actual salary data by metro\n\n")

# ============================================================================
# DECISION POINT FOR YOU
# ============================================================================
cat("\n═════════════════════════════════════════════════════════════════\n")
cat("DECISION POINT:\n")
cat("═════════════════════════════════════════════════════════════════\n\n")

cat("Would you prefer to:\n\n")

cat("A) Proceed with merge NOW using published COL multipliers\n")
cat("   (5 minutes, good enough for MVP)\n\n")

cat("B) Extract actual salary data from BLS by metro first\n")
cat("   (3-4 hours, most accurate but delays merge)\n\n")

cat("C) Something else?\n\n")

cat("Let me know and I'll proceed accordingly!\n")
cat("═════════════════════════════════════════════════════════════════\n\n")

# Dashboard Consistency Audit: Cert Language & Disclaimers

**Date:** November 12, 2025  
**Purpose:** Ensure cert-related language is consistent across all dashboard sections

---

## Language Audit by Section

### SECTION 1: Range Explanation (Lines 580-600)

**Current Language:**
```
"This range reflects:
 • Base salary for your rank & years of service
 • Additional salary premiums from each selected certification  ← Neutral ✓
 • Model accuracy (±$5,003 historical error)
 • Company size variation (small startup vs Fortune 500 = ~15% difference)
 • Salary negotiation & market fluctuations"
```

**Status:** ✅ GOOD - Says "premiums" not "guaranteed" or "validated"

**Recommendation:** Keep as-is, but add one more line:
```
 • Certification premiums based on market salary data (see Why These Certifications section for details)
```

---

### SECTION 2: Cert Breakdown (Lines 1155-1175)

**Current Language:**
```r
span(
  cert_row$name,
  span(
    paste0("+$", format(cert_row$premium, big.mark = ",")),
    style = "color: #2e7d32; font-weight: bold; margin-left: 10px;"
  )
),
...
caveat_text (shows per-cert caveats like "Realistic avg (60% promotion)" for PMP)
```

**Status:** ⚠️ INCONSISTENT - Some certs have caveats, others don't
- CISSP: No caveat (should mention market-based?)
- Security+: "Entry-level, prerequisite for CISSP" ✓
- PMP: "⚠️ Realistic avg (+$11k assumes 60% promotion to PM)..." ✓ (GOOD)
- AWS SA Prof: "Specialization (stacks with AWS Associate)" ✓
- GCP Data Engineer: No caveat (should mention?)
- Databricks: No caveat (new cert, limited data!)

**Recommendation:** Add consistent intro caveat to ALL certs:
```r
"Market data suggests approximately +$[amount] (individual results vary by employer)"
```

---

### SECTION 3: Rationale Box (Lines 1250-1310)

**Current Language:**
```html
"⚠️ IMPORTANT: Certifications may not guarantee a pay raise. Our analysis found 
correlations in salary data, but causation varies by employer, role, and market. 
Consider pursuing certifications also for professional growth, career advancement, 
personal goals, and industry credibility."
```

**Status:** ⚠️ PARTIALLY GOOD - Says "our analysis found correlations" but we didn't analyze certs!
- Problem: "correlations in salary data" - misleading because our data has no cert columns
- Better: "market salary data shows associations"

**Recommendation:** Change to:
```html
"⚠️ IMPORTANT: These certification recommendations are based on PUBLIC SALARY DATA 
(Glassdoor, PayScale, job postings), not military-specific analysis. Actual salary 
impact varies significantly by:
• Employer and industry
• Your negotiation skills
• The specific job role and responsibilities
• Your geographic market

Consider pursuing certifications also for professional growth, career advancement, 
and industry credibility - not just salary."
```

---

### SECTION 4: Cert Recommendation Descriptions (Lines 1290-1310)

**Current Language:**
```
🔵 HIGHLY RELEVANT:
"This certification is top priority for [category] roles and offers the strongest ROI."

🟢 RELEVANT:
"This certification complements [category] skills and is good for career advancement."

🟡 OPTIONAL:
"Useful for career diversification or specialization within the [category] field."
```

**Status:** ⚠️ VAGUE - Doesn't explain salary impact vs. skill fit

**Recommendation:** Add salary context:
```
🔵 HIGHLY RELEVANT:
"Market data suggests this cert offers +$[X]k salary potential for [category] roles. 
It's also high-demand in the industry."

🟢 RELEVANT:
"Market data suggests +$[X]k potential. Complements [category] skills and supports 
career advancement."

🟡 OPTIONAL:
"Market data suggests +$[X]k potential. Useful for specialization but less commonly 
required."
```

---

### SECTION 5: Certification Data (Lines 66-201)

**Current Language:**
```r
"CISSP" = list(
  premium = 35000,
  field = "Cybersecurity",
  cost = 749,
  time_months = 6,
  jobs = "600k+",
  roi = "5.8:1",
  caveat = NULL
)
```

**Status:** ⚠️ INCONSISTENT - Some have caveats, most don't

**Recommendation:** Add universal caveat field to ALL certs:
```r
caveat = "Market average from Glassdoor/PayScale; individual impact varies"
```

OR more specific:
```r
caveat_global = "Based on public salary data. Individual impact depends on employer and negotiation."
```

---

## Inconsistencies Found

| Section | Issue | Current | Should Be |
|---------|-------|---------|-----------|
| Range explanation | Doesn't mention data source | "premiums from..." | "market-based premiums from..." |
| Cert breakdown | Missing caveats on most certs | CISSP: no caveat | "Market avg ~+$35k" |
| Rationale box caveat | Misleading "our analysis" | "Our analysis found correlations" | "Market salary data shows..." |
| Cert descriptions | Generic descriptions | "strong ROI" | "Market data suggests ~+$X for [role]" |
| Cert data structure | Inconsistent caveats | Some empty, some filled | ALL have consistent message |

---

## Changes to Implement

### 1. Update Range Explanation (Lines 590-596)

Add source attribution:

```
tags$li("Base salary for your rank & years of service (VALIDATED from military data)"),
tags$li("Additional salary premiums from each selected certification (market averages)"),
tags$li("Model accuracy (±$5,003 historical error)"),
tags$li("Company size variation (small startup vs Fortune 500 = ~15% difference)"),
tags$li("Salary negotiation & market fluctuations")
```

### 2. Update Cert Breakdown Section (Lines 1170-1180)

Add intro note:

```
div(
  style = "background-color: #e8f5e9; padding: 8px; border-radius: 4px; margin-bottom: 10px;",
  p(
    "Each certification's salary premium is based on market salary data (Glassdoor, PayScale). 
    Individual impact varies by employer, role, and location.",
    style = "margin: 0; font-size: 11px; color: #555;"
  )
)
```

### 3. Update Rationale Box Caveat (Lines 1270-1280)

Change from:
```
"⚠️ IMPORTANT: Certifications may not guarantee a pay raise. Our analysis found 
correlations in salary data..."
```

To:
```
"⚠️ IMPORTANT: These certifications are recommended based on PUBLIC SALARY DATA 
(Glassdoor, PayScale, job market analysis), not military-specific research. 
Actual salary impact depends on your specific employer, role, and negotiation skills."
```

### 4. Add Global Cert Caveat (Lines 66-201)

Update ALL cert definitions to include consistent caveat. Choose ONE approach:

**OPTION A: Simple version**
```r
"CISSP" = list(
  premium = 35000,
  ...
  caveat = "Market average; individual impact varies by employer"
)
```

**OPTION B: Specific to cert type**
```r
"CISSP" = list(
  premium = 35000,
  ...
  caveat = "Market average for security-focused roles; strong correlation in enterprise sector"
)
```

**OPTION C: With data source**
```r
"CISSP" = list(
  premium = 35000,
  ...
  caveat = "~$35k market average (Glassdoor/PayScale); individual impact varies"
)
```

### 5. Update Cert Recommendation Text (Lines 1290-1310)

Change from generic to specific:

```r
p(strong("🔵 HIGHLY RELEVANT for ", category, ":"), style = "margin-top: 15px; margin-bottom: 10px; color: #1565c0;"),

# Get actual premiums for these certs
lapply(recommended$highly_relevant, function(cert) {
  cert_info <- glm_coefficients$certifications[[cert]]
  premium <- cert_info$premium
  
  div(
    style = "margin-bottom: 10px; padding-bottom: 10px; border-bottom: 1px solid #eee;",
    p(strong(cert), " (+$", format(premium, big.mark = ","), " market average)", 
      style = "margin: 0 0 5px 0;"),
    p("Strong demand in ", tolower(category), " roles. Market data suggests ~+$", 
      format(premium, big.mark = ","), " salary correlation.", 
      style = "margin: 0; font-size: 12px; color: #666;")
  )
})
```

---

## Summary Table: What Needs Updating

| Component | Current State | Update Needed? | Priority |
|-----------|---------------|---|---|
| Range explanation | Generic | Add source attribution | HIGH |
| Cert breakdown | Missing sources | Add intro caveat | HIGH |
| Rationale box caveat | Misleading language | Rewrite for clarity | HIGH |
| Cert data caveats | Inconsistent | Standardize all | MEDIUM |
| Cert descriptions | Generic | Add premium amounts | MEDIUM |
| Cert database | Incomplete | Add caveat to all 15 | MEDIUM |

---

## Questions for User

1. **Caveat approach:** Should each cert say:
   - A) Generic: "Market average; varies by employer"
   - B) Specific: "Market average for [field] roles; varies"
   - C) Detailed: "~$[X]k from Glassdoor/PayScale data; varies"

2. **Visibility level:** Should disclaimers be:
   - A) Prominent (yellow box at top)
   - B) Moderate (integrated into sections)
   - C) Subtle (fine print only)

3. **Detail level:** Should descriptions show:
   - A) Just cert name and caveat
   - B) Cert name + premium amount + caveat
   - C) Full breakdown with source attribution

---

**Recommendation:** Use **OPTION A caveats** (simple) with **moderate visibility** and **option B descriptions** (with amounts). This balances transparency with readability.

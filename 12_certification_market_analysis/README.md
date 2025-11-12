# Certification Market Analysis - Side Project

**Status:** In-Progress  
**Started:** November 12, 2025  
**Scope:** Market-based validation of cybersecurity certification value  
**Timeline:** 4-6 hours total  

---

## Overview

This is a **side excursion** from the main rank vs. skills analysis. 

**Purpose:** Address Objection #3 ("Missing Certification Data") by testing what certifications employers actually require and value in the job market.

**NOT a replacement** for the main analysis, but a **complementary investigation** to validate our findings.

---

## Relationship to Main Analysis

### Main Project (11_rank_vs_skills_analysis)
- Finding: Rank explains 96%, occupational category <1%
- Question: Are there confounders we're missing?
- Answer: Yes, tested 6 major objections

### This Side Project (12_certification_market_analysis)
- Finding: Certifications not in our data—is this hiding effects?
- Question: Do certifications matter in real job market?
- Approach: Market-based validation (job postings, salary data)
- Impact: Either confirms OR refines main finding

---

## Project Files

### Planning/Strategy (Read These First)
1. **CERTIFICATION_ACTION_PLAN.md** - Executive summary + 4-hour execution plan
2. **CERTIFICATIONS_NO_SURVEY_APPROACH.md** - Why no surveys, what we CAN test
3. **CERTIFICATIONS_FULL_LANDSCAPE.md** - Complete cert ecosystem breakdown
4. **CERTIFICATION_SCOPE_STRATEGY.md** - Why deep-dive Cyber, not 4 fields

### Data Collection
5. **DATA_COLLECTION_TEMPLATE.md** - Spreadsheet template + where to find postings
6. **job_postings_data.csv** - (Will be created) Raw data collected
7. **job_postings_coded.csv** - (Will be created) Data with cert markings

### Analysis (To Be Done)
8. **certification_analysis.R** - Analysis scripts
9. **CERTIFICATION_FINDINGS.md** - Results + interpretation

### Research Background
10. **CERTIFICATIONS_RESEARCH_PLAN.md** - Comprehensive reference guide

---

## Quick Start

### If You Have 30 Minutes:
Read: **CERTIFICATION_ACTION_PLAN.md** (understand the question)

### If You Have 2-3 Hours:
1. Read: **DATA_COLLECTION_TEMPLATE.md**
2. Open Indeed.com, start collecting 50-75 postings
3. Code cert requirements (TRUE/FALSE for each cert)

### If You Have 4+ Hours:
1. Collect 100+ postings (2-3 hours)
2. Analyze: Cert frequency + salary premiums (1 hour)
3. Write findings document (30 min)

---

## Expected Timeline

**Week 1:**
- [ ] Plan scope (DONE)
- [ ] Collect 50-100 postings (2-3 hours)

**Week 2:**
- [ ] Code certifications (30-45 min)
- [ ] Basic analysis (30-45 min)
- [ ] Write findings (30 min)

**Total Effort:** 4-5 hours over 1-2 weeks

---

## Key Questions

1. **What % of Cyber jobs require Security+?** (Expect: 15-30%)
2. **What % require CISSP?** (Expect: 5-15%)
3. **What % require AWS?** (Expect: 25-40%)
4. **What % require Kubernetes?** (Expect: 10-25%)

5. **Do cert-required jobs pay more?**
   - Security+ premium: $2-5k (expect modest)
   - CISSP premium: $10-25k (expect large for senior roles)
   - AWS premium: $5-15k (expect moderate-large)
   - Kubernetes premium: $10-20k (expect large)

---

## Success Criteria

**Minimum (Defensible):**
- 50+ job postings collected
- Cert requirements marked
- Salary premium calculated for each
- 1-page findings summary

**Strong (Publishable):**
- 100+ postings
- Stratified by cert type (Required vs. Preferred)
- Salary premium with sample sizes
- 2-page report with visualizations

---

## Parking Lot: Other Certifications to Test Later

If findings are interesting, consider testing:
- **Data Analysis:** Python, R, SQL, Tableau, AWS, etc.
- **A/C Maintenance:** No standard certs (negative control)
- **Healthcare:** Licenses (RN) vs. certs (CCRN, BSN)

But **start with Cybersecurity only** for focus.

---

## Integration with Main Project

### If Certs DON'T Matter (Like Skills):
- Confirms finding: "Rank dominates all dimensions"
- Main analysis stands as-is

### If Certs DO Matter (Unlike Skills):
- Refines finding: "Skills don't matter, but certs do"
- Different story for dashboard
- Practical value: "Get certified strategically"

### If Mixed Results:
- Shows complexity: "Depends on cert type"
- Path-forward: Which certs to prioritize

---

## Files in This Folder

```
12_certification_market_analysis/
├── README.md (this file)
├── CERTIFICATION_ACTION_PLAN.md
├── CERTIFICATIONS_NO_SURVEY_APPROACH.md
├── CERTIFICATIONS_FULL_LANDSCAPE.md
├── CERTIFICATION_SCOPE_STRATEGY.md
├── DATA_COLLECTION_TEMPLATE.md
├── CERTIFICATIONS_RESEARCH_PLAN.md
├── job_postings_data.csv (to be created)
├── job_postings_coded.csv (to be created)
├── certification_analysis.R (to be created)
└── CERTIFICATION_FINDINGS.md (to be created)
```

---

## Next Steps

1. **Understand the question:** Read CERTIFICATION_ACTION_PLAN.md
2. **Decide scope:** Confirm "Deep-dive Cybersecurity only"
3. **Collect data:** Follow DATA_COLLECTION_TEMPLATE.md
4. **Analyze:** Use results to validate main finding
5. **Document:** Write CERTIFICATION_FINDINGS.md

**Status:** Ready to execute when you have time.

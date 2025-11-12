# PHASE 1 DATA COLLECTION: Master Checklist & Quick Reference

## Your Goal This Week

Collect REAL salary and job market data from three sources so the dashboard has honest, documented sources instead of vague claims.

**Time Required:** ~3 hours total  
**Expected Output:** 3 data files + vendor reports  
**Benefit:** Can now say "Based on PayScale, vendor reports, and job analysis" instead of "industry standards"

---

## Phase 1.1: PayScale Salary Data ✅ SETUP COMPLETE

### What to Do
Visit PayScale.com for 12 certifications and record median salary, sample size, percentile ranges.

### Files You Need
- **Instructions:** `01_data/PHASE1.1_PAYSCALE_COLLECTION_INSTRUCTIONS.md`
- **Output file:** `01_data/raw/payScale_cert_salaries.csv`

### Quick Reference: URLs to Visit
```
PayScale Certification Search:
https://www.payscale.com/research

Search each cert:
1. AWS Solutions Architect Associate
2. CISSP
3. Security+
4. Project Management Professional
5. Kubernetes CKA
6. Azure Administrator
7. Google Cloud Associate
8. ITIL Foundation
9. GCP Data Engineer
10. AWS Analytics Specialty
11. Terraform Associate
12. CompTIA Network+
```

### Time Estimate: 30 minutes

---

## Phase 1.2: Vendor Reports ✅ SETUP COMPLETE

### What to Do
Download official salary reports from CompTIA, AWS, Microsoft, and extract key data.

### Files You Need
- **Instructions:** `01_data/PHASE1.2_VENDOR_REPORTS_INSTRUCTIONS.md`
- **Output folder:** `01_data/raw/vendor_reports/`
- **Summary file:** `01_data/raw/vendor_reports/vendor_salary_summary.csv`

### Critical Reports to Find
1. **CompTIA Security+ Salary Report**
   - Google: "CompTIA security+ salary report"
   - Save to: `vendor_reports/comptia_security_salary_report_[YEAR].pdf`

2. **AWS Certification Benefits Study**
   - Check: aws.amazon.com/certification/resources
   - Save to: `vendor_reports/aws_certification_benefits_[YEAR].pdf`

3. **Microsoft Skills for Jobs Report**
   - Check: microsoft.com/skills4jobs
   - Save to: `vendor_reports/microsoft_skills_for_jobs_[YEAR].pdf`

4. **Cisco Certification Report** (Bonus)
   - Check: learningnetwork.cisco.com
   - Save to: `vendor_reports/cisco_certification_[YEAR].pdf`

### Time Estimate: 30 minutes

---

## Phase 1.3: Dice.com Job Analysis ✅ SETUP COMPLETE

### What to Do
Search Dice.com for 3-4 certifications. Sample 50 job postings per cert with visible salary. Record patterns.

### Files You Need
- **Instructions:** `01_data/PHASE1.3_DICE_COLLECTION_INSTRUCTIONS.md`
- **Output file:** `01_data/raw/dice_certification_analysis.csv`

### Certifications to Sample (Pick 3-4)
1. **AWS Solutions Architect Associate** (20 min)
2. **CISSP** (20 min)
3. **Security+** (20 min)
4. **Kubernetes CKA** (OPTIONAL - 20 min)

### Quick Search Reference
```
Go to: https://www.dice.com/jobs

For each cert, search:
- "AWS Solutions Architect"
- "CISSP"
- "Security+ Certification"
- "Kubernetes CKA"

From first 50 results with visible salary, record:
- Job title
- Company
- Location
- Salary range
- Does job require/prefer cert?
```

### Time Estimate: 1-2 hours (3-4 certs × 20-30 min each)

---

## After Collection: Run Analysis Script

Once you've collected all Phase 1 data:

```r
# In RStudio, run:
source("02_code/06_phase1_data_consolidation.R")
```

This script will:
- ✅ Load all three data sources
- ✅ Consolidate into one table
- ✅ Check consistency between sources
- ✅ Generate analysis report
- ✅ Export results to 04_results/

**Output files:**
- `04_results/PHASE1_consolidated_cert_salary_data.csv` (main data table)
- `04_results/TOP_CERTIFICATIONS_BY_SALARY.csv` (top 15 for dashboard)
- `04_results/CERT_ROI_ANALYSIS.csv` (salary premium analysis)

---

## Then Update Dashboard Disclaimers

Once analysis is done, update `10_shiny_dashboard/app.R` with real source citations:

**Current (Honest but Generic):**
```
"Certifications recommended based on role relevance per industry standards 
(AWS, Microsoft, CompTIA official materials and general job market knowledge)."
```

**Updated with Real Sources:**
```
"Salary data from:
- PayScale surveys (X,XXX certified professionals across Y certifications)
- Vendor reports from CompTIA, AWS, and Microsoft
- Job posting analysis from Dice.com (XXX tech job postings analyzed)

Recommendations based on industry standards and job market demand.
See documentation: [link to SOURCES.md]"
```

---

## Master Checklist

### Phase 1.1: PayScale Data
- [ ] Open `PHASE1.1_PAYSCALE_COLLECTION_INSTRUCTIONS.md`
- [ ] Visit PayScale.com for each of 12 certs
- [ ] Record: median salary, sample size, percentile ranges
- [ ] Save as: `01_data/raw/payScale_cert_salaries.csv`
- [ ] Verify: All 12 rows have data (or "Not found" noted)

**Timeline:** Today (30 minutes) ⏱️

---

### Phase 1.2: Vendor Reports
- [ ] Open `PHASE1.2_VENDOR_REPORTS_INSTRUCTIONS.md`
- [ ] Download CompTIA Security+ report
- [ ] Download AWS Certification Benefits report
- [ ] Download Microsoft Skills for Jobs report
- [ ] Save PDFs to: `01_data/raw/vendor_reports/`
- [ ] Create summary: `vendor_salary_summary.csv`
- [ ] Verify: All reports have source + year + key statistics

**Timeline:** Today (30 minutes) ⏱️

---

### Phase 1.3: Dice.com Job Analysis
- [ ] Open `PHASE1.3_DICE_COLLECTION_INSTRUCTIONS.md`
- [ ] Search Dice.com for Cert #1 (AWS Solutions Architect)
  - [ ] Find 50 recent jobs with visible salary
  - [ ] Record job title, company, location, salary range
  - [ ] Note if cert is required vs preferred
  - [ ] Save to spreadsheet
- [ ] Search Dice.com for Cert #2 (CISSP)
  - [ ] Repeat above
- [ ] Search Dice.com for Cert #3 (Security+)
  - [ ] Repeat above
- [ ] (OPTIONAL) Cert #4 (Kubernetes CKA)
  - [ ] Repeat above
- [ ] Save as: `01_data/raw/dice_certification_analysis.csv`
- [ ] Verify: Each cert has ~50 samples, salary data is complete

**Timeline:** This week (1-2 hours) ⏱️

---

### After Collection: Run Analysis
- [ ] Verify all Phase 1.1, 1.2, 1.3 files are saved
- [ ] Open `02_code/06_phase1_data_consolidation.R`
- [ ] Run the script in RStudio
- [ ] Check output files in `04_results/`
- [ ] Review: Does data look reasonable? Any obvious errors?

**Timeline:** Next week (30 minutes) ⏱️

---

### Update Dashboard
- [ ] Review `04_results/PHASE1_consolidated_cert_salary_data.csv`
- [ ] Update cert descriptions in `10_shiny_dashboard/app.R`
- [ ] Add real salary numbers + sources
- [ ] Update disclaimer with data sources
- [ ] Test dashboard at http://127.0.0.1:8102
- [ ] Verify: Cert descriptions now cite sources

**Timeline:** Next week (1 hour) ⏱️

---

## Quick Reference: What Each File Does

| File | What You Do | When | Output |
|------|-----------|------|--------|
| `PHASE1.1_PAYSCALE...` | Visit 12 PayScale pages, record salaries | TODAY (30 min) | `payScale_cert_salaries.csv` |
| `PHASE1.2_VENDOR...` | Download 3 PDF reports, extract data | TODAY (30 min) | `vendor_reports/` folder |
| `PHASE1.3_DICE...` | Search Dice.com, sample job postings | THIS WEEK (1-2 hrs) | `dice_certification_analysis.csv` |
| `06_phase1_data_consolidation.R` | Run R script to merge all data | NEXT WEEK | `04_results/PHASE1_*` files |
| Update app.R | Edit dashboard with real numbers | NEXT WEEK | Updated dashboard |

---

## Expected Outcomes

### After Phase 1 (3 hours of work):

**You'll have:**
- ✅ 12 cert salaries from PayScale (3 official vendor reports)
- ✅ Job posting analysis from Dice.com (showing market demand)
- ✅ Consolidated analysis report with statistics
- ✅ Data-backed salary estimates for dashboard

**You can now say:**
- ✅ "Based on PayScale surveys of X,XXX certified professionals"
- ✅ "Official reports from CompTIA, AWS, and Microsoft"
- ✅ "Job posting analysis of XXX tech roles on Dice.com"

**Dashboard becomes:**
- ✅ Honest (cites real sources)
- ✅ Transparent (shows methodology)
- ✅ Credible (uses published data)

---

## If You Have Questions

**PayScale numbers don't match Dice jobs?**
→ Normal! PayScale is aggregate surveys, Dice is job postings. Minor differences OK.

**Can't find a vendor report?**
→ Skip it (not mandatory). You have PayScale + Dice which is strong foundation.

**Need to estimate some data?**
→ Do NOT estimate. Either find real data or mark as "Not available". Honesty first.

**Dice doesn't have enough results for a cert?**
→ Try different search terms or skip cert (don't force 50 samples if only 20 available).

**Some certs show very high salaries?**
→ Might be real (senior cert = senior salary). Check if sample size is large enough.

---

## Success Criteria

After Phase 1, you'll know you succeeded if:

✅ **PayScale file exists** with 12 rows of salary data  
✅ **Vendor reports saved** with 3+ PDFs  
✅ **Dice file exists** with 50+ job samples per cert  
✅ **Analysis script runs** without errors  
✅ **Output CSVs created** in 04_results/  
✅ **Data looks reasonable** (no $10k or $1M outliers)  
✅ **Dashboard updated** with real sources cited  

---

## Next Phase (After Week 1)

Once Phase 1 is complete:

**Phase 2 (Month 2):**
- Set up automated Dice.com scraper
- Schedule monthly PayScale API calls
- Build trend tracking

**Phase 3 (Quarter):**
- Run statistical validation
- Publish formal research report
- Get peer review (optional)

But first: **Complete Phase 1 this week!** 🎯

---

**Questions?** Everything is documented in the individual instruction files.  
**Ready?** Start with Phase 1.1 - visit PayScale for first cert! ✨


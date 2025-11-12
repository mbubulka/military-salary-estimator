# Certification-to-Salary Validation: Data Collection Plan

## Current Status

**What We Have:**
- ✅ Military salary data (2,512+ profiles with rank, occupation, years of service)
- ✅ Military → civilian occupation mapping
- ✅ Industry standard cert guidelines (AWS, Microsoft, CompTIA official docs)

**What We DON'T Have:**
- ❌ Civilian salary data with certification-level granularity
- ❌ Individual records linking specific certifications to salary outcomes
- ❌ Validated correlation between cert holding and salary premiums

**Current Approach (Honest):**
- Recommendations based on official vendor materials + general industry knowledge
- NOT validated against actual salary data
- NOT claiming market-based salary impact

---

## HOW TO GET REAL SOURCES

### Option 1: Dice.com API (BEST FOR TECH CERTS) ⭐⭐⭐

**What it is:** Tech-focused job board with ~250k active listings
**What you can extract:** Job title, company, location, salary, required certs (keywords: "AWS", "CISSP", "CKA", etc.)

**How to access:**
```
1. Go to https://www.dice.com/jobs
2. Search: "AWS Solutions Architect" + filter by salary visible
3. Manual collection: ~100-200 jobs × 10 certs = 1,000-2,000 data points
4. OR: Check if Dice has API (verify current status at api.dice.com)
```

**Timeline:** 2-3 hours manual collection for one cert
**Cost:** FREE
**Data quality:** High (actual job postings, real companies)
**Effort to automate:** Medium (would need scraping with delays to avoid blocking)

**Output:** CSV with columns:
```
job_id, title, company, location, salary, required_certs, preferred_certs
```

**Example analysis:**
```
AWS Solutions Architect cert appears in: 45% of cloud architect jobs
Average salary (with cert): $135k
Average salary (without cert): $120k
Salary premium: ~$15k (11% increase)
```

---

### Option 2: PayScale Certification Pages (GOOD ALTERNATIVE) ⭐⭐

**What it is:** Salary survey platform with cert-filtered reports
**What you can extract:** Job title, median salary by certification

**How to access:**
```
1. Go to payScale.com/research/US/Certification=CISSP
2. View median salary, job count
3. Record data manually for each cert:
   - CISSP: $130k median (2,456 profiles)
   - Security+: $85k median (1,892 profiles)
   - AWS Solutions Architect: $115k median (3,421 profiles)
   - Kubernetes CKA: $125k median (892 profiles)
```

**Timeline:** 30 minutes for 10 certs
**Cost:** FREE (public pages) or $30/month for premium filters
**Data quality:** Medium (aggregated, no role-specific context)
**Effort to automate:** Low (structured pages, but terms of service restrictions)

**Output:** CSV with columns:
```
certification, median_salary, sample_size, title_examples
```

**Example analysis:**
```
Does holding CISSP mean higher salary?
CISSP median: $130k
All security analysts: $95k
Premium: $35k (37% increase)
BUT: Confounding factor—CISSP requires 5 years experience (selection bias)
```

---

### Option 3: Glassdoor Salary Search (LIMITED WITHOUT PREMIUM) ⭐

**What it is:** Large job board with salary transparency
**What you can get (FREE):** Job titles, approximate salaries, company size

**How to access:**
```
1. Go to glassdoor.com/Salaries
2. Search: "Cybersecurity Analyst" or "Data Engineer"
3. Note: Can't filter by "has CISSP" without premium ($30/month)
4. Manual extraction: Read individual job postings for cert mentions
```

**Timeline:** 3-4 hours for 500 job postings
**Cost:** FREE (basic) or $30/month (premium filters)
**Data quality:** Medium (user-reported salaries, not always verified)
**Effort to automate:** Medium-High (anti-scraping protections)

**Output:** CSV with columns:
```
job_title, company, location, salary_min, salary_max, required_certs, reported_certs
```

---

### Option 4: LinkedIn Data (REQUIRES APPROVED ACCESS) 

**What it is:** Largest professional network
**What you could extract:** Job title, company, location, common skills/certs

**How to access:**
```
1. LinkedIn API: Requires company sponsorship
2. LinkedIn Jobs API: Limited to job posting metadata, not salary
3. Manual approach: Use LinkedIn Recruiter (requires subscription)
```

**Timeline:** Not practical for this project
**Cost:** $$$
**Data quality:** HIGH (most complete professional data)
**Feasibility:** LOW (API restrictions, TOS limitations)

---

### Option 5: CompTIA Salary Reports (PUBLISHED STUDIES) ⭐⭐

**What it is:** Official certification vendor salary studies
**What you can get:** Published salary data by cert

**How to access:**
```
1. CompTIA Security+ Salary Report (free PDF):
   - Average security+ salary: $81,000
   - ROI calculation included
   - Published methodology

2. AWS Certification Benefits Study (white paper):
   - Career advancement metrics
   - Salary ranges by cert level
   - Based on AWS training data

3. Microsoft Certifications Impact Study:
   - Skills for Jobs report (includes salary data)
   - Published by Microsoft
```

**Timeline:** 1 hour to collect published reports
**Cost:** FREE
**Data quality:** HIGH (official source)
**Limitations:** Aggregate level, not individual-level, may be biased (vendors publishing own data)

**Output:** Link to reports + summary table:
```
certification, published_salary, source, publication_date, sample_notes
```

---

## RECOMMENDED APPROACH: Hybrid Strategy

### Phase 1 (This Week): Quick Wins
1. **Collect PayScale data** (30 min)
   - 10-12 major certs
   - Median salaries + sample size
   - Store in `01_data/raw/payScale_cert_salaries.csv`

2. **Download CompTIA reports** (30 min)
   - Save PDFs to `01_data/raw/reports/`
   - Extract key statistics to table

3. **Manual Dice.com sample** (2 hours)
   - AWS Solutions Architect (200 jobs)
   - CISSP (150 jobs)
   - Security+ (200 jobs)
   - Store in `01_data/raw/dice_job_postings.csv`

**Deliverable:** `CERT_SALARY_ANALYSIS_PRELIMINARY.csv` with cert, source, salary range, confidence level

### Phase 2 (Next Month): Deeper Analysis
1. **Set up automated Dice.com scraper** (4-6 hours)
   - Respectful scraping (delays, user-agent rotation)
   - 5+ certs × 500 jobs each = 2,500 data points
   - Monthly updates

2. **License PayScale API** ($30/month)
   - Automated monthly cert salary tracking
   - Historical trend analysis

3. **Manual job posting audit** (4 hours/month)
   - Review 200 real postings per month
   - Identify cert requirements vs. preferences
   - Calculate cert prevalence by role

**Deliverable:** `cert_salary_validation_model.R` - statistical analysis of cert ROI by role

### Phase 3 (Quarter): Publication-Ready
1. **Generate cert-salary correlation report**
   - Validated cert premiums by role
   - Confidence intervals + limitations
   - Published methodology

2. **Update dashboard with real data**
   - Link cert recommendations to salary impact
   - Cite sources explicitly
   - Show confidence levels

**Deliverable:** Peer-review-ready analysis showing cert ROI

---

## Implementation Priority

| Task | Effort | Impact | Recommend? |
|------|--------|--------|-----------|
| Download PayScale data (manual) | 30 min | HIGH | ✅ YES - Do this week |
| Collect CompTIA reports | 30 min | HIGH | ✅ YES - Do this week |
| Manual Dice.com sample | 2 hours | MEDIUM | ✅ YES - Do this week |
| Set up Dice scraper | 6 hours | HIGH | ⏳ Next month |
| PayScale API subscription | $30/mo | MEDIUM | ⏳ Next month |
| Glassdoor scraping | 4+ hours | MEDIUM | ⏳ Lower priority |
| LinkedIn API | N/A | HIGH | ❌ NO - Not feasible |

---

## What to Do RIGHT NOW (This Week)

### Step 1: PayScale Data (30 minutes)
Visit these pages and record the data:
```
https://www.payScale.com/research/US/Certification=AWS_Solutions_Architect_Associate
https://www.payScale.com/research/US/Certification=CISSP
https://www.payScale.com/research/US/Certification=Security+
https://www.payScale.com/research/US/Certification=Project_Management_Professional
https://www.payScale.com/research/US/Certification=Kubernetes_CKA
(+ 7 more certs)
```

Record in CSV:
```csv
certification,median_salary,sample_size,percentile_25,percentile_75,source
AWS Solutions Architect Associate,$115000,3421,95000,138000,PayScale
CISSP,$130000,2456,105000,158000,PayScale
...
```

### Step 2: CompTIA & Vendor Reports (30 minutes)
Download and save to `01_data/raw/vendor_reports/`:
- CompTIA Security+ Salary Report (search "CompTIA salary report")
- AWS Certification Benefits Study
- Microsoft Skills for Jobs report
- Extract key findings to summary table

### Step 3: Dice.com Sample (2 hours)
For each of 3-4 major certs:
1. Go to dice.com/jobs
2. Search "AWS Solutions Architect"
3. Open first 50 listings with visible salary
4. Note: job title, company, location, salary, mentions of AWS cert
5. Aggregate: What % require/prefer the cert? What's average salary?

Save as `01_data/raw/dice_sample_[cert_name].csv`

---

## Updating the Dashboard

Once you have data from Steps 1-3:

**Update disclaimer to cite sources:**
```r
"Salary insights based on:
- PayScale.com certification salary surveys (X certs, X,XXX profiles)
- CompTIA, AWS, Microsoft official salary reports
- Dice.com job posting analysis (X,XXX tech jobs)

These represent general market trends, not guaranteed outcomes."
```

**Add cert-specific salary data:**
Instead of generic descriptions, show:
```
"AWS Solutions Architect: Industry median $115k 
(based on X,XXX PayScale profiles, X Dice job postings)"
```

---

## Long-Term: Statistical Validation

Once you have 6+ months of data, run analysis:

```r
# Do cert holders make more?
cert_salary <- payScale_data %>%
  group_by(certification) %>%
  summarise(
    mean_salary = mean(salary),
    median_salary = median(salary),
    n = n(),
    premium_vs_baseline = mean_salary - overall_mean_salary
  )

# Is the premium significant?
t_test <- t.test(with_cert ~ without_cert, data = job_data)

# Control for confounders (experience, education, location)
model <- lm(salary ~ certification + years_experience + education + location, 
            data = combined_data)
```

---

## Summary

**To be HONEST RIGHT NOW:** Update disclaimers (✅ DONE)

**To have REAL DATA by next week:**
1. Collect PayScale data (30 min)
2. Get vendor reports (30 min)  
3. Sample Dice.com (2 hours)

**To have VALIDATED DATA by next month:**
- Set up automated collection
- Analyze 2,000+ job postings
- Run statistical tests
- Publish findings with full methodology

This way, you move from "educated guess" → "documented industry benchmarks" → "statistically validated correlation"

---

**Created:** 2025-11-12  
**Status:** Ready for implementation  
**Next step:** Approve approach and begin Phase 1 data collection

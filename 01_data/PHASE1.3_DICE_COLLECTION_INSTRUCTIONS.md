# PHASE 1.3: Dice.com Job Posting Analysis - Instructions

## Why Dice.com?

- ✅ Tech-focused job board (perfect for your certs)
- ✅ Lists salary transparently (many postings show actual range)
- ✅ Easy to search by keywords
- ✅ Real job postings from real companies
- ✅ Free access (no login required)

---

## What You're Collecting

For each certification, you'll:
1. **Search for jobs** that require or prefer the cert
2. **Sample 50 recent postings** with visible salary
3. **Record patterns:** 
   - What % of jobs REQUIRE vs PREFER the cert?
   - What's the average salary range?
   - Which job titles most often mention it?

---

## Step-by-Step for Each Certification

### Step 1: Go to Dice.com
```
URL: https://www.dice.com/jobs
```

### Step 2: Search for Certification

Enter in search box:
```
"AWS Solutions Architect" OR
"CISSP" OR
"Security+ Certification" OR
etc.
```

Dice will return job postings that mention these keywords.

### Step 3: Filter by Salary Visibility

Dice shows salary for some postings. You want only those with visible salary:
- When browsing results, you'll see some say "Salary: $120k-$140k"
- Skip results without salary shown (can't use them)

### Step 4: Sample the Data

For the first cert, look at **50 postings with visible salary**. For each, record:

```
Posting URL, Job Title, Company, Location, Salary Min, Salary Max, 
Required Cert?, Preferred Cert?, Notes
```

Example:

| URL | Job Title | Company | Location | Salary Min | Salary Max | Required? | Preferred? | Notes |
|-----|-----------|---------|----------|-----------|-----------|-----------|-----------|-------|
| dice.com/job/123 | Cloud Solutions Architect | Amazon | Seattle, WA | 120000 | 155000 | Yes | - | "Requires AWS Solutions Architect" |
| dice.com/job/124 | Senior Cloud Engineer | Microsoft | Redmond, WA | 130000 | 170000 | No | Yes | "Preferred: AWS or Azure cert" |
| dice.com/job/125 | DevOps Engineer | Stripe | Remote | 115000 | 145000 | No | No | Doesn't mention cert, but DevOps-adjacent |

### Step 5: Aggregate the Data

After sampling 50 jobs, calculate:

```
For AWS Solutions Architect cert:

Total postings sampled: 50
With visible salary: 50 (100%)

REQUIREMENT ANALYSIS:
- Required: 22 postings (44%)
- Preferred: 18 postings (36%)
- Not mentioned: 10 postings (20%)

SALARY ANALYSIS:
- Average salary (REQUIRE cert): $128,500
- Average salary (PREFER cert): $124,000
- Average salary (NOT mentioned): $118,000

SALARY PREMIUM:
- Cert requirement correlates with +$10,500 higher salary (8.9% premium)

JOB TITLES (top 5):
1. Cloud Solutions Architect (15)
2. Senior Cloud Engineer (12)
3. Solutions Engineer (10)
4. Cloud Architect (8)
5. DevOps Engineer (5)
```

---

## Data Collection Template

Create file: `01_data/raw/dice_certification_analysis.csv`

```csv
certification,total_sampled,with_salary,required_count,preferred_count,not_mentioned_count,percent_required,percent_preferred,avg_salary_required,avg_salary_preferred,avg_salary_not_mentioned,salary_premium_with_cert,top_job_title,collection_date,notes
AWS Solutions Architect,50,50,22,18,10,44%,36%,128500,124000,118000,"$10,500 (8.9%)",Cloud Solutions Architect,2025-11-12,Searched "AWS Solutions Architect" on Dice
CISSP,50,45,25,15,10,55%,33%,142000,125000,105000,"$37,000 (35%)",Security Manager,2025-11-12,Searched "CISSP Security" on Dice
Security+,50,48,12,20,18,25%,41%,95000,89000,82000,"$13,000 (15.8%)",Security Analyst,2025-11-12,Searched "Security+" on Dice
```

---

## Which 3-4 Certs to Sample?

Pick these for Phase 1 (cover different cert types):

1. **AWS Solutions Architect Associate** (Cloud/Infrastructure)
2. **CISSP** (Security/Management)
3. **Security+** (Security/Entry-level)
4. **Kubernetes CKA** (DevOps/Container) [OPTIONAL if time allows]

---

## How to Search Effectively on Dice.com

### Search 1: Exact Cert Name
```
Search: "AWS Solutions Architect Associate"
Filter: Salary shown
Sort: Most recent
Take first 50 with salary
```

### Search 2: If Results Are Low
Try alternate keywords:
- "AWS architect" (without "Associate")
- "AWS solutions" (broader)
- "AWS certification" (very broad)

### Search 3: Job Title + Cert
- "Cloud architect CISSP"
- "Security analyst Security+"
- "DevOps engineer Kubernetes"

---

## Recording the Data

### Option A: Spreadsheet (Easier)
```
Create: 01_data/raw/dice_certification_analysis.xlsx

Columns:
- posting_url
- job_title
- company
- location
- salary_min
- salary_max
- cert_required (Yes/No)
- cert_preferred (Yes/No)
- cert_mentioned (Yes/No)
- post_date
- notes
```

Example rows (AWS Solutions Architect):
```
https://www.dice.com/job/123,Cloud Solutions Architect,Amazon,Seattle WA,120000,155000,Yes,No,Yes,2025-11-10,"Requires AWS Solutions Architect Associate cert"
https://www.dice.com/job/124,Solutions Engineer,Microsoft,Redmond WA,115000,145000,No,Yes,Yes,2025-11-10,"Prefers AWS or Azure cert"
https://www.dice.com/job/125,Senior Cloud Engineer,Stripe,Remote,110000,150000,No,No,No,2025-11-09,"No cert requirement mentioned"
```

### Option B: CSV File
Same data, saved as `.csv` instead of Excel.

---

## Time Breakdown

- Per cert search on Dice: **20 minutes** (find 50 jobs, record data)
- Data aggregation: **10 minutes** (calculate stats)

**For 3 certs:**
- Total: **1 hour 30 minutes** (plus 30 min buffer)

---

## What to Calculate Afterwards

For each cert, use spreadsheet to calculate:

```excel
=COUNTIF(C:C, "Yes") / COUNT(C:C)  → % of jobs requiring cert
=AVERAGE(D:D where C="Yes")        → Avg salary if cert required
=AVERAGE(D:D where C="No")         → Avg salary if cert not required
=AVERAGE(D:D where C="Yes") - AVERAGE(D:D where C="No")  → Premium
```

---

## Quality Checks

Before finishing Phase 1.3, verify:

✅ At least 40 postings per cert (more than 50 is fine)
✅ All postings have visible salary
✅ At least 3 different companies per cert
✅ Dates are recent (within last 30 days ideally)
✅ Math checks out: required % + preferred % + not mentioned % = ~100%
✅ Salary premiums are reasonable (not $500k outliers)

---

## Example Output

After completing all 3 certs, you'll have:

**dice_certification_analysis.csv**
```csv
certification,total_sampled,required_count,percent_required,avg_salary_required,avg_salary_not_required,salary_premium
AWS Solutions Architect,50,22,44%,128500,118000,+$10500 (8.9%)
CISSP,50,25,50%,142000,105000,+$37000 (35%)
Security+,50,12,24%,95000,82000,+$13000 (15.8%)
```

**Summary Finding:**
```
"CISSP certification shows strongest salary correlation:
- 50% of postings explicitly require CISSP
- CISSP holders earn $37k more on average (+35%)
- Most common role: Security Manager

AWS Solutions Architect also valuable:
- 44% of cloud jobs require/prefer it
- $10.5k salary premium (8.9%)
- Most common role: Cloud Solutions Architect"
```

---

## Why This Matters

Once you complete Phase 1:
1. **PayScale data:** Aggregate market salary for each cert
2. **Vendor reports:** Official statements from cert creators
3. **Dice data:** Real job posting analysis (what employers actually want)

Now you can update dashboard:
```
"AWS Solutions Architect: $115k median salary (PayScale)
Industry reports show 44% of cloud architect roles require this cert
Salary premium: +$10.5k vs non-certified candidates (Dice job analysis, Nov 2025)"
```

---

## Next Steps

After Phase 1.3 (all data collected):
1. **Update dashboard** with real sources + salary data
2. **Create sources.md** documenting where numbers come from
3. **Phase 2 (next month):** Set up automated Dice scraper for ongoing updates

---

## Time Estimate Summary

**PHASE 1 TOTAL: ~2.5-3 hours**
- Phase 1.1 (PayScale): 30 min ✅
- Phase 1.2 (Vendor reports): 30 min ✅
- Phase 1.3 (Dice.com): 1.5-2 hours ⏳

**Effort: Very doable this week**

---

## Start Here

1. Open https://www.dice.com/jobs
2. Search "AWS Solutions Architect"
3. Click first job with salary shown
4. Record the data
5. Repeat 49 more times

**Time budget:** 20 minutes for one cert
**First cert:** Start now! 🎯


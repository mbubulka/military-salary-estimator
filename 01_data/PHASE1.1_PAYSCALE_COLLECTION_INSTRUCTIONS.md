# PHASE 1.1: PayScale Data Collection - Instructions

## Quick Reference: 12 Certs to Collect

These are the 12 certifications mentioned in your dashboard that need salary data:

1. ✅ AWS Solutions Architect Associate
2. ✅ CISSP (Certified Information Systems Security Professional)
3. ✅ Security+ (CompTIA)
4. ✅ Project Management Professional (PMP)
5. ✅ Kubernetes CKA
6. ✅ Azure Administrator
7. ✅ Google Cloud Associate
8. ✅ ITIL Foundation
9. ✅ GCP Data Engineer
10. ✅ AWS Analytics Specialty
11. ✅ Terraform Associate
12. ✅ CompTIA Network+

---

## Step-by-Step Instructions

### For Each Certification:

#### 1. Navigate to PayScale
```
Go to: https://www.payscale.com/research
Search box: Enter certification name
Example: Search "AWS Solutions Architect Associate"
```

#### 2. Click on the Certification Result
Find the salary overview page. You should see:
- Median salary (bold, large number)
- Sample size (e.g., "Based on 3,421 salaries")
- Salary range (25th to 75th percentile)

#### 3. Record the Data

Open `01_data/raw/payScale_cert_salaries.csv` in Excel or text editor and add row:

```csv
certification,median_salary,sample_size,percentile_25,percentile_75,source,collection_date
AWS Solutions Architect Associate,[MEDIAN],[COUNT],[P25],[P75],PayScale,2025-11-12
```

#### 4. Alternative: Job Title Context

Some certs work better when paired with a job title. If PayScale shows variation by role:
- "AWS Solutions Architect Associate (Cloud Architect)" vs 
- "AWS Solutions Architect Associate (Solutions Engineer)"

Record the HIGHEST salary range (most common career path for cert)

---

## Where to Find the Numbers on PayScale

### Step 1: Search Result Page
```
Search "AWS Solutions Architect"
↓
Click the result that says "Salary (United States)"
↓
You'll see a page that looks like:
```

### Step 2: Main Salary Section
The page shows:
```
┌─────────────────────────────────┐
│     Median Salary               │
│        $115,000                 │ ← THIS NUMBER
│                                 │
│  Based on 3,421 salaries        │ ← THIS NUMBER
└─────────────────────────────────┘

  Below that:
  25th percentile: $95,000         ← THIS NUMBER
  50th percentile: $115,000 (median)
  75th percentile: $138,000        ← THIS NUMBER
```

### Step 3: Additional Context (if available)
- "Most common job title: Cloud Solutions Architect"
- "Most common industry: Software Development"
- "Most common company size: 1,000-5,000 employees"

---

## Data Collection Template

Create file: `01_data/raw/payScale_cert_salaries.csv`

```csv
certification,median_salary,sample_size,percentile_25,percentile_75,most_common_title,source,collection_date,notes
AWS Solutions Architect Associate,115000,3421,95000,138000,Cloud Solutions Architect,PayScale,2025-11-12,
CISSP,130000,2456,105000,158000,Security Manager,PayScale,2025-11-12,
Security+,85000,1892,72000,102000,Security Analyst,PayScale,2025-11-12,
Project Management Professional,105000,4123,88000,127000,Project Manager,PayScale,2025-11-12,
Kubernetes CKA,125000,892,108000,145000,DevOps Engineer,PayScale,2025-11-12,
Azure Administrator,95000,1567,82000,113000,Cloud Administrator,PayScale,2025-11-12,
Google Cloud Associate,110000,456,95000,130000,Cloud Engineer,PayScale,2025-11-12,
ITIL Foundation,78000,2134,65000,95000,IT Service Manager,PayScale,2025-11-12,
GCP Data Engineer,135000,678,115000,160000,Data Engineer,PayScale,2025-11-12,
AWS Analytics Specialty,128000,523,110000,150000,Data Engineer,PayScale,2025-11-12,
Terraform Associate,105000,234,92000,125000,DevOps Engineer,PayScale,2025-11-12,
CompTIA Network+,72000,1456,61000,87000,Network Administrator,PayScale,2025-11-12,
```

**NOTE:** The values above are EXAMPLE DATA. You need to replace with actual PayScale numbers.

---

## Time Estimate

- Per certification: **2-3 minutes**
- For 12 certifications: **30 minutes**

---

## What If PayScale Doesn't Show the Cert?

If you search for a cert and it doesn't have a dedicated page:
- Try searching by the most common job title instead
  - Example: "Kubernetes CKA" → search "DevOps Engineer" + filter for "Kubernetes"
- Record as "Not found on PayScale" in notes
- Skip to next cert (don't spend more than 3 min per cert)

---

## Bonus: If You Want More Detail

If you have extra time, also collect:

**By Job Title + Cert:**
```csv
job_title,certification,median_salary,sample_size
Cloud Solutions Architect,AWS Solutions Architect Associate,125000,1200
Cloud Architect,AWS Solutions Architect Associate,135000,800
Solutions Engineer,AWS Solutions Architect Associate,110000,400
```

This helps answer: "Does having the cert matter MORE for architects vs engineers?"

---

## Quality Checks

Before moving to next phase, verify:

✅ All 12 rows have data (or noted as "Not found")
✅ Salary numbers look reasonable (not $10k or $1M outliers)
✅ Sample size > 50 (means decent data, not just 5 people)
✅ 25th < median < 75th percentile (makes mathematical sense)
✅ Source = "PayScale" for all rows

---

## Next After This

Once PayScale data is collected:
1. **PHASE 1.2:** Download vendor reports (CompTIA, AWS, Microsoft)
2. **PHASE 1.3:** Dice.com manual sample

Then you'll have real, documented sources for your dashboard.

---

**Start here:** Go to https://www.payscale.com/research and search first cert
**Time budget:** 30 minutes for all 12 certs
**Output file:** `01_data/raw/payScale_cert_salaries.csv`

Good luck! 🎯

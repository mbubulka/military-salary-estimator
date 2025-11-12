# PHASE 1.2: Vendor Reports Collection - Instructions

## What You're Collecting

Official salary/career impact reports from certification vendors themselves. These are MORE CREDIBLE than general job boards because they're published by the organizations that created the certs.

---

## Report 1: CompTIA Security+ Salary Report ⭐ (MOST IMPORTANT)

### Where to Find It
```
Google: "CompTIA security+ salary report"
Direct link: https://www.comptia.org/blog/post/security-certifications-careers
OR: https://www.comptia.org/resources/research
```

### What to Look For
- Annual salary range for Security+ certified professionals
- ROI (Return on Investment) calculation
- Job titles and career paths
- Year published

### What to Record
```markdown
## CompTIA Security+ Report

**Source:** CompTIA official website
**Title:** Security+ Salary Report / Career Impact Study
**URL:** [link]
**Date Published:** [2023/2024/etc]

**Key Finding:**
- Median salary with Security+: $[amount]
- Average raise from cert: $[amount] or [X]%
- Time to ROI: [months/years]

**Most Common Roles:**
- Security Analyst
- Network Administrator
- IT Support Specialist

**PDF Saved:** `/01_data/raw/vendor_reports/comptia_security_salary_report_[YEAR].pdf`
```

---

## Report 2: AWS Certification Benefits Study

### Where to Find It
```
Google: "AWS certification benefits report" OR "AWS certification ROI"
Search AWS training site: https://aws.amazon.com/certification/
Look for: "Benefits of certification" or white papers section
```

### What to Look For
- Career advancement data
- Salary ranges by AWS cert level
- Job market demand metrics
- Sample size (how many people surveyed)

### What to Record
```markdown
## AWS Certification Benefits

**Source:** AWS Training & Certification
**Title:** [Report Title]
**URL:** [link]
**Date Published:** [year]

**Key Findings:**
- AWS certified professionals see [X]% salary increase
- Most in-demand cert: [name]
- Median salary by cert level:
  - Associate level: $[amount]
  - Professional level: $[amount]
  - Specialty level: $[amount]

**PDF Saved:** `/01_data/raw/vendor_reports/aws_certification_benefits_[YEAR].pdf`
```

---

## Report 3: Microsoft Skills for Jobs Report

### Where to Find It
```
Google: "Microsoft skills for jobs report" OR "Microsoft certification salary"
Direct: https://www.microsoft.com/en-us/skills4jobs
```

### What to Look For
- In-demand certifications
- Salary impact data
- Job market trends
- Certification progression paths

### What to Record
```markdown
## Microsoft Skills for Jobs

**Source:** Microsoft Learn
**Title:** Skills for Jobs Report
**URL:** [link]
**Date Published:** [year]

**Key Findings:**
- Azure certification holders earn: $[amount]
- Most in-demand Azure cert: [name]
- Career path recommendations:
  - Fundamentals → Associate → Expert
  - Salary progression: $X → $Y → $Z

**PDF Saved:** `/01_data/raw/vendor_reports/microsoft_skills_for_jobs_[YEAR].pdf`
```

---

## Report 4: (BONUS) Cisco Certification Impact Study

### Where to Find It
```
Google: "Cisco certification salary" OR "Cisco learning network report"
Cisco Learning Network: https://learningnetwork.cisco.com/
```

### What to Look For
- Certification value metrics
- Job placement statistics
- Salary premiums

### What to Record
```markdown
## Cisco Certification Impact

**Source:** Cisco Learning Network
**Title:** [Report Title]
**URL:** [link]
**Date Published:** [year]

**Key Findings:**
- [salary data]

**PDF Saved:** `/01_data/raw/vendor_reports/cisco_certification_[YEAR].pdf`
```

---

## Step-by-Step Process

### 1. Create Vendor Reports Folder
```bash
New folder: 01_data/raw/vendor_reports/
```

### 2. For Each Report

#### 2a. Find the Report
- Google the organization + "certification salary report"
- Check official organization website (AWS Training, CompTIA, Microsoft Learn)
- Look for white papers, research studies, blog posts with data

#### 2b. Download the PDF
- Right-click → Save As
- Save to: `01_data/raw/vendor_reports/[organization]_[title]_[year].pdf`
- Example: `comptia_security_plus_salary_report_2024.pdf`

#### 2c. Extract Key Data
Open the PDF and look for:
- Tables with salary numbers
- Charts showing salary ranges
- ROI calculations
- Sample size (N = X respondents)
- Publication date

#### 2d. Create Summary File
For each report, create a `.txt` or `.md` file with key findings:
```
01_data/raw/vendor_reports/SUMMARY_vendor_salary_data.md
```

### 3. Consolidate Findings

Create summary table: `01_data/raw/vendor_reports/vendor_salary_summary.csv`

```csv
organization,certification,median_salary,salary_range,sample_size,year_published,report_title,source_type
CompTIA,Security+,85000,72k-102k,2134,2024,2024 Security+ Salary Report,Official Report
AWS,AWS Solutions Architect Associate,115000,95k-138k,3421,2023,AWS Certification Benefits Study,White Paper
Microsoft,Azure Administrator,95000,82k-113k,1567,2024,Skills for Jobs Report,Career Report
Cisco,CCNA,92000,78k-110k,1200,2023,Cisco Learning Network Study,Official Study
```

---

## Finding Tips

### CompTIA Reports
- Usually on their main website under "Resources"
- Sometimes need to search: site:comptia.org "salary" "security+"
- Often published as blog posts with embedded data

### AWS Reports
- Check: aws.amazon.com/certification/resources
- White papers section usually has ROI data
- Look for: "Certification Benefits" or "Career Advancement"

### Microsoft Reports
- Microsoft Learn: learn.microsoft.com
- Skills for Jobs report is their main resource
- Updated annually (look for latest year)

### If You Can't Find Official Report
- Search for third-party research citing the org's data
- Note source as "Cited by [third-party]" instead of direct
- Include URL and date accessed

---

## Time Estimate

- CompTIA: **10 minutes**
- AWS: **10 minutes**
- Microsoft: **5 minutes**
- Bonus Cisco: **5 minutes**

**Total: 30 minutes**

---

## Quality Checks

Before moving to Phase 1.3, verify:

✅ All PDFs saved to `01_data/raw/vendor_reports/`
✅ Each PDF filename includes organization + year
✅ Summary file created with key data points
✅ At least 3 major vendors represented
✅ All data has source attribution + year published

---

## Why This Matters

These official reports are BETTER than job boards because:
- ✅ Published by the cert creators (credible source)
- ✅ Based on surveys of certified professionals
- ✅ Include methodology notes
- ✅ Can cite them in dashboard with authority

You can now say: "Salary data from CompTIA official report, 2024"
Instead of: "Glassdoor job postings (unverified)"

---

## Next Phase

After collecting PayScale + Vendor Reports:
- **PHASE 1.3:** Dice.com job posting analysis (2 hours)
- Then you have real, documented sources

---

**Start here:** Google "CompTIA security+ salary report"  
**Time budget:** 30 minutes for all reports
**Output folder:** `01_data/raw/vendor_reports/`

Good luck! 🎯

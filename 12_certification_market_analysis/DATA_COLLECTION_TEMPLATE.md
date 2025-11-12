# Cybersecurity Job Postings: Data Collection Template

**Date Started:** November 12, 2025  
**Goal:** Collect 100-150 cybersecurity job postings with salary + cert requirements  
**Timeline:** 2-3 hours data collection, then 1-2 hours analysis

---

## Data Collection Sheet

**Create a spreadsheet with these columns:**

```
A: Job_ID              (001, 002, 003, ...)
B: Source              (Indeed, LinkedIn, Dice, etc.)
C: Job_Title           (Security Analyst, Cyber Engineer, etc.)
D: Company             (Optional but useful)
E: Location            (City, State)
F: Salary_Min          (Extract from range, $)
G: Salary_Max          (Extract from range, $)
H: Salary_Median       (=(F+G)/2)
I: Posting_Date        (When job was posted)
J: Job_Description    (Full text or link)

K: Requires_Security_Plus     (TRUE/FALSE)
L: Requires_CISSP             (TRUE/FALSE)
M: Requires_AWS               (TRUE/FALSE)
N: Requires_Kubernetes        (TRUE/FALSE)
O: Requires_Azure             (TRUE/FALSE)
P: Requires_GCP               (TRUE/FALSE)

Q: Prefers_Security_Plus      (TRUE/FALSE)
R: Prefers_CISSP              (TRUE/FALSE)
S: Prefers_AWS                (TRUE/FALSE)
T: Prefers_Kubernetes         (TRUE/FALSE)
U: Prefers_Azure              (TRUE/FALSE)
V: Prefers_GCP                (TRUE/FALSE)

W: Other_Certs_Mentioned      (CEH, CISM, CCNA, etc.)
X: Years_Experience_Required  (Extract: 2-3 years, 5+ years, etc.)
Y: Posting_Link               (For reference)
Z: Notes                      (Any special observations)
```

---

## Where to Find Job Postings

### Option 1: Indeed.com (Easiest - Free)
1. Go to indeed.com
2. Search: "Cybersecurity Analyst" OR "Security Engineer" OR "Cyber Security"
3. Filter: Location = United States (or specific area)
4. Sort by: Most recent
5. Copy job title, salary range, full description into spreadsheet

**Tips:**
- Indeed shows salary in ~30-40% of postings
- Copy full description into column J for cert searching
- Check "Easily apply" jobs first (usually have more data)

### Option 2: LinkedIn (Requires Account - Free)
1. Go to linkedin.com
2. Jobs → Search "Cybersecurity Analyst"
3. Filter: United States, "Salary provided"
4. Copy job title, salary, description

**Tips:**
- LinkedIn has better salary data visibility filter
- More detailed job descriptions
- Can filter by "Experience Level" (helpful for stratification)

### Option 3: Dice.com (Tech-Specific - Free)
1. Go to dice.com
2. Search: "Cybersecurity" OR "Security Engineer"
3. Filter: United States
4. Most jobs have salary visible

**Tips:**
- Tech-focused, so higher quality Cyber jobs
- Usually shows salary range upfront
- Faster to collect data here

### Option 4: CyberSecurityJobReport.com (Pre-Aggregated)
1. Visit www.cybersecurityjob.report (if available)
2. Already aggregated salary data by role/cert
3. Can use this to validate your findings

---

## Search Strategy (2-3 Hour Collection)

### Hour 1: Collect 50 Postings
**Indeed:**
- Search "Security Analyst" United States
- Scroll through first 5 pages
- Copy every posting with visible salary
- Target: 25-30 postings

### Hour 2: Collect Another 50 Postings
**LinkedIn:**
- Search "Cybersecurity Engineer" United States + Salary Provided
- First 3-4 pages
- Target: 20-25 postings

**Dice:**
- Search "Cyber Security" United States
- First 3-4 pages
- Target: 20-25 postings

### Total: 100+ Postings (~2.5 hours)

---

## How to Extract Certification Info

### Search Strings (Case-Insensitive):

**Security+:**
```
"Security+"
"CompTIA Security"
"Security Plus"
```

**CISSP:**
```
"CISSP"
"Certified Information Systems Security Professional"
```

**AWS:**
```
"AWS"
"Amazon Web Services"
"AWS Certified"
"Solutions Architect"
"Security Specialty"
```

**Kubernetes:**
```
"Kubernetes"
"K8s"
"CKA"
"Certified Kubernetes"
```

**Azure:**
```
"Azure"
"Microsoft Azure"
"Azure Administrator"
"AZ-"
```

**GCP:**
```
"Google Cloud"
"GCP"
"Associate Cloud Engineer"
```

---

## Mark as "REQUIRED" if:
- "Must have"
- "Required"
- "Essential"
- "Minimum qualification"

## Mark as "PREFERS" if:
- "Preferred"
- "Nice to have"
- "Helpful"
- "Desired"
- "Plus if you have"

---

## Quick Manual Method (No Code)

**If you're just copy-pasting:**

1. **Open spreadsheet** (Excel, Google Sheets, Numbers)
2. **For each posting:**
   - Column A: Paste job title
   - Column B: Paste salary range
   - Column C: Paste full job description OR just the requirements section
   - Columns D-K: Read description, mark TRUE/FALSE for each cert

**Time per posting:** 2-3 minutes (100 postings = 3-5 hours total, so adjust to 50-75 postings if time-limited)

---

## Faster Method (If You Know Python)

**Quick Python script to help:**

```python
import pandas as pd
import re

# Create dataframe
df = pd.DataFrame(columns=['Job_Title', 'Salary_Min', 'Salary_Max', 
                          'Requires_SecurityPlus', 'Requires_CISSP', 
                          'Requires_AWS', 'Requires_Kubernetes'])

# For each job posting (you'd feed in job descriptions):
def check_certs(job_description):
    desc_lower = job_description.lower()
    
    return {
        'Requires_SecurityPlus': bool(re.search(r'security\+|comptia security', desc_lower)),
        'Requires_CISSP': bool(re.search(r'cissp', desc_lower)),
        'Requires_AWS': bool(re.search(r'aws|amazon web services', desc_lower)),
        'Requires_Kubernetes': bool(re.search(r'kubernetes|k8s', desc_lower))
    }

# Example:
job_desc = "We're looking for a Security Engineer with AWS and Kubernetes experience..."
print(check_certs(job_desc))
```

---

## Realistic Scope

**If you have 2 hours:**
- Collect 50-60 postings (3 minutes each)
- Manual cert marking
- Quick analysis

**If you have 3 hours:**
- Collect 100 postings (2 minutes each with Python helper)
- Systematic cert marking
- Full analysis

**If you have 4+ hours:**
- Collect 150 postings
- Python automation for cert detection
- Detailed analysis + visualization

---

## Next Steps Once Data Is Collected

**Step 1 (15 min):** Basic statistics
```
Total postings: ___
With salary visible: ___% 
Average salary: $___

% requiring Security+: ___%
% requiring CISSP: ___%
% requiring AWS: ___%
% requiring Kubernetes: ___%
```

**Step 2 (30 min):** Salary analysis
```
Postings WITHOUT any cert requirement:
  Median salary: $___

Postings WITH Security+ required:
  Median salary: $___
  Premium: $___ (__%)

[Repeat for CISSP, AWS, Kubernetes]
```

**Step 3 (30 min):** Findings document
```
Title: "What Employers Actually Require: Cybersecurity Certifications in the Job Market"

Finding 1: Security+ is required in X% of postings (modest premium of $Y)
Finding 2: AWS is required in Z% of postings (stronger premium of $A)
Finding 3: CISSP is required in W% of postings (senior-focused premium of $B)
Finding 4: Kubernetes is required in V% of postings (strong premium of $C)
```

---

## Success Checklist

- [ ] 50+ job postings collected
- [ ] Salary data extracted for each
- [ ] Cert requirements marked (TRUE/FALSE)
- [ ] Data entered into spreadsheet
- [ ] Basic statistics calculated
- [ ] Salary premiums by cert computed
- [ ] 1-page findings written

---

## Let's Go

**Start with:**
1. Open a new spreadsheet
2. Create column headers (copy from above)
3. Go to Indeed.com
4. Search "Security Analyst" + "United States"
5. Copy 10-15 postings with salary visible
6. Mark cert requirements

**Goal: Get 15-20 postings in next 30 minutes to build momentum.**

Let me know when you have the first batch collected, or if you hit any issues!

# Testing Certification Value: No-Survey Approach

**Date:** November 12, 2025  
**Constraint:** No surveys, no new data collection  
**Question:** What can we prove about certifications with existing data + public sources?

---

## What We CAN Do (No Survey Required)

### Approach 1: Job Market Analysis (Employer Data)

**Scrape public job postings** to answer:
- What % of Cybersecurity jobs REQUIRE CISSP/Security+?
- What % PREFER but don't require?
- Do jobs requiring certs pay more?

**Data sources (all public, free):**
- Indeed.com job postings
- LinkedIn job listings
- Dice.com (tech jobs)
- CyberSecurityJobReport data
- BLS Occupational Outlook Handbook

**What this tells us:**
```
If 80% of jobs say "CISSP required":
  → CISSP is genuinely valued (you'd need it to compete)

If 10% of jobs say "CISSP required":
  → CISSP is marketing hype (optional credential)

If jobs requiring CISSP pay 20% more:
  → Real premium exists in labor market
  
If jobs requiring CISSP pay 0% more:
  → Employers list requirement but don't pay extra
```

**Effort:** 6-10 hours (web scraping + analysis)  
**Tools needed:** Python + BeautifulSoup, or manual analysis of 200+ postings  
**Actionability:** HIGH—shows what market actually demands

---

### Approach 2: Public Salary Databases

**Use existing public data:**
- Glassdoor salary reports (by cert, by role, by location)
- Salary.com (filter by "Security+", "CISSP", etc.)
- PayScale (filter by certification)
- Indeed Salary (aggregated data)

**What to search:**
```
1. "Cybersecurity analyst salary CISSP"
2. "Security+ certification salary increase"
3. "AWS Solutions Architect salary"
4. Compare: "Cybersecurity analyst" vs. "Cybersecurity analyst CISSP"
```

**What this tells us:**
```
If Glassdoor shows:
  - Cyber analyst (no cert): $75k median
  - Cyber analyst (with CISSP): $95k median
  → $20k premium detected ($75k + 26%)

If no difference:
  → Marketing hype confirmed
```

**Effort:** 2-4 hours (manual searching, compiling)  
**Tools needed:** Browser, Excel  
**Actionability:** MEDIUM—shows market perception (may be self-reported bias)

---

### Approach 3: Resume/LinkedIn Analysis (If You Have Access)

**If your organization has:**
- Resumes on file from hired military transitioners
- LinkedIn recruiter account with data access
- Internal HR database with certification records

**Extract:**
```r
# Parse resumes for certification mentions
cert_analysis <- tibble(
  person_id = 1:N,
  has_security_plus = grepl("Security\\+|CompTIA Security", resume_text),
  has_cissp = grepl("CISSP|Certified Information Systems Security", resume_text),
  has_aws = grepl("AWS|Solutions Architect|Developer Associate", resume_text),
  has_any_cert = has_security_plus | has_cissp | has_aws,
  # If salaries are in resume:
  stated_salary = str_extract(resume_text, "\\$(\\d+,?\\d+)k", group = 1),
  # If job title is in resume:
  job_level = str_extract(resume_text, "Senior|Junior|Staff|Principal", group = 1)
)

# Model: Does having cert predict higher stated salary?
model <- lm(stated_salary ~ has_any_cert + job_level, data = cert_analysis)
summary(model)
```

**What this tells us:**
- Within same job level, do cert holders ask for more?
- What's the cert premium in actual hiring?

**Effort:** 4-8 hours (resume parsing)  
**Tools needed:** R, text parsing, possible PDF extraction  
**Actionability:** HIGH—real hiring outcomes, not surveys

---

### Approach 4: Industry Certification Bodies (Public Data)

**Organizations publish statistics:**
- (ISC)² annual reports: CISSP salary data, hiring trends
- CompTIA research: Security+ salary surveys
- Linux Foundation: RHCE/RHCSA earning data
- AWS: Certification salary guide (official)

**What to find:**
```
(ISC)² typically publishes:
  - Average CISSP holder salary: $X
  - Salary improvement after earning CISSP: +$Y
  - Job demand for CISSP: Z% increase

CompTIA publishes:
  - Security+ holders earn: $X on average
  - IT professional without cert earn: $Y
  - ROI calculation: Cert cost vs. salary increase
```

**Sources:**
- Visit: www.isc2.org/research (official CISSP data)
- Visit: comptia.org/research (Security+ data)
- Visit: aws.amazon.com/certification (AWS salary guide)

**What this tells us:**
- Industry claims about cert value
- Whether claims are inflated (marketing) or realistic

**Effort:** 1-2 hours (reading published reports)  
**Tools needed:** Browser  
**Actionability:** MEDIUM—but likely biased toward positive findings

---

### Approach 5: Military Training Command Records

**If accessible to your organization:**
- Military personnel completing CISSP/Security+ during service
- Track: Did cert holders transition better?
- Compare: Cert completion → civilian job placement → estimated salary

**Data flow:**
```
Military Training Records:
  Who completed CISSP while in military?
  ↓
Job Placement Data (if available):
  Did they find civilian Cyber jobs?
  ↓
Our Current Data:
  Are cert completers in our dataset at higher ranks/salaries?
  
If yes → Cert has value (selects for high-performers)
If no → Cert doesn't correlate with career success
```

**Effort:** Medium (data access dependent)  
**Actionability:** HIGH—real military→civilian pipeline

---

## Realistic Implementation (Choose One)

### Option A: Job Market Analysis (RECOMMENDED)
**Why:** Most reliable market signal, no privacy concerns, publicly available  
**What you do:**
1. Identify 20 Cybersecurity job postings that require CISSP
2. Identify 20 that don't mention CISSP
3. Extract salary range from each
4. Compare: Do CISSP-required jobs pay more?

**Time:** 3-4 hours  
**Code needed:** Simple Python scraper or manual extraction  
**Finding:** Answers "Do employers actually value CISSP?"

---

### Option B: Public Salary Data Mining (EASY)
**Why:** Fastest, requires no coding, uses existing databases  
**What you do:**
1. Search Glassdoor, PayScale for "Cybersecurity + CISSP" salaries
2. Search same for "Cybersecurity without CISSP"
3. Calculate delta
4. Compare to industry claims

**Time:** 2-3 hours  
**Limitation:** Self-reported, may be biased  
**Finding:** Shows whether premium exists in public data

---

### Option C: Military Training Records (BEST DATA)
**Why:** Real outcomes, no selection bias from self-reporting  
**What you do:**
1. Query: Who in your dataset completed CISSP during military?
2. Model: Does cert completion predict higher rank at transition?
3. Model: Does cert completion predict higher estimated salary?
4. Compare to non-cert completers

**Time:** 4-6 hours  
**Limitation:** Only tells you about SUCCESSFUL cert completers (survivorship bias)  
**Finding:** Most realistic military-specific answer

---

## Key Questions Each Approach Answers

| Approach | Question Answered | Confidence | Bias |
|----------|------------------|------------|------|
| **Job Market** | Do employers require/pay for certs? | High | Low (market signal) |
| **Public Salary Data** | What premium do cert holders report? | Medium | High (self-selection) |
| **Resume/LinkedIn** | What do hired people have/ask for? | High | Medium (data available) |
| **Industry Reports** | What do cert vendors claim? | Low | Very High (marketing) |
| **Military Records** | Did military cert completers succeed? | Very High | Low (objective records) |

---

## What NOT to Do

### ❌ Don't collect surveys
- Low response rates
- Recall bias ("Did that cert really help?")
- Self-selection (high-earners overrepresent)

### ❌ Don't cite vendor salary guides alone
- (ISC)² claims CISSP holders earn $130k+
- But this is selection bias (older, more experienced people get CISSP)
- Not causal evidence that CISSP adds $50k

### ❌ Don't assume correlation = causation
- Cert holders earn more → Does cert CAUSE higher pay?
- Or do high-earners GET certs (can afford $1500 exam)?
- Market data helps distinguish these

---

## Recommended Path Forward

### Week 1: Job Market Quick Analysis
```
Objective: Determine if employers actually demand CISSP/Security+

Method:
1. Search Indeed.com: "Cybersecurity Analyst" + "CISSP required"
   → Count postings, extract salary range
2. Search Indeed.com: "Cybersecurity Analyst" + NO cert requirement
   → Count postings, extract salary range
3. Calculate: (Median salary WITH requirement) - (Median salary WITHOUT)

Expected outcomes:
  A) Premium ≥ $20k → CISSP is genuinely valued
  B) Premium $5-15k → Valued but modest
  C) Premium < $5k → Marketing hype
```

**Time:** 3-4 hours  
**Deliverable:** 1-page analysis with salary comparisons  
**Finding:** Market validation of cert value

### Week 2: Internal Data Check (If Possible)
```
Objective: Do military people who completed certs earn more?

Method:
1. Extract from military records: Who completed CISSP/Security+ during service?
2. Compare this group to control group (same rank, same YOS, no cert)
3. Model: salary ~ rank + yos + has_completed_cert

Expected outcomes:
  A) Cert coefficient significant, positive → Cert signals success
  B) Cert coefficient zero → Cert doesn't predict salary
  C) Can't separate from rank effects → Need larger sample
```

**Time:** 4-6 hours  
**Deliverable:** Regression table with cert effect  
**Finding:** Military-specific certification ROI

---

## Bottom Line

**Without surveys, you can still answer:**

✅ "Do employers actually require CISSP?" (Job postings)  
✅ "Do cert-requiring jobs pay more?" (Job postings + salary data)  
✅ "Did military people who got certs transition better?" (Military records)  
✅ "What premium do cert holders claim?" (Public salary data)  

**You cannot answer (without surveys):**
❌ "Why did someone get a cert?" (Motivations)  
❌ "Did the cert CAUSE the salary increase?" (Causality, unobserved confounders)  
❌ "Do people regret getting certs?" (Subjective satisfaction)  

**Recommendation:** Start with job market analysis (3-4 hours, high signal). If interesting pattern emerges, then dig into military training records (4-6 hours, high confidence).

This is the "no survey" path that still gives you defensible findings.

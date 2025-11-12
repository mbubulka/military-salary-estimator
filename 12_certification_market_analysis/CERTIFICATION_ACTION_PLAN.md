# Certification Research: Quick Action Plan

**Date:** November 12, 2025  
**Status:** Ready to Execute  
**Scope:** Cybersecurity Certifications (Deep Dive)

---

## What You're Testing

**Question:** Do certifications (Security+, CISSP, AWS, Kubernetes) command salary premiums in Cybersecurity roles?

**Why it matters:** Your finding is "rank dominates, skills don't." Testing certs either confirms this OR shows that certifications (even though occupational category doesn't) DO add value.

---

## The 4-Hour Analysis

### Step 1: Collect Data (~1 hour)
**Scrape cybersecurity job postings from public sources:**
- Indeed.com: Search "Cybersecurity Analyst" + "Security Engineer"
- LinkedIn: Filter for "Cybersecurity" + salary visible
- Dice.com: Tech-specific job site
- Goal: 100-150 postings with visible salary ranges

**What to extract:**
```
✓ Job title
✓ Location (if available)
✓ Salary range (min/max)
✓ Required certifications (if mentioned)
✓ Preferred certifications (if mentioned)
✓ Full job description text
```

**Tools:**
- Python + BeautifulSoup (if you code)
- Manual copy-paste into Excel (if you don't)
- Google Sheets + IMPORTHTML (if you want quick & dirty)

### Step 2: Parse Certifications (~1 hour)
**Mark each posting for cert mentions:**

```
Postings table with:
  - requires_security_plus (TRUE/FALSE)
  - requires_cissp (TRUE/FALSE)
  - requires_aws (TRUE/FALSE)
  - requires_kubernetes (TRUE/FALSE)
  - prefers_security_plus (TRUE/FALSE)
  - prefers_cissp (TRUE/FALSE)
  - prefers_aws (TRUE/FALSE)
  - prefers_kubernetes (TRUE/FALSE)
```

**Search strings:**
- Security+ → "Security\+" or "CompTIA Security"
- CISSP → "CISSP"
- AWS → "AWS" or "Amazon Web Services"
- Kubernetes → "Kubernetes" or "K8s"

### Step 3: Analyze (~1-1.5 hours)

**Question 1: What % of postings require each cert?**
```
% Require Security+:     ____%
% Require CISSP:         ____%
% Require AWS:           ____%
% Require Kubernetes:    ____%

% Prefer (but don't require):
  Security+:             ____%
  CISSP:                 ____%
  AWS:                   ____%
  Kubernetes:            ____%
```

**Interpretation:**
- >50% require = MANDATORY (you need it)
- 20-50% require = IMPORTANT (adds value)
- <20% require = NICE-TO-HAVE (optional)

**Question 2: Do cert-required jobs pay more?**
```
Security Analyst WITHOUT cert requirement:
  Median salary: $______

Security Analyst WITH Security+ requirement:
  Median salary: $______
  
Premium: $______ per year (____% increase)

[Repeat for CISSP, AWS, Kubernetes]
```

**Interpretation:**
- >$15k premium = SIGNIFICANT (real market value)
- $5-15k premium = MODEST (some value)
- <$5k premium = NEGLIGIBLE (no real premium)
- Negative premium = SIGNAL (overqualified people apply)

**Question 3: Cert clustering—do people need multiple?**
```
Jobs requiring:
  - Security+ alone:        ____%
  - AWS alone:              ____%
  - CISSP alone:            ____%
  - Security+ + AWS:        ____%
  - Security+ + CISSP:      ____%
  - AWS + Kubernetes:       ____%
  - All three/four:         ____%
```

**Interpretation:**
- Single cert dominates = specialization (pick one path)
- Multiple certs common = progression (build stack)
- Mixed patterns = field-dependent (varies by employer)

---

## Expected Findings (Prediction)

Based on market knowledge, I expect:

```
Security+ Analysis:
  % postings mentioning: 40-60%
  % requiring it: 15-25%
  Salary premium: $2-5k (mostly requirement, not premium)
  
AWS Analysis:
  % postings mentioning: 50-70%
  % requiring it: 20-35%
  Salary premium: $5-15k (real demand signal)
  
CISSP Analysis:
  % postings mentioning: 20-30%
  % requiring it: 5-10%
  Salary premium: $10-25k (senior roles, real premium)
  
Kubernetes Analysis:
  % postings mentioning: 30-50%
  % requiring it: 10-20%
  Salary premium: $10-20k (infrastructure focus, high demand)
```

**What this would MEAN for your finding:**
- If pattern matches: "Certs exist as market signal, correlate with higher-paying roles"
- Could explain why occupational category doesn't matter: it's too broad
- Certs provide within-category fine-tuning

---

## Deliverable

**1-2 page findings document:**

### Title
"Cybersecurity Certifications in the Job Market: What Employers Actually Require and Reward"

### Executive Summary
```
This analysis examined 100+ cybersecurity job postings to understand 
which certifications employers require, prefer, or ignore—and whether 
cert-required jobs pay more.

Key findings:
- Security+ is required in X% of postings (modest premium)
- AWS is required in Y% of postings (strong premium)
- CISSP is required in Z% of postings (senior-focused premium)
- Progression path appears to be: Security+ → AWS/CISSP
```

### Sections
1. Methodology (100 postings, X source, date range)
2. Certification Requirements (% required/preferred for each)
3. Salary Analysis (premium for cert-required roles)
4. Certification Clustering (single vs. progression)
5. Implications for Military→Cyber Transitions

### Conclusion
```
Employers DO value certifications in cybersecurity (unlike your finding 
that occupational category doesn't matter). However, the value varies:

- Security+ signals entry-level/requirement (modest premium)
- AWS signals cloud focus (substantial premium)
- CISSP signals management/seniority (largest premium)

This suggests: Certifications matter WITHIN cybersecurity, even though 
the broad occupational category doesn't. The granular credentials 
(specific certs) matter more than the broad category (Cyber vs. Health).
```

---

## Timeline

**Option A: Quick (This Week)**
- 2-3 hours: Collect 80 postings, manual analysis
- 1-2 hours: Write up findings
- **Deliverable:** 1-page summary

**Option B: Thorough (Next Week)**
- 3-4 hours: Collect 150 postings, systematic coding
- 1-2 hours: Analysis + visualization
- **Deliverable:** 2-page report with charts

---

## Success Criteria

**You'll know this was valuable if:**

✅ You can say: "Here's what employers actually require in cybersecurity roles"  
✅ You can rank certs by importance (Security+ < AWS < CISSP)  
✅ You can show salary premiums for each cert  
✅ You understand progression path (which cert to get first)  
✅ You can compare to your finding (certs matter more than occupational category?)

---

## Next: If Findings Are Interesting

If you find that certifications DO matter in Cyber, consider:
- Test 1 contrasting field (Data Analysis or A/C Maintenance)
- See if pattern generalizes or is Cyber-specific
- Publish findings as "Certifications Matter More Than Occupational Category"

If certifications DON'T matter, then:
- Your finding is even stronger
- Rank truly dominates across all dimensions
- No need for spot-check analysis

---

## Files You Now Have

In `12_certification_market_analysis/`:

1. **CERTIFICATION_ACTION_PLAN.md** - This file (4-hour execution plan)
2. **CERTIFICATIONS_NO_SURVEY_APPROACH.md** - No-survey options
3. **CERTIFICATIONS_FULL_LANDSCAPE.md** - Cert ecosystem breakdown
4. **CERTIFICATION_SCOPE_STRATEGY.md** - Why deep-dive Cyber
5. **DATA_COLLECTION_TEMPLATE.md** - Spreadsheet template + sources
6. **CERTIFICATIONS_RESEARCH_PLAN.md** - Comprehensive reference

---

## Ready?

You have:
✅ Clear question
✅ 4-hour timeline
✅ Expected findings
✅ Deliverable format
✅ Success criteria

Next step: Collect 100 cybersecurity job postings and start the analysis.

Want to proceed, or any clarifications first?

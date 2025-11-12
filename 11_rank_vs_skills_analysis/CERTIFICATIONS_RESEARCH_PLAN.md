# Testing Certification Value: What Data We Need and How to Prove/Disprove

**Date:** November 12, 2025  
**Question:** Are certifications (CISSP, Security+, AWS) actually valuable, or marketing hype?  
**Approach:** Design experiments to measure certification ROI with achievable data collection

---

## Part 1: Mining Existing Data for Geographic Location

### What We Already Have

You mentioned COL (Cost of Living) adjustments. Let me check what location data is already in the dataset:

**In our data:**
- `occupation_name`: 36 occupational titles
- `civilian_category`: 12 categories (Intelligence, Cybersecurity, etc.)
- **Potential embedded location signals:**
  - Some occupations are region-specific (e.g., "Silicon Valley Engineer")
  - Metro vs. rural distinction in occupation names

**Action: Audit current data for location signals**
```r
# Check if occupation_name contains location hints
data %>%
  select(occupation_name, civilian_category) %>%
  filter(grepl("San Francisco|Silicon|Bay Area|New York|DC|Washington", occupation_name)) %>%
  nrow()

# If we have location-tagged occupations, we can extract:
data %>%
  mutate(
    implied_location = if_else(
      grepl("Silicon|Bay|San Francisco|tech hub", occupation_name, ignore.case = TRUE),
      "High-COL Area",
      "National Average"
    )
  )
```

**IF this exists in data:**
- We can already test location effects without new data collection
- Show whether high-COL areas pay Cyber people differently
- Directly address Objection 6 (confounding variables)

### What We're Missing

Even with location hints, we can't do full analysis without:
- ❌ Actual city/state/region of civilian job
- ❌ Actual COL adjustment factor applied
- ❌ Metropolitan statistical area (MSA) designation

**Effort to collect:** MEDIUM (might exist in HR records or survey)

---

## Part 2: The Certification Question

### The Core Problem with Certifications

**What we're told (by vendors):**
```
CISSP certification → +$20-30k/year (+25-35% salary increase)
AWS certifications → +$15k per cert
Security+ → +$5-10k
```

**What we DON'T know:**
- Is this correlation or causation?
  - (Does CISSP add value, or do high-earners GET CISSP?)
- Do military certifications count the same as civilian ones?
- Do employers require them or prefer them?
- Does timing matter (cert before job, or after)?

**The selection bias problem:**
```
High-paid people get certifications
└─ Does cert CAUSE high pay?
└─ Or does high pay ENABLE cert pursuit?

Example:
  Senior engineer ($130k) gets CISSP (+$10k, costs $749 + 5 hours)
  vs.
  Junior developer ($50k) can't afford CISSP ($1500+ exam + prep time)

Result: CISSP holders earn more, but cert might not be the cause
```

---

## Part 3: Data Collection Plan for Certification Testing

### Option 1: MINIMAL EFFORT (Survey-based)

**What to collect: 20-30 military→civilian transitioners**

**Survey questions:**
```
1. What military specialty did you have? (dropdown)
2. What certifications do you currently hold? (checkbox)
   ☐ None
   ☐ CompTIA Security+
   ☐ CompTIA Network+
   ☐ AWS Certified (which level?)
   ☐ Microsoft Certifications
   ☐ CISSP
   ☐ CEH
   ☐ RHCE/RHCSA
   ☐ Other: ________

3. When did you earn each cert? (before military, during military, after transition)
4. What is your current job title and salary range?
5. How critical was each cert for getting hired?
   (Not at all / Nice to have / Required / Critical)

6. Do you think certs increased your salary?
   (No / Maybe 5% / 10-15% / 20%+ / Don't know)
```

**Cost:** ~2-4 hours to create survey + contact people  
**Sample:** 20-30 people  
**Data quality:** Moderate (self-report, recall bias)  
**Timeline:** 1-2 weeks

---

### Option 2: MODERATE EFFORT (Resume analysis)

**What to do: Extract data from actual resumes**

**If you can access resumes of transitioned personnel:**

```r
# Parse certifications from resume text
resume_data <- tibble(
  military_id = c("E6_YOS4", "O4_YOS6", ...),
  resume_text = c("[full resume text]", ...),
  # Extract certifications mentioned
  has_security_plus = grepl("Security\\+|CompTIA Security", resume_text),
  has_cissp = grepl("CISSP|Certified Information Systems Security", resume_text),
  has_aws = grepl("AWS|Amazon Web Services|Solutions Architect", resume_text),
  has_any_cert = has_security_plus | has_cissp | has_aws,
  # Extract salary if mentioned
  salary_from_resume = str_extract(resume_text, "\\$(\\d+,?\\d+)", group = 1)
)

# Then: Do people WITH certs earn more?
model_without_cert <- glm(civilian_salary ~ rank + yos, data = data)
model_with_cert_var <- glm(civilian_salary ~ rank + yos + has_any_cert, data = data_with_certs)

# Compare R² improvement and cert coefficient significance
```

**Cost:** 4-8 hours resume parsing  
**Sample:** 50-100 people (if resumes available)  
**Data quality:** High (objective, from official documents)  
**Timeline:** 1-2 weeks (if resumes are available)  
**Challenge:** Privacy—need permission to use resume data

---

### Option 3: ROBUST EFFORT (Job posting analysis)

**What to do: Analyze what employers ASK FOR**

**Method: Scrape job postings for Cybersecurity roles**

```python
# Search Indeed, LinkedIn, etc. for:
# "Cybersecurity Analyst" jobs in different markets

job_postings <- tibble(
  job_title = c("Cybersecurity Analyst", "Cybersecurity Engineer", ...),
  location = c("San Francisco, CA", "Rural Iowa", "New York, NY", ...),
  salary_range = c("$120-150k", "$60-75k", "$140-170k", ...),
  # Extract requirement mentions
  requires_security_plus = grepl("Security\\+|CompTIA", posting_text),
  requires_cissp = grepl("CISSP", posting_text),
  prefers_security_plus = grepl("Preferred.*Security\\+", posting_text),
  prefers_cissp = grepl("Preferred.*CISSP", posting_text)
)

# Analysis:
# Q1: Do postings requiring CISSP offer higher salaries?
# Q2: Do postings for high-COL areas require more certs?
# Q3: What % of postings actually REQUIRE vs. PREFER certs?

posting_analysis <- job_postings %>%
  group_by(location, requires_cissp, requires_security_plus) %>%
  summarise(
    avg_salary = mean(salary_from_range),
    n_postings = n(),
    pct_require_something = mean(requires_cissp | requires_security_plus) * 100
  )
```

**Cost:** 6-12 hours (web scraping + analysis)  
**Sample:** 200-500 job postings  
**Data quality:** High (objective from real job market)  
**Timeline:** 2-3 weeks  
**Insight value:** HIGHEST (answers "do employers actually care?")

---

## Part 4: Certification Testing Experiments

### Experiment Design 1: Correlation Test (Easiest)

**Do military people with certs earn more?**

```r
# If we can extract certs from resumes:

model_no_cert <- glm(
  civilian_salary ~ rank + years_of_service,
  data = data_with_certs
)

model_with_cert <- glm(
  civilian_salary ~ rank + years_of_service + 
    has_security_plus + has_cissp + has_aws,
  data = data_with_certs
)

# Compare:
r2_no_cert <- 0.9627  # (your current finding)
r2_with_cert <- ?     # (should improve if certs matter)

# Statistical test:
# If cert coefficient p < 0.05 → certs matter
# If cert coefficient p > 0.05 → certs don't matter (controlling for rank)
```

**Result interpretation:**
```
Scenario A (Certs DO matter):
  Coefficient: Security+ = +$8,000 (p = 0.03)
  → Within same rank, cert holders earn $8k more
  → Finding: Certs have measurable premium

Scenario B (Certs DON'T matter):
  Coefficient: Security+ = +$500 (p = 0.78)
  → Within same rank, cert holders earn ~same
  → Finding: Certs are correlated with higher earners, but not causal

Scenario C (Certs are SELECTION BIAS):
  Coefficient: Security+ = +$2,000 (p = 0.15)
  → Only high-performers get certs, but cert itself adds little
  → Finding: Certs mark high-performers, not cause of pay
```

---

### Experiment Design 2: Timing Test (Medium difficulty)

**Does earning cert DURING military vs. AFTER transition matter?**

```r
# Categorize people:
data_with_cert_timing <- data_with_certs %>%
  mutate(
    cert_timing = case_when(
      cert_earned_before_transition ~ "Before",
      cert_earned_after_transition ~ "After",
      TRUE ~ "None"
    )
  )

# Model:
model_cert_timing <- glm(
  civilian_salary ~ rank + years_of_service + cert_timing,
  data = data_with_cert_timing
)

# Questions:
# Q1: Do pre-transition certs (military training) matter more?
# Q2: Do post-transition certs (civilian training) matter more?
# Q3: Does cert timing correlate with success?

# If pre-transition military certs don't help:
#   → Military training isn't recognized
# If post-transition certs DO help:
#   → Employers value "civilian-credentialed" more
```

**Why this matters:**
```
Current belief: "Military training → civilian cert → higher pay"
Alternative: "Military training → nothing; civilian cert → some pay boost"

Timing test distinguishes between:
  A) Military certs are valuable (pre-transition certs help)
  B) Only civilian certs matter (post-transition certs help)
  C) Neither matters much (neither predicts pay)
```

---

### Experiment Design 3: Market-Based Test (Highest value)

**Do employers actually demand certifications?**

```r
# Job posting analysis (from Part 3, Option 3)

job_market <- read.csv("cybersecurity_job_postings.csv")

# Q1: What % of Cyber jobs require/prefer certs?
job_market %>%
  summarise(
    pct_require_any_cert = mean(requires_cissp | requires_security_plus),
    pct_require_cissp_specifically = mean(requires_cissp),
    pct_prefer_but_not_require = mean(prefers_cissp & !requires_cissp)
  )

# Expected results:
# If certs are marketing: <10% actually require them
# If certs are standard: 40-60% require them
# If certs are luxury: >70% prefer but don't require

# Q2: Do postings requiring certs offer higher salaries?
job_market %>%
  group_by(requires_cissp) %>%
  summarise(
    avg_salary = mean(salary_range),
    median_salary = median(salary_range),
    n = n()
  )

# Find:
# Salary delta = (jobs WITH CISSP requirement) - (jobs without)
# If delta = 0: employers don't VALUE certs in pay
# If delta = $20k: employers do VALUE certs
```

**This is the REAL test of cert value:**
```
Real employer demand says more than salary correlation.

If 90% of postings DON'T require CISSP:
  → It's NOT essential
  
If jobs requiring CISSP pay 15% less:
  → It's actually a BAD signal (overqualified people apply?)

If jobs requiring CISSP pay 25% more:
  → It's genuinely valued
```

---

## Part 5: Certification ROI Calculation

### If we collect certification data, calculate ACTUAL ROI:

```r
# Hypothetical data:
cert_roi <- tibble(
  cert_type = c("Security+", "CISSP", "AWS Solutions Architect", "RHCE"),
  avg_salary_with = c(78000, 115000, 95000, 85000),
  avg_salary_without = c(75000, 95000, 80000, 82000),
  avg_cert_cost = c(400, 1500, 300, 300),
  avg_study_hours = c(40, 150, 30, 60),
  salary_increase = avg_salary_with - avg_salary_without,
  salary_increase_pct = (salary_increase / avg_salary_without) * 100,
  # ROI calculation
  annual_roi = salary_increase / avg_cert_cost,
  roi_per_hour = salary_increase / (avg_study_hours + cert_cost_hours)
)

print(cert_roi)
```

**Output interpretation:**
```
CISSP:
  Cost: $1,500 (cert) + 150 hours study time
  Salary boost: +$20,000 (from $95k to $115k)
  Annual ROI: 1,333% (pay back cert cost in 8 days!)
  BUT: Is this cert CAUSING boost, or selecting for high-performers?

Security+:
  Cost: $400 + 40 hours
  Salary boost: +$3,000
  Annual ROI: 750% (seems good)
  BUT: Only $3k → probably within noise/selection bias range

AWS Cert:
  Cost: $300 + 30 hours
  Salary boost: +$15,000
  Annual ROI: 5,000% (incredible!)
  BUT: Demand signal might be high, making any AWS-adjacent person valuable
```

---

## Part 6: What We Can Prove vs. What We Can't

### If we DO collect certification data:

**We CAN prove:**
✅ Whether military people WITH certs earn more (correlation)  
✅ Whether cert timing (pre vs. post transition) matters  
✅ Whether specific certs correlate with salary  
✅ ROI: cost of cert vs. salary increase  

**We CAN'T prove (without employer survey):**
❌ Whether certs CAUSE higher salary or select for high-performers  
❌ Whether employers actively PREFER certs  
❌ Whether certs speed promotion or just mark pre-promotion candidates  
❌ Whether certs provide value beyond initial salary  

**True causal test would require:**
- Random assignment (some get cert stipend, others don't)
- Impossible ethically/practically
- Best we can do: temporal analysis (cert earned → salary change)

---

## Part 7: Recommended Approach (Feasible + High Value)

### Three-Pronged Strategy:

**TIER 1: Survey (Start here - 2 weeks)**
- Email 50-100 transitioned military people
- "What certs do you have? When earned? Do you think it helped?"
- 10-15 responses probably
- Low cost, quick feedback

**TIER 2: Job Posting Analysis (Parallel - 2-3 weeks)**
- Scrape 500 Cybersecurity job postings (Indeed, LinkedIn)
- Extract cert requirements and salary ranges
- Compare: "Do postings REQUIRING CISSP pay more?"
- HIGHEST VALUE—shows actual market demand

**TIER 3: Resume Analysis (If possible - 1-2 weeks)**
- If your organization has resume database
- Extract certs + outcomes
- Compare salary by cert type
- Best data quality if available

---

## Expected Findings (Prediction)

Based on industry knowledge, I predict:

**Scenario A (Most likely):**
```
Job postings:
  CISSP required: 25% of senior roles, pays 5-10% more
  Security+ required: 5% of roles, pays 0-5% more
  AWS required: 35% of modern roles, pays 2-8% more

Military data:
  People WITH certs: +$2-5k average (mostly selection bias)
  CISSP holders: +$8-12k (genuine premium)
  Security+ holders: +$1-3k (within noise)

Interpretation:
  → Certs matter, but less than rank
  → CISSP > Security+ > AWS for traditional roles
  → AWS surprisingly less valuable in salary despite high demand
  → Timing: Pre-transition certs almost worthless; post-transition certs valuable
```

**Scenario B (Industry marketing):**
```
Job postings:
  Requirements are listed but 70% "or equivalent experience"
  Salary delta: cert-required vs. not = <3% difference

Military data:
  Cert holders: +$1-2k (selection bias only)
  No significance in regression (p > 0.05)

Interpretation:
  → Certs are marketing hype
  → Employers don't actually value them
  → Smart, experienced people get certs; certs don't cause success
```

---

## Action Items

### Immediate (This week):
- [ ] Check dataset for location hints in occupation_name
- [ ] Design 3-question cert survey
- [ ] Identify 20-30 people to survey

### Short-term (Next 2 weeks):
- [ ] Run survey
- [ ] Begin job posting scrape (if technical capacity available)
- [ ] Compile resume database (if accessible)

### Analysis (Weeks 3-4):
- [ ] Run certification models
- [ ] Calculate ROI
- [ ] Compare to job market findings

### Documentation:
- [ ] Create "Certification ROI" report
- [ ] Update dashboard with findings
- [ ] Publish findings about cert value (confirms/denies vendor claims)

---

## Key Questions to Answer

1. **Do certs matter at all?** (Regression test)
2. **How much do they matter?** (Effect size)
3. **For which specializations?** (Cyber vs. Healthcare certs different?)
4. **Compared to what?** (CISSP ROI vs. Masters degree ROI?)
5. **What do employers actually require?** (Job posting test)
6. **Is it causation or selection?** (Timing test)

This is achievable with your data + modest additional collection.

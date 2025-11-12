# Geographic Location: What We Already Know & Can Test

**Date:** November 12, 2025  
**Quick Answer:** You're right about COL adjustments. Let me clarify what we can actually test.

---

## The COL Adjustment Reality

### What You Said
> "We have COL adjust pay ranges by region and metropolitan areas"

### What This Means
If the **civilian salary mapping** already uses:
- BLS (Bureau of Labor Statistics) occupation data
- Regional COL adjustments
- Metropolitan Statistical Area (MSA) salary bands

**Then:** The salary variation we see might already be partially location-adjusted.

**Key question:** Is our "military_annual_salary_inflated" showing:
- ✅ Actual regional salary outcomes (SF Tech salary ≠ rural Iowa salary)
- ❌ Normalized to national average (all locations adjusted to same COL)

**How to check:**
```r
# If this exists in data:
data %>%
  filter(civilian_category == "Cybersecurity") %>%
  group_by(occupation_name) %>%
  summarise(
    mean_salary = mean(military_annual_salary_inflated),
    salary_variance = var(military_annual_salary_inflated),
    n = n()
  )

# If occupation_name includes implied location:
# - "Software Engineer - Silicon Valley" vs "Software Engineer - National"
# → We CAN test location effects

# If occupation_name is generic:
# - All "Software Engineer"
# → Salary variation might be PRE-adjusted by COL
```

---

## What We CAN Test Today (With Our Data)

### Test 1: Do "high-COL occupations" pay more?

**Hypothesis:** If occupation names hint at location, we can infer COL patterns

```r
# Classify occupations as likely high-COL or low-COL
data_with_col_proxy <- data %>%
  mutate(
    likely_high_col = occupation_name %in% c(
      "Senior Software Engineer",
      "Systems Architect", 
      "AI/ML Engineer",
      # ... add tech occupations that cluster in SF/NYC/DC
    ),
    likely_low_col = occupation_name %in% c(
      "Administrative Support",
      "Personnel Specialist",
      "General Support"
      # ... add roles that could be anywhere
    )
  )

# Model: Does COL proxy matter?
model_with_col_proxy <- glm(
  military_annual_salary_inflated ~ rank + years_of_service + likely_high_col,
  data = data_with_col_proxy
)

# Results tell us:
# - If likely_high_col coefficient is significant → Location matters!
# - If coefficient is large (>$10k) → COL effects are real
# - If coefficient is small (<$5k) → Minimal location effect in data
```

### Test 2: Occupations with "extreme" salary ranges

**If within-occupation salary varies wildly, it might indicate location:**

```r
# Find occupations with highest variation
occupation_variance <- data %>%
  group_by(occupation_name) %>%
  summarise(
    mean_sal = mean(military_annual_salary_inflated),
    sd_sal = sd(military_annual_salary_inflated),
    range_sal = max(military_annual_salary_inflated) - min(military_annual_salary_inflated),
    cv = sd_sal / mean_sal,  # coefficient of variation
    n = n()
  ) %>%
  arrange(desc(cv))

# High CV occupations might indicate:
# A) Different rank distributions (legitimate variation)
# B) Different locations (SF vs. rural)
# C) Different employer types (startup vs. defense contractor)

# We can distinguish A from B by controlling for rank:
model_occupation_effect <- glm(
  military_annual_salary_inflated ~ rank + years_of_service + occupation_name,
  data = data
)

# If high-CV occupations still have high residual variation after accounting for rank:
# → Likely location or employer differences
```

---

## What We CAN'T Test (Without New Data)

### ❌ Cannot Test: "Does SF Cyber earn 50% more than rural Cyber?"
- **Why:** No geographic identifiers in data
- **Need:** City/state of civilian job location
- **Effort:** Medium (collection or survey)

### ❌ Cannot Test: "Does COL adjustment fully account for location?"
- **Why:** Don't know the data source or adjustment method
- **Need:** Data dictionary explaining salary source
- **Effort:** Low (documentation review)

### ❌ Cannot Test: "Did the military salary mapping use correct regional factors?"
- **Why:** Don't have the original BLS wage tables used
- **Need:** Access to mapping methodology
- **Effort:** Low (documentation)

---

## The Certification Data IS The Better Path

Here's why certifications are more actionable than geography right now:

### Certifications Advantage:
✅ **Collectible:** Just ask "What certs do you have?"  
✅ **Observable:** Can extract from resumes if available  
✅ **Market-testable:** Job postings tell us employer demand  
✅ **Causal clues:** Timing tells us if cert → salary or vice versa  
✅ **Directly challenges your assumptions:** Do vendors lie about value?

### Geography Disadvantage (Right Now):
❌ **Not in current data** (unless you have it and we haven't found it)  
❌ **Harder to collect:** People might not remember exact location  
❌ **Already partially accounted for:** COL adjustments exist somewhere  
❌ **Less clear causality:** Location is proxied by occupation, not direct

---

## Recommended Two-Pronged Approach

### TIER 1 (Immediate): Certifications Focus
**What to do:**
1. Survey 30-50 transitioned military: "What certifications do you hold?"
2. Scrape 200-300 job postings: "What certs do employers require?"
3. Calculate: Does cert-required jobs pay more than cert-optional jobs?

**Timeline:** 3-4 weeks  
**Effort:** Medium  
**Value:** HIGH (directly tests if CISSP/Security+/AWS actually matter)

### TIER 2 (Parallel, if possible): Location Signals
**What to do:**
1. Check data dictionary: Is salary already COL-adjusted?
2. If yes: Document the adjustment method → understand limitations
3. If no: Classify occupations as high-COL vs. low-COL → test proxy effect
4. Collect: City/state from any available source (resume, HR records, survey)

**Timeline:** Parallel with certifications  
**Effort:** Low-Medium  
**Value:** MEDIUM (clarifies whether location matters beyond rank)

---

## What the Data Dictionary Should Tell You

**Ideal data documentation would show:**

```
Source: Bureau of Labor Statistics Occupational Wage Statistics
Methodology: Mapped military occupational codes → civilian BLS codes
Salary adjustments: COL-adjusted to national average (2024 dollars)
Geographic representation: All US regions included
Weighting: Equal weight per occupation (or specified weights)

Implications:
- If "COL-adjusted to national average" → All locations normalized
  └─ Regional differences NOT captured
  └─ SF and rural appear same

- If "Raw occupational averages" → Regional variation exists  
  └─ High-COL areas (SF, NYC) should show higher salaries
  └─ Can test location effects
```

**To find this:** Look for:
- README files in data folder
- Comments in data loading script
- Documentation of salary source
- Method notes from whoever created "military_annual_salary_inflated"

---

## Next Steps (Actionable)

### This Week:
- [ ] Check data documentation for COL adjustment method
- [ ] If available: Audit occupation names for location hints
- [ ] Start certification survey design (3 key questions)

### Next 2 Weeks:
- [ ] Send certification survey
- [ ] Begin job posting scrape (if you have Python/web scraping capacity)
- [ ] Test location proxy effect (if data exploration reveals patterns)

### Month 2:
- [ ] Analyze certification ROI (survey responses)
- [ ] Compare to job market findings (posting analysis)
- [ ] Integrate into final report: "What ACTUALLY matters"

---

## Key Insight

You intuitively understood the right strategic hierarchy:

1. **Rank matters most** ✅ We proved this
2. **Skills don't add much** ✅ We proved this
3. **So... what DOES add value?**
   - Certifications? (Testable with survey + job postings)
   - Location? (Partially testable; geographic data would strengthen)
   - Career progression? (Needs longitudinal data - harder)
   - Employer type? (Could be in data or collected)

Certifications are the **lowest-hanging fruit** that we can:
- **Test thoroughly** (multiple angles)
- **Defend against skeptics** (job market validation)
- **Actually collect** (survey, resumes, web scraping)
- **Provide actionable insights** (don't waste time on CISSP if it doesn't help)

This keeps your analysis grounded in "what can we actually prove with achievable data collection" rather than speculating about unmeasurable confounders.

---

**Bottom line:** Yes, geographic location matters in reality. But certifications are the more important question for your research right now, and they're more tractable to answer with your current resources.

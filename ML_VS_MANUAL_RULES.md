# Should We Use ML to Decide Cert Relevance?

**Date:** November 12, 2025  
**Question:** LR vs Decision Tree vs Manual exclusion for cert-role relevance?

---

## The Problem We're Solving

**Current state:**
```
Medical role → FORCE recommendations:
  • 3 highly_relevant (Security+, PMP, AWS)
  • 3 relevant (ITIL, Azure, Project+)
  • 3 optional (GCP, Kubernetes, Terraform)
  = 9 total certs, even if some don't fit
```

**Better approach:**
```
Medical role → Only show relevant:
  • Security+ (healthcare data) ✅
  • PMP (leadership) ✅
  • AWS (EHR systems) ✅
  • ITIL (operations) ✅
  • Azure (enterprise health IT) ✅
  
  • Kubernetes (not relevant) ❌ DON'T SHOW
  • Terraform (not relevant) ❌ DON'T SHOW
  • Databricks (not relevant) ❌ DON'T SHOW
  • GCP Data Engineer (not relevant) ❌ DON'T SHOW
```

---

## Option 1: Logistic Regression (Binary Classification)

**Question:** "Is cert X relevant for category Y?"
**Output:** Probability (0-1) → Threshold at 0.5 → Show/Hide

### Pros
- ✅ Simple interpretation: "75% chance cert is relevant"
- ✅ Fast to compute
- ✅ Easy to explain to stakeholders
- ✅ Can handle multiple features (cert_type, category, salary_data)

### Cons
- ❌ Oversimplifies: "relevant" is not binary (some are borderline)
- ❌ No tiering: Can't distinguish "highly relevant" vs "relevant" vs "optional"
- ❌ Need labeled training data: "Combat Medic + CISSP = relevant Y/N"
- ❌ Assumes linear decision boundary: Might not work for complex relationships

### Would it work here?
**Medium probability.** Could work to filter out obvious non-fits (Kubernetes for Medical), but loses the tiering structure you currently have.

---

## Option 2: Decision Tree (Multi-class Classification)

**Question:** "Is cert X [highly_relevant / relevant / optional / not_shown] for category Y?"
**Output:** Multi-class prediction → [Highly Relevant, Relevant, Optional, Not Shown]

### Pros
- ✅ Handles 4 classes: Can tier AND exclude
- ✅ Interpretable: "IF category=Medical AND cert_type=cloud THEN optional"
- ✅ Captures non-linear relationships
- ✅ Works with small datasets
- ✅ Can show decision rules: "Why is X shown? Because..."

### Cons
- ❌ Still need labeled training data (36 occupations × 15 certs = 540 labels)
- ❌ Overfitting risk with small data
- ❌ Tree depth/complexity decisions
- ❌ Might be overkill for this problem

### Would it work here?
**Yes, but overkill.** Could work, but is ML needed?

---

## Option 3: Manual Expert Rules (No ML)

**Approach:** Define explicit rules based on cert type + category logic

```r
cert_category_relevance <- function(cert_name, category) {
  
  # CLOUD CERTS (AWS, Azure, GCP, Kubernetes, Terraform)
  if (cert_name %in% c("AWS Solutions Architect Associate", "Azure Administrator", 
                       "GCP Cloud Engineer", "Kubernetes (CKA)", "Terraform")) {
    if (category %in% c("Cyber/IT Operations", "Engineering & Maintenance", 
                        "Data Scientist", "Data Analyst")) {
      return("highly_relevant")
    } else if (category %in% c("Intelligence & Analysis", "Logistics & Supply", 
                               "Operations & Leadership")) {
      return("relevant")
    } else if (category == "Medical") {
      return("optional")  # Maybe useful for healthcare IT, but not primary
    } else {
      return("not_shown")
    }
  }
  
  # SECURITY CERTS (Security+, CISSP)
  if (cert_name %in% c("Security+", "CISSP")) {
    if (category == "Cyber/IT Operations") {
      return("highly_relevant")
    } else if (category %in% c("Intelligence & Analysis", "Engineering & Maintenance")) {
      return("relevant")
    } else if (category == "Medical") {
      return("relevant")  # HIPAA/data protection is important
    } else {
      return("optional")
    }
  }
  
  # PROJECT MANAGEMENT CERTS (PMP, Project+, ITIL)
  if (cert_name %in% c("Project Management Professional", "Project+ (CompTIA)", "ITIL")) {
    if (category == "Operations & Leadership") {
      return("highly_relevant")
    } else if (category %in% c("Medical", "Logistics & Supply")) {
      return("relevant")
    } else {
      return("optional")
    }
  }
  
  # DATA SCIENCE CERTS
  if (cert_name %in% c("GCP Data Engineer", "AWS Analytics Specialty", 
                       "Databricks Certified Engineer", "Azure Data Engineer")) {
    if (category %in% c("Data Scientist", "Data Analyst", "Intelligence & Analysis")) {
      return("highly_relevant")
    } else {
      return("not_shown")  # Not relevant for medical, operations, etc.
    }
  }
  
  # Default
  return("optional")
}
```

### Pros
- ✅ Explicit, interpretable rules
- ✅ No ML needed, no training data required
- ✅ Easy to debug: "Why is X shown?" → Check rule
- ✅ Perfect for your domain knowledge
- ✅ Can be versioned/updated easily

### Cons
- ❌ Manual maintenance (but it's small)
- ❌ Might miss patterns (but unlikely with 15 certs)
- ❌ Feels "non-technical" (but so what?)

### Would it work here?
**YES, perfectly.** This is what you need.

---

## Comparison Table

| Aspect | LR | Decision Tree | Manual Rules |
|--------|---|---|---|
| **Handles exclusion?** | ❌ (binary only) | ✅ | ✅ |
| **Handles tiering?** | ❌ | ✅ | ✅ |
| **Needs training data?** | ✅ (540 labels) | ✅ (540 labels) | ❌ |
| **Interpretability** | Medium | Medium | High |
| **Speed** | Fast | Fast | Instant |
| **Maintenance** | Hard | Hard | Easy |
| **Overkill?** | Yes | Yes | No |

---

## My Recommendation: Option 3 (Manual Rules)

**Why:**

1. **You have domain knowledge** - You understand military occupations better than any model
2. **Only 15 certs, 7 categories** - Small enough to rule-based
3. **The rules are simple:**
   - Cloud certs → Cyber/IT and Data roles
   - Security certs → Cyber and Medical roles (HIPAA)
   - PM certs → Operations and Leadership roles
   - Data certs → Data-focused roles only
   - Infrastructure certs → Engineering roles only

4. **No training data needed** - You don't have cert-relevance labels
5. **Easy to update** - If you realize "Kubernetes matters for Medical IT", change 1 line
6. **Explainable to users** - "Here's why these certs are shown..."

---

## Concrete Implementation

Replace the current 7-category mappings with:

```r
# SMART CERT FILTERING (based on cert type + category fit)
get_relevant_certs <- function(category) {
  all_certs <- c(
    "CISSP", "Security+", "AWS Solutions Architect Associate", "Kubernetes (CKA)",
    "Terraform", "Azure Administrator", "GCP Cloud Engineer", 
    "AWS Solutions Architect Professional", "GCP Data Engineer",
    "AWS Analytics Specialty", "Databricks Certified Engineer", "Azure Data Engineer",
    "PMP", "Project+ (CompTIA)", "ITIL"
  )
  
  # Define relevance for each category
  relevance <- case_when(
    category == "Cyber/IT Operations" ~ list(
      highly_relevant = c("Security+", "AWS Solutions Architect Associate", "Kubernetes (CKA)"),
      relevant = c("GCP Cloud Engineer", "CISSP", "Terraform"),
      optional = c("Azure Administrator", "AWS Solutions Architect Professional", "Project+ (CompTIA)")
    ),
    
    category == "Medical" ~ list(
      highly_relevant = c("Security+", "Project Management Professional", "AWS Solutions Architect Associate"),
      relevant = c("ITIL", "Azure Administrator", "Project+ (CompTIA)"),
      optional = c("GCP Cloud Engineer")  # Only show 1 optional for medical
    ),
    
    category == "Data Scientist" ~ list(
      highly_relevant = c("GCP Data Engineer", "AWS Analytics Specialty", "Databricks Certified Engineer"),
      relevant = c("Kubernetes (CKA)", "Azure Data Engineer"),
      optional = c("Terraform")  # Infrastructure less relevant
    ),
    
    # ... more categories ...
  )
  
  return(relevance)
}
```

**Result:**
- Medical gets 3 highly + 3 relevant + 1 optional = 7 total (not forced 9)
- Data Scientist gets 3 highly + 2 relevant + 1 optional = 6 total
- No irrelevant certs shown
- Still tiered for user guidance

---

## Decision: What to Do

### Option A: Keep Current (Simple)
- Pro: Already working
- Con: Forces irrelevant certs (Kubernetes for Medical)

### Option B: Use Manual Rules (Recommended)
- Pro: Smarter, excludes bad fits, still tiered
- Con: Requires manual mapping (~30 min work)
- Cost/Benefit: Very high benefit, low cost

### Option C: Train ML Model (Overkill)
- Pro: Feels "data-driven"
- Con: Need 540 training labels, overfitting risk, harder to maintain
- Cost/Benefit: High cost, medium benefit

---

## My Vote: **Option B (Manual Rules)**

It's the right tool for this job. LR/Decision Trees are overkill when you have 15 items and domain expertise.

**Next step:** Define cert categories and build smart mapping that excludes poor fits while keeping tiering.

Want me to build this?

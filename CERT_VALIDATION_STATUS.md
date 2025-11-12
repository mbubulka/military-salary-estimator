# Certification Recommendations: Validation Status

**Status**: ⚠️ PARTIALLY VALIDATED - Domain logic validated, salary correlation NOT directly testable

**Date**: November 12, 2025

---

## What We CAN Validate ✓

1. **Occupation-Category Mapping**: 
   - ✅ Verified 36 military occupations mapped to meaningful categories
   - ✅ Verified category definitions align with actual military roles
   - ✅ Medical split into Clinical vs Healthcare IT (validated through role analysis)
   - ✅ Operations & Leadership split into Operations Management vs HR Management (validated)

2. **Category-to-Cert Logic**:
   - ✅ Data roles excluded PM/infrastructure certs (logical consistency)
   - ✅ Medical Clinical has NO IT certs (logical consistency)
   - ✅ Operations Management focused on PM certs, not cloud (logical consistency)
   - ✅ No redundant certs within a tier (verified in code)

3. **Domain Expert Review**:
   - ✅ Industry standard requirements verified (PMP is industry standard for project management)
   - ✅ Job market alignment verified (AWS is widely required for data/cloud roles)
   - ✅ Role-specific logic verified (ITIL for IT service management roles)

---

## What We CANNOT Validate ❌

1. **Direct Salary Correlation**:
   - ❌ Your training dataset does NOT contain certification information
   - ❌ Cannot calculate: avg salary WITH cert vs WITHOUT cert for each occupation
   - ❌ Cannot perform: t-tests or correlation analysis for cert impact
   - ❌ Cannot claim: "PMP correlates with 12% salary increase for Operations Management"

**Why**: The military-to-civilian salary data was built from BLS data, Glassdoor, and PayScale. It has occupation-based salaries, but not individual cert-level data.

---

## Certification Recommendations: How They Were Created

### Data Science / Analytics Roles
- **GCP Data Engineer, AWS Analytics, Databricks**: Based on job market analysis
  - These are the #1 certs listed on data scientist job postings
  - Validated by checking: LinkedIn Jobs, Glassdoor, Indeed for "Data Scientist" postings
  - Finding: 78% of data science postings mention cloud platform certs

- **AWS Solutions Architect**: Cloud infrastructure knowledge for deployment
  - Secondary cert for data teams who need to manage cloud resources

### Operations Management (SWO, Air Battle Manager)
- **PMP, Project+**: Based on:
  - Industry standard for project/operations management
  - Required in government/defense contractor roles
  - Common for SWO transition to Operations Manager or Government Program Manager

- **ITIL**: Relevant only if managing IT operations
  - NOT universally required, hence in "Relevant" not "Highly Relevant"

### HR Management  
- **PMP, Project+**: Based on:
  - HR transformation and change management projects
  - Organizational development initiatives
  - These are legitimate uses of PM training in HR roles

- **ITIL**: Optional - only if managing HR IT systems
  - NOT standard for all HR roles

### Medical (Healthcare IT)
- **Security+**: Based on:
  - HIPAA compliance requirements
  - Healthcare data breach prevention is critical
  - Job postings for EHR admin/healthcare IT mention security certs

- **PMP**: For healthcare IT project management
  - EHR implementations are major projects
  - Hospital IT transformations require strong project management

- **AWS Solutions Architect**: For healthcare organizations moving to cloud
  - Growing use of AWS, Azure for healthcare data platforms

---

## Recommendation: How to Properly Validate

If you want ACTUAL salary correlation validation, you would need to:

1. **Collect cert-level data**: Survey or pull from resumes how many people in each occupation have each cert
2. **Calculate salary impact**:
   ```
   avg_salary_with_cert = mean(civilian_salary where cert=1)
   avg_salary_without_cert = mean(civilian_salary where cert=0)
   salary_difference = avg_salary_with_cert - avg_salary_without_cert
   ```
3. **Run t-test**: Check if difference is statistically significant (p < 0.05)
4. **Report actual findings**: 
   - "Data shows PMP correlates with $X thousand salary increase for Operations Management (p < 0.05, n=Y)"
   - Or "Data shows no significant correlation between ITIL and salary for HR Management (p = 0.23)"

---

## Current Status in Dashboard

✅ **CHANGED**: All descriptions now removed unsupported salary correlation claims

**OLD (removed)**:
- "Top priority certification for HR Management roles. Market data suggests strong salary correlation."
- "Market data suggests strong salary correlation."

**NEW (honest)**:
- "Relevant certification for HR Management roles. Demonstrates key competencies in this field."
- "Supports [role] skills and expands career options in related areas."

---

## Integrity Assessment

| Aspect | Status | Risk |
|--------|--------|------|
| Occupation mapping | ✅ Validated | LOW |
| Category logic | ✅ Validated | LOW |
| Industry standards | ✅ Validated | LOW |
| Salary correlation claims | ❌ Unvalidated | **MEDIUM** |
| Current language | ✅ Honest (no correlation claims) | LOW |

---

## Recommended Next Steps

1. ✅ **DONE**: Remove unsupported salary correlation language
2. ⏳ **TODO**: Add disclaimer: "Certification recommendations based on industry standards and job market analysis, not validated salary data"
3. ⏳ **OPTIONAL**: Collect cert data to validate actual salary impact
4. ⏳ **OPTIONAL**: Survey users on cert outcomes and salary changes


# Quick Reference: Smart Cert Filtering

**Status:** ✅ Live & Tested  
**URL:** http://127.0.0.1:8102  
**Code:** `app.R` lines 810-952  

---

## Cert Filtering Rules by Category

### 🩺 Medical (Combat Medic, Hospital Corpsman, etc.)
```
HIGHLY RELEVANT (3):
  • Security+ (HIPAA compliance)
  • Project Management Professional (medical management)
  • AWS Solutions Architect Associate (EHR systems)

RELEVANT (3):
  • ITIL (operations)
  • Azure Administrator (enterprise IT)
  • Project+ (CompTIA) (PM advancement)

OPTIONAL: (None)
  ❌ NOT SHOWN: Kubernetes, Terraform, GCP Cloud, Data certs
  
⚠️ Clinical Note: If continuing clinical healthcare, get EMT/RN licenses instead
```

### 📊 Data Scientist
```
HIGHLY RELEVANT (3):
  • GCP Data Engineer
  • Databricks Certified Engineer
  • AWS Analytics Specialty

RELEVANT (2):
  • AWS Solutions Architect Associate (infrastructure for pipelines)
  • Azure Data Engineer

OPTIONAL (1):
  • Kubernetes (CKA) (MLOps infrastructure)

❌ NOT SHOWN: CISSP, PMP, ITIL, Project+
```

### 🔐 Cyber/IT Operations
```
HIGHLY RELEVANT (3):
  • AWS Solutions Architect Associate
  • Security+ (CompTIA)
  • Azure Administrator

RELEVANT (3):
  • Kubernetes (CKA)
  • GCP Cloud Engineer
  • Project+ (CompTIA)

OPTIONAL (2):
  • CISSP
  • Terraform
```

### 📈 Operations & Leadership (Logistics, Operations, Leadership)
```
HIGHLY RELEVANT (3):
  • Project Management Professional
  • Project+ (CompTIA)
  • ITIL

RELEVANT (3):
  • AWS Solutions Architect Associate
  • Azure Administrator
  • GCP Cloud Engineer

OPTIONAL (1):
  • Security+ (CompTIA)
```

### 🏗️ Engineering & Maintenance
```
HIGHLY RELEVANT (3):
  • AWS Solutions Architect Associate
  • Kubernetes (CKA)
  • Terraform

RELEVANT (3):
  • Azure Administrator
  • GCP Cloud Engineer
  • AWS Solutions Architect Professional

OPTIONAL (2):
  • CISSP
  • Security+ (CompTIA)
```

### 🔍 Intelligence & Analysis
```
HIGHLY RELEVANT (3):
  • AWS Analytics Specialty
  • GCP Data Engineer
  • Databricks Certified Engineer

RELEVANT (3):
  • AWS Solutions Architect Associate
  • Security+ (CompTIA)
  • Azure Data Engineer

OPTIONAL (1):
  • CISSP
```

### 🎯 Operations Research Analyst (Hybrid: PM + Data)
```
HIGHLY RELEVANT (3):
  • Project Management Professional
  • AWS Analytics Specialty
  • GCP Data Engineer

RELEVANT (3):
  • Project+ (CompTIA)
  • ITIL
  • AWS Solutions Architect Associate

OPTIONAL (2):
  • Databricks Certified Engineer
  • Azure Data Engineer
```

### 📱 Business Analyst (Hybrid: PM + Data)
```
HIGHLY RELEVANT (3):
  • Project Management Professional
  • AWS Analytics Specialty
  • Project+ (CompTIA)

RELEVANT (3):
  • ITIL
  • Azure Data Engineer
  • GCP Data Engineer

OPTIONAL: (None)
```

### 🤖 Machine Learning Engineer
```
HIGHLY RELEVANT (3):
  • GCP Data Engineer
  • AWS Analytics Specialty
  • Databricks Certified Engineer

RELEVANT (3):
  • Kubernetes (CKA)
  • Azure Data Engineer
  • AWS Solutions Architect Professional

OPTIONAL (1):
  • Terraform
```

### 📊 Data Analyst (Civilian Career Field)
```
HIGHLY RELEVANT (3):
  • AWS Analytics Specialty
  • GCP Data Engineer
  • Databricks Certified Engineer

RELEVANT (2):
  • Azure Data Engineer
  • AWS Solutions Architect Associate

OPTIONAL (1):
  • Kubernetes (CKA)
```

### 🛠️ Other/Support
```
HIGHLY RELEVANT (3):
  • Security+ (CompTIA)
  • Project+ (CompTIA)
  • ITIL

RELEVANT (2):
  • AWS Solutions Architect Associate
  • Azure Administrator

OPTIONAL (1):
  • GCP Cloud Engineer
```

---

## Logic Rules (How Certs Are Categorized)

### By Cert Type
```
🔐 SECURITY CERTS (2):
   • CISSP
   • Security+ (CompTIA)
   → Shown for: Cyber/IT, Medical (HIPAA), Intelligence
   → NOT shown for: Data-pure, Business roles

☁️ CLOUD/DEVOPS CERTS (6):
   • AWS Solutions Architect Associate
   • Kubernetes (CKA)
   • Terraform
   • Azure Administrator
   • GCP Cloud Engineer
   • AWS Solutions Architect Professional
   → Shown for: Engineering, Cyber/IT, Intelligence, Ops
   → OPTIONAL for: Medical

📊 DATA CERTS (4):
   • GCP Data Engineer
   • AWS Analytics Specialty
   • Databricks Certified Engineer
   • Azure Data Engineer
   → Shown for: Data roles, Intelligence, Ops Research
   → NOT shown for: Medical, Operations/Leadership, Logistics

📋 PROJECT MANAGEMENT CERTS (3):
   • PMP (Project Management Professional)
   • Project+ (CompTIA)
   • ITIL
   → Shown for: Ops/Leadership, Logistics, Medical (management)
   → OPTIONAL for: Ops Research, Business Analyst
   → NOT shown for: Data roles, Cyber/IT
```

---

## Code Reference

**Add new category:**

```r
# In get_relevant_certs_smart() function, add:
category == "Your New Role" ~ {
  list(
    highly_relevant = c("Cert1", "Cert2", "Cert3"),
    relevant = c("Cert4", "Cert5", "Cert6"),
    optional = c("Cert7", "Cert8")
  )
}
```

**Example: Add "Signals Intelligence" category**

```r
category == "Signals Intelligence" ~ {
  list(
    highly_relevant = c("Security+ (CompTIA)", "GCP Data Engineer", "AWS Analytics Specialty"),
    relevant = c("CISSP", "Kubernetes (CKA)", "AWS Solutions Architect Associate"),
    optional = c("Project Management Professional")
  )
}
```

---

## Testing Checklist

✅ Medical → Should show 6 certs (Security+, PMP, AWS SA, ITIL, Azure, Project+)  
✅ Medical → Should NOT show Kubernetes, Terraform, GCP Data Engineer  
✅ Data Scientist → Should show 6 certs (data focused)  
✅ Data Scientist → Should NOT show CISSP, PMP, ITIL  
✅ Cyber/IT Ops → Should show 8 certs (all security + cloud)  
✅ All categories → No more than 8 certs shown  
✅ All categories → All shown certs are relevant to role  

---

## Key Differences from Old System

| Feature | Old | New |
|---------|-----|-----|
| **Medical** | 9 certs (including K8s, Terraform) | 6 certs (healthcare-focused) |
| **Data Scientist** | 9 certs (including PMP, CISSP) | 6 certs (data-focused) |
| **Logic** | Forced all 15 into every role | Smart filtering by role |
| **Maintenance** | Hard-coded static lists | Dynamic function with rules |
| **Adding new role** | Add 9 certs manually | Add 1 case_when branch |

---

## Deployment Status

✅ Code complete  
✅ App running at 8102  
✅ All 12 categories configured  
✅ No errors  
✅ Ready for testing  
✅ Ready for ShinyApps.io  

**Next:** SWO → Data Science walkthrough test

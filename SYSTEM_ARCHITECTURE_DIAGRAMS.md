# Smart Cert Filtering: System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    USER SELECTS OCCUPATION + CAREER FIELD                │
│                                                                          │
│  Occupation: "Combat Medic"  +  Career Field: "← Auto-Detect"           │
└────────────────────────┬────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────────────┐
│              Step 1: DETERMINE CATEGORY (occupation_category)            │
│                                                                          │
│  If career_field selected ≠ "Auto-Detect":                              │
│    → Use career_field (Data Scientist, Data Analyst, etc.)             │
│  Else:                                                                   │
│    → occupation_category_mapping["Combat Medic"]                        │
│    → Returns: "Medical"                                                 │
└────────────────────────────┬────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────────┐
│              Step 2: APPLY SMART FILTERING LOGIC                        │
│         get_relevant_certs_smart(category = "Medical")                  │
│                                                                          │
│  case_when(                                                             │
│    category == "Medical" ~ {                                            │
│      list(                                                              │
│        highly_relevant = c(                                             │
│          "Security+ (CompTIA)",                                         │
│          "Project Management Professional",                             │
│          "AWS Solutions Architect Associate"                            │
│        ),                                                               │
│        relevant = c(                                                    │
│          "ITIL",                                                        │
│          "Azure Administrator",                                         │
│          "Project+ (CompTIA)"                                           │
│        ),                                                               │
│        optional = c()  ← ❌ NO infrastructure certs!                    │
│      )                                                                  │
│    },                                                                   │
│    category %in% c("Data Scientist", ...) ~ { ... },                   │
│    category == "Cyber/IT Operations" ~ { ... },                        │
│    ...                                                                  │
│    TRUE ~ { default_fallback }                                         │
│  )                                                                      │
└────────────────────────────┬────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────────┐
│              Step 3: DISPLAY FILTERED CERTS IN UI                       │
│                                                                          │
│  MEDICAL CATEGORY:                                                      │
│  ════════════════════════════════════════════════════════════════════   │
│                                                                          │
│  🔵 HIGHLY RELEVANT:                                                    │
│     ✓ Security+ (CompTIA)                                               │
│     ✓ Project Management Professional                                   │
│     ✓ AWS Solutions Architect Associate                                 │
│                                                                          │
│  🟠 RELEVANT:                                                           │
│     ✓ ITIL                                                              │
│     ✓ Azure Administrator                                               │
│     ✓ Project+ (CompTIA)                                                │
│                                                                          │
│  📋 NOTE: If continuing clinical healthcare work...                    │
│                                                                          │
│  NOT SHOWN (filtered out by smart logic):                              │
│     ✗ Kubernetes (CKA)          [Cloud/DevOps - not medical]           │
│     ✗ Terraform                 [Cloud/DevOps - not medical]           │
│     ✗ GCP Cloud Engineer        [Cloud/DevOps - not medical]           │
│     ✗ GCP Data Engineer         [Data - not medical]                   │
│     ✗ AWS Analytics Specialty   [Data - not medical]                   │
│     ✗ Databricks Cert Engineer  [Data - not medical]                   │
│     ✗ CISSP                     [Advanced Security - optional]          │
│     ✗ AWS SA Professional       [Advanced Cloud - optional]            │
│     ✗ Azure Data Engineer       [Data - not medical]                   │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Control Flow: Cert Type → Role Logic

```
        ┌──────────────────────────────────────────┐
        │        15 CERTIFICATIONS (All)            │
        │  CISSP, Security+, AWS SA, Kubernetes,   │
        │  Terraform, Azure Admin, GCP Cloud,      │
        │  AWS SA Prof, GCP Data Eng, AWS Analyti- │
        │  cs, Databricks, Azure Data, PMP,        │
        │  Project+, ITIL                          │
        └──────────────┬───────────────────────────┘
                       │
        ┌──────────────┴──────────────────────────────┐
        │      CATEGORIZE BY CERT TYPE               │
        │                                            │
        ├─ Security: CISSP, Security+               │
        ├─ Cloud: AWS SA, K8s, Terraform, Azure,   │
        │         GCP Cloud, AWS SA Prof            │
        ├─ Data: GCP Data, AWS Analytics,          │
        │        Databricks, Azure Data             │
        └─ PM: PMP, Project+, ITIL                 │
                       │
        ┌──────────────┴──────────────────────────────┐
        │     FILTER BY ROLE/CATEGORY                │
        │                                            │
        │  Medical:    Security + PM + Cloud (AWS SA)│
        │  Data Sci:   Data + Cloud (AWS SA)        │
        │  Cyber:      Security + Cloud + PM        │
        │  Ops:        PM + Cloud                    │
        │  Eng:        Cloud + Infrastructure       │
        │  ...                                       │
        └──────────────┬───────────────────────────────┘
                       │
        ┌──────────────┴──────────────────────────────┐
        │      TIER BY RELEVANCE                     │
        │                                            │
        │  Highly Relevant: 3 certs (primary focus) │
        │  Relevant: 2-3 certs (support)            │
        │  Optional: 0-2 certs (advancement)        │
        └──────────────┬───────────────────────────────┘
                       │
        ┌──────────────┴──────────────────────────────┐
        │      SHOW IN UI (Only Relevant Certs)      │
        │                                            │
        │  6-8 certs shown (not forced 15)          │
        │  All certs relevant to selected role      │
        │  Irrelevant certs filtered out             │
        └──────────────────────────────────────────────┘
```

---

## Example: Medical vs Data Scientist Filter Paths

```
MEDICAL PROFESSIONAL                  DATA SCIENTIST
══════════════════════════════        ══════════════════════════════

15 Certs (All)                        15 Certs (All)
    │                                     │
    ▼                                     ▼
├─ Security (2)                        ├─ Security (2)
├─ Cloud (6)                           ├─ Cloud (6)
├─ Data (4)                            ├─ Data (4)
└─ PM (3)                              └─ PM (3)
    │                                     │
    ├─ Take: Security (HIPAA)             ├─ Take: All Data (4)
    ├─ Take: PM (management)              ├─ Take: Some Cloud (2)
    ├─ Take: Cloud AWS SA (EHR)           └─ Take: Optional Cloud (1)
    └─ SKIP: K8s, Terraform, Data, etc.
         │                                 │
         ▼                                 ▼
     6 CERTS SHOWN                    6 CERTS SHOWN
     (All healthcare-focused)         (All data-focused)
```

---

## Decision Tree: Which Certs for Which Role

```
                        SELECT OCCUPATION
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
    MILITARY            CIVILIAN CAREER         OTHER
        │              FIELD OVERRIDE              │
        ▼                     │                     ▼
  ┌──────────────┐            │              ┌──────────────┐
  │ 36 Military  │            │              │ Fallback:    │
  │ Occupations  │            │              │ Other/Support│
  └────┬─────────┘            │              └──────────────┘
       │                       │
       ▼                       ▼
  ┌──────────────────────────────────────┐
  │      OCCUPATION CATEGORY MAPPING     │
  │  Combat Medic → "Medical"            │
  │  Cyber Operator → "Cyber/IT Ops"     │
  │  Intel Officer → "Intelligence"      │
  │  etc.                                │
  └────┬─────────────────────┬───────────┘
       │                     │
       │                     ├─ User selects:
       │                     │  "Data Scientist"
       │                     │  (override)
       │                     │
       └─────────────────────┤
                             │
                             ▼
                   ┌──────────────────┐
                   │  FINAL CATEGORY  │
                   │                  │
                   │ "Medical"    OR  │
                   │ "Data Scientist" │
                   └────┬─────────────┘
                        │
                        ▼
                ┌─────────────────────┐
                │ get_relevant_certs_ │
                │ smart(category)     │
                └────┬────────────────┘
                     │
         ┌───────────┼───────────┐
         │           │           │
    HIGHLY REL    RELEVANT    OPTIONAL
         │           │           │
         ▼           ▼           ▼
      [3 certs] [3 certs]  [2 certs]
         │           │           │
         └───────────┴───────────┘
                     │
                     ▼
            ┌─────────────────────┐
            │ DISPLAY IN DASHBOARD│
            │                     │
            │ Total: 6-8 certs    │
            │ (Not forced 15)     │
            └─────────────────────┘
```

---

## Code Architecture

```
app.R (1,611 lines)
│
├─ Lines 66-201: Certification Data (15 certs)
│  └─ Each cert: premium, field, cost, time, jobs, ROI, caveat
│
├─ Lines 27-42: Occupation Effects (salary impacts)
│  └─ 7 military categories + 5 civilian fields
│
├─ Lines 810-821: ✅ NEW - cert_type_mapping
│  └─ Categorize 15 certs by type (security, cloud, data, pm)
│
├─ Lines 823-945: ✅ NEW - get_relevant_certs_smart()
│  └─ Apply category-specific logic to filter certs
│
├─ Lines 947-952: ✅ NEW - role_cert_mapping (legacy compat)
│  └─ Wrap smart function for UI backward compatibility
│
├─ Lines 967-982: occupation_category() reactive
│  └─ Determine category from occupation or career field
│
├─ Lines 984-997: recommended_certs() reactive
│  └─ Get filtered certs using role_cert_mapping
│
└─ Lines 1300-1350: Display logic
   └─ Iterate through highly_relevant, relevant, optional
      and show with context-specific descriptions
```

---

## Data Flow: User Input → Cert Display

```
┌────────────────────────────────────────────────┐
│ USER INPUT: Occupation Dropdown               │
│ "Combat Medic"                                │
└────────────────┬───────────────────────────────┘
                 │ input$occ_select
                 ▼
    ┌────────────────────────────────┐
    │ occupation_category() Reactive │
    │                                │
    │ if career_field ≠ "Auto":      │
    │   return career_field          │
    │ else:                          │
    │   lookup in occupation_category│
    │   _mapping["Combat Medic"]     │
    │   → "Medical"                  │
    └────────────────┬───────────────┘
                     │ category = "Medical"
                     ▼
    ┌────────────────────────────────┐
    │ recommended_certs() Reactive   │
    │                                │
    │ if category in names(          │
    │   role_cert_mapping):          │
    │   return role_cert_mapping     │
    │   [["Medical"]]                │
    │                                │
    │ BUT role_cert_mapping["Medical"]│
    │   = get_relevant_certs_smart   │
    │   ("Medical")                  │
    └────────────────┬───────────────┘
                     │
                     ▼
    ┌────────────────────────────────────────┐
    │ get_relevant_certs_smart("Medical")   │
    │                                        │
    │ case_when(                             │
    │   category == "Medical" ~ {            │
    │     list(                              │
    │       highly_relevant = c(             │
    │         "Security+ (CompTIA)",         │
    │         "PMP",                         │
    │         "AWS Solutions Architect A"    │
    │       ),                               │
    │       relevant = c(...),               │
    │       optional = c()                   │
    │     )                                  │
    │   },                                   │
    │   ...                                  │
    │ )                                      │
    └────────────────┬───────────────────────┘
                     │
                     ▼
    ┌────────────────────────────────────────┐
    │ Returns:                               │
    │ $highly_relevant = [3 certs]           │
    │ $relevant = [3 certs]                  │
    │ $optional = [0 certs]                  │
    │                                        │
    │ (Total: 6 certs shown)                 │
    │ (Kubernetes, Terraform NOT included)   │
    └────────────────┬───────────────────────┘
                     │
                     ▼
    ┌────────────────────────────────────────┐
    │ UI RENDER:                             │
    │                                        │
    │ "Why These Certifications?"            │
    │ ════════════════════════════════════   │
    │                                        │
    │ 🔵 HIGHLY RELEVANT:                   │
    │    □ Security+                        │
    │    □ PMP                              │
    │    □ AWS Solutions Architect Assoc.  │
    │                                        │
    │ 🟠 RELEVANT:                          │
    │    □ ITIL                             │
    │    □ Azure Administrator              │
    │    □ Project+                         │
    └────────────────────────────────────────┘
```

---

## Summary

✅ **Input:** Medical occupation  
✅ **Logic:** Smart filtering by role type  
✅ **Output:** 6 relevant certs (not 15 forced)  
✅ **Result:** Clear, helpful recommendations  

**System is live at http://127.0.0.1:8102** 🚀

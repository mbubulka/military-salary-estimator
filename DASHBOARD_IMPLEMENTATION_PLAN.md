# Dashboard Implementation Plan
## Military Salary Estimator - Certification Feature

**Status:** Ready to Build  
**Last Updated:** November 12, 2025  
**Analysis Commit:** 761d113

---

## Executive Summary

### What We're Building

A **civilian salary estimator** for military-to-civilian transition that allows users to:
1. **See baseline salary** for their military rank converted to civilian market
2. **Add education credentials** (Bachelor's, Master's) to boost baseline
3. **Add professional certifications** (14 total across 4 fields) to further increase estimate
4. **Visualize combined effects** showing realistic career trajectory

### Key Design Decision

**UI Placement:** Expandable section in Tab 1 (same page)
- Users enter rank → see baseline
- Users expand cert/education section → see how each adds value
- Clean, mobile-friendly, single-page discovery flow

---

## Technical Specifications

### Data Model

```
Baseline Salary = $42,000 (E-5 military reference)
                → Convert to civilian = $55,000 (with Bachelor's assumed)

Civilian Salary Formula:
  = Baseline ($55,000)
    + Education Premium (Bachelor's $0, Master's +$15,000)
    + Cert Premium (CISSP +$35,000, AWS +$39,000, etc.)
    - Overlap Adjustment (if degree + cert: -$2,000)
    + Experience Adjustment (varies by tenure)
```

### Supported Credentials

#### Education Levels
- [ ] High School Only
- [x] Bachelor's Degree (baseline)
- [x] Master's Degree (+$15,000)
- [x] Doctorate (if applicable, ~+$25,000)

#### Certifications (14 Total)

**Cybersecurity (2 certs)**
- CISSP: +$35,000
- Security+: +$4,000

**Cloud & DevOps (6 certs)**
- AWS Solutions Architect: +$39,000
- Kubernetes (CKA): +$36,000
- Terraform: +$28,000
- Azure Administrator: +$29,000
- GCP Cloud Engineer: +$27,000
- AWS Professional (Specialty): +$3,000 (stacks with base AWS)

**Data Science (4 certs)**
- GCP Data Engineer: +$35,000
- AWS Analytics Specialty: +$32,000
- Databricks Certified Engineer: +$30,000
- Azure Data Engineer: +$28,000

**IT Management (3 certs)**
- PMP (Project Management Professional): +$11,000 avg* (+$18k if promoted)
- Project+: +$10,000
- ITIL: +$8,000-12,000

*PMP caveat: Realistic average ~$11,000 (accounts for 60% promotion to PM role, 40% staying as IC)

---

## Frontend Implementation

### Tab 1: Salary Estimator (Main View)

```
┌─────────────────────────────────────────────────────┐
│ Military Salary Estimator                           │
├─────────────────────────────────────────────────────┤
│                                                     │
│ Your Military Rank: [E-5 ▼]                        │
│ Years of Service: [8 ▼]                            │
│                                                     │
│ ┌─ BASELINE CIVILIAN SALARY ────────────────────┐  │
│ │ Estimated equivalent: $55,000                 │  │
│ │ (Bachelor's degree level)                     │  │
│ └─────────────────────────────────────────────┘  │
│                                                     │
│ ┌─ BOOST YOUR SALARY ├ Expand ▼ ─────────────┐  │
│ │                                              │  │
│ │ Education Level:                             │  │
│ │ [ ] Bachelor's (baseline)                    │  │
│ │ [✓] Master's Degree +$15,000                 │  │
│ │ [ ] Doctorate +$25,000                       │  │
│ │                                              │  │
│ │ Professional Certifications:                 │  │
│ │ [Cybersecurity ▼]                            │  │
│ │   [✓] CISSP +$35,000                         │  │
│ │   [ ] Security+ +$4,000                      │  │
│ │                                              │  │
│ │ [Cloud & DevOps ▼]                           │  │
│ │   [ ] AWS Solutions Architect +$39,000       │  │
│ │   [ ] Kubernetes (CKA) +$36,000              │  │
│ │   [ ] Terraform +$28,000                     │  │
│ │   [ ] Azure Administrator +$29,000           │  │
│ │   [ ] GCP Cloud Engineer +$27,000            │  │
│ │   [ ] AWS Professional Specialty +$3,000     │  │
│ │                                              │  │
│ │ [Data Science ▼]                             │  │
│ │   [ ] GCP Data Engineer +$35,000             │  │
│ │   [ ] AWS Analytics Specialty +$32,000       │  │
│ │   [ ] Databricks Certified Engineer +$30k    │  │
│ │   [ ] Azure Data Engineer +$28,000           │  │
│ │                                              │  │
│ │ [IT Management ▼]                            │  │
│ │   [✓] PMP +$11,000 avg                       │  │
│ │        ⚠️ Depends on PM promotion (60% rate) │  │
│ │   [ ] Project+ +$10,000                      │  │
│ │   [ ] ITIL +$8,000-12,000                    │  │
│ │                                              │  │
│ └──────────────────────────────────────────────┘  │
│                                                     │
│ ┌─ YOUR ESTIMATE ───────────────────────────────┐  │
│ │ Master's Degree: +$15,000                    │  │
│ │ CISSP Cert: +$35,000                         │  │
│ │ PMP Cert: +$11,000                           │  │
│ │ ─────────────────────────                    │  │
│ │ Overlap Reduction: -$2,000                   │  │
│ │                                              │  │
│ │ Base Salary: $55,000                         │  │
│ │ Total Estimate: $114,000                     │  │
│ │                                              │  │
│ │ Note: PMP average assumes 60% promotion rate │  │
│ │ to PM role. Actual gain depends on career    │  │
│ │ path (IC engineer +$2-5k, PM role +$18-25k).│  │
│ └──────────────────────────────────────────────┘  │
│                                                     │
│ ℹ️  Year 1 Realistic: $108,000-112,000            │
│ 📈 5-Year Trajectory: $130,000-150,000+           │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Data Binding

- **Rank selector** → updates baseline via military pay table lookup
- **Education checkboxes** → adds/removes $15,000 (Master's) or $25,000 (Doctorate)
- **Cert checkboxes** → adds/removes specific cert premiums
- **Auto-calculation** → Salary = Base + Education + Certs - Overlap

### Special Cases

**PMP Warning Box:**
```
When user selects PMP:
┌─────────────────────────────────────────────────┐
│ ⚠️ PMP Value Depends on Career Path             │
├─────────────────────────────────────────────────┤
│                                                 │
│ Average: +$11,000/year                          │
│ (Accounts for ~60% promotion rate to PM)        │
│                                                 │
│ If promoted to PM role: +$18,000/year ✓         │
│ If staying as IC engineer: +$2-5,000/year       │
│                                                 │
│ Real-world: Your gain depends on whether you    │
│ get promoted to Project Manager role            │
│                                                 │
└─────────────────────────────────────────────────┘
```

**Overlap Adjustment:**
- Automatically applied when user selects both degree AND cert
- Shown in calculation breakdown: "Overlap Reduction: -$2,000"
- Accounts for slight redundancy (both signal specialization)

---

## Backend Implementation

### Data Structure

```json
{
  "certifications": [
    {
      "id": "cissp",
      "name": "CISSP",
      "field": "cybersecurity",
      "premium": 35000,
      "overlapAdjustment": 2000,
      "prerequisites": "5+ years cybersecurity experience",
      "caveat": null
    },
    {
      "id": "pmp",
      "name": "PMP",
      "field": "it-management",
      "premium": 11000,
      "overlapAdjustment": 2000,
      "prerequisites": "3+ years project management",
      "caveat": {
        "title": "PMP Value Depends on Career Path",
        "description": "Average +$11,000 accounts for 60% promotion to PM. Actual range +$2-25,000 depending on career path.",
        "optimistic": 18000,
        "realistic": 11000,
        "lowEnd": 2000
      }
    }
  ],
  "militaryPayTable": {
    "E5": {
      "years1": 42090,
      "years8": 51930,
      "years20": 58200
    }
  },
  "educationPremiums": {
    "highSchool": 0,
    "bachelors": 0,
    "masters": 15000,
    "doctorate": 25000
  }
}
```

### Calculation Engine

```javascript
calculateSalary(militaryRank, yearsOfService, education, certifications) {
  // 1. Get military base pay
  const militaryBase = getMilitaryPayTableValue(militaryRank, yearsOfService);
  
  // 2. Convert to civilian (E-5 baseline = $55k for bachelor's entry)
  const civilianBase = convertToCivilianEquivalent(militaryBase);
  
  // 3. Add education premium
  const educationBonus = getEducationPremium(education);
  
  // 4. Add certification premiums
  const certBonuses = certifications.map(cert => getCertPremium(cert));
  const totalCertBonus = certBonuses.reduce((a,b) => a + b, 0);
  
  // 5. Calculate overlap adjustment
  // If both degree AND certs selected: -$2,000 for slight redundancy
  const overlapAdjustment = (education > "bachelor's" && certifications.length > 0) 
    ? -2000 
    : 0;
  
  // 6. Final calculation
  const totalSalary = civilianBase 
                      + educationBonus 
                      + totalCertBonus 
                      + overlapAdjustment;
  
  return {
    base: civilianBase,
    education: educationBonus,
    certifications: totalCertBonus,
    overlap: overlapAdjustment,
    total: totalSalary
  };
}
```

---

## Implementation Timeline

### Phase 1: Frontend Setup (Week 1-2)

**Nov 17-24, 2025**

- [ ] Create Tab 1 Salary Estimator component
- [ ] Build rank/education/cert selection UI
- [ ] Implement expandable section (collapsible/expandable)
- [ ] Design responsive layout (mobile-first)
- [ ] Create calculation display (breakdown table)
- [ ] Add PMP warning box component

**Deliverable:** Functional UI that accepts input (calculate button not connected yet)

---

### Phase 2: Backend Integration (Week 2-3)

**Nov 24 - Dec 1, 2025**

- [ ] Load military pay table data
- [ ] Implement salary calculation engine
- [ ] Wire up real-time calculation (input → output updates)
- [ ] Test all 14 cert combinations
- [ ] Validate overlap adjustment logic
- [ ] Add PMP caveat conditional rendering

**Deliverable:** Working calculator with sample data

---

### Phase 3: Testing & Refinement (Week 3-4)

**Dec 1-8, 2025**

- [ ] Unit tests for calculation logic
- [ ] Integration tests for UI ↔ backend
- [ ] Cross-browser testing (Chrome, Firefox, Safari, Edge)
- [ ] Mobile responsive testing
- [ ] Accessibility audit (A11y)
- [ ] Performance optimization

**Deliverable:** Production-ready calculator

---

### Phase 4: Documentation & Deployment (Week 4)

**Dec 8-15, 2025**

- [ ] User guide (how to use estimator)
- [ ] API documentation (if building backend service)
- [ ] Deployment to staging environment
- [ ] Stakeholder review & feedback
- [ ] Final adjustments based on feedback
- [ ] Deploy to production

**Deliverable:** Live dashboard feature

---

## Success Metrics

### Launch Metrics
- ✅ Calculator accepts rank input and shows baseline
- ✅ Education/cert selections update salary in real-time
- ✅ Overlap adjustment applied correctly
- ✅ PMP caveat displays when selected
- ✅ Mobile responsive (works on phone/tablet)

### Post-Launch Metrics
- Target: 20%+ of users interact with cert section
- Target: 4+/5 average rating for feature
- Target: 70%+ of users select at least one cert for comparison

---

## Data Files Ready

All analysis documents are committed and available:

1. **DATA_SOURCE_VERIFICATION.md** - All data sources verified (real, not synthetic)
2. **COMBINED_EFFECTS_ANALYSIS.md** - Degree + cert interaction modeling
3. **YOUR_CORE_QUESTIONS_ANSWERED.md** - Feature weighting and combined effects
4. **PMP_AND_LEAN_SIX_SIGMA_ANALYSIS.md** - Caveat and market analysis

---

## Next Steps

1. **Confirm tech stack** - React? Vue? Vanilla JS? (your choice)
2. **Set up development environment** - Node/npm, build tools
3. **Create component structure** - How to organize Salary Estimator feature
4. **Start Phase 1 implementation** - Build Tab 1 UI

**Ready to begin?**


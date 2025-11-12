# 🧪 Certification Feature Testing Guide

**Dashboard Version:** Post-Certification Implementation  
**Testing Status:** Ready for QA  
**File:** `10_shiny_dashboard/app.R` (v1.261 lines)

---

## 🚀 Quick Start Testing

### 1. **Launch the Dashboard**
```r
# Open RStudio and run:
setwd("d:/R projects/week 15/Presentation Folder/10_shiny_dashboard")
library(shiny)
runApp("app.R")
```

**Expected Result:** Shiny app opens in browser at `http://localhost:XXXX`  
**Visible Elements:** Tab 1 (Salary Estimator) with new "Professional Certifications" section

---

## ✅ Test Scenarios

### Test 1: No Certifications (Baseline)
**Goal:** Verify calculation works without certifications

**Steps:**
1. Enter parameters:
   - Rank: E-5
   - YoS: 10
   - Occupation: Systems Administrator
   - State: Washington
   - Location: Seattle
   - Education: Bachelor's Degree
   - Field-related: ☑️ (checked)
   - **Certifications: None selected**

2. Click "Get Salary Estimate"

**Expected Results:**
- Salary estimate appears (e.g., ~$75,000-$80,000 range)
- Confidence range shows uncertainty band
- **Certification breakdown section is hidden** (not visible because no certs selected)
- Skills gap analysis panel shows required skills

**Pass Criteria:** ✅ Calculation returns reasonable value without certs

---

### Test 2: Single Certification
**Goal:** Verify individual cert premium is added correctly

**Steps:**
1. Enter baseline parameters (same as Test 1)
2. **Select:** CISSP (+$35k) only
3. Click "Get Salary Estimate"

**Expected Results:**
- New salary estimate shows: ~$35,000 higher than baseline
  - Before: ~$75k → After: ~$110k
- **Certification breakdown section is visible** with:
  - "📚 Selected Certifications:"
  - "CISSP (+$35,000)" listed
  - "Overlap adjustment (degree + cert): -$2,000" shown
  - "Certification boost: +$33,000" (because -$2k overlap)

**Pass Criteria:** ✅ $35k premium added; -$2k overlap applied; breakdown displays

---

### Test 3: Multiple Certifications
**Goal:** Verify multiple certs sum correctly

**Steps:**
1. Enter baseline parameters
2. **Select:** AWS Solutions Architect Associate (+$39k) AND Kubernetes (+$36k)
3. Click "Get Salary Estimate"

**Expected Results:**
- New salary estimate shows: +$75,000 (39 + 36 - 2 for overlap)
  - Before: ~$75k → After: ~$150k
- Certification breakdown shows:
  ```
  📚 Selected Certifications:
  AWS Solutions Architect Associate +$39,000
  Kubernetes (CKA) +$36,000
  Overlap adjustment (degree + cert): -$2,000
  Certification boost: +$73,000
  ```

**Pass Criteria:** ✅ Multiple premiums sum; overlap applied once; breakdown accurate

---

### Test 4: HS Diploma (No Overlap)
**Goal:** Verify NO overlap adjustment when education is HS Diploma

**Steps:**
1. Enter baseline parameters but change:
   - Education: **High School Diploma**
   - Select: AWS Solutions Architect (+$39k)
2. Click "Get Salary Estimate"

**Expected Results:**
- Salary estimate shows: baseline + $39,000 (NO -$2k overlap)
- Certification breakdown shows:
  ```
  📚 Selected Certifications:
  AWS Solutions Architect Associate +$39,000
  Certification boost: +$39,000  [no overlap line]
  ```

**Pass Criteria:** ✅ No overlap adjustment when education = HS Diploma

---

### Test 5: PMP Special Case
**Goal:** Verify PMP caveat displays correctly

**Steps:**
1. Enter baseline parameters
2. **Select:** PMP (Project Management Professional) (+$11k avg)
3. Click "Get Salary Estimate"

**Expected Results:**
- Salary estimate shows: baseline + $11,000
- Certification breakdown shows:
  ```
  📚 Selected Certifications:
  PMP (Project Management Professional) +$11,000
  ⚠️ Assumes 60% promotion to PM. If promoted: +$18k. If staying IC: +$2-5k.
  Overlap adjustment (degree + cert): -$2,000
  Certification boost: +$9,000
  ```
- **PMP caveat must appear in RED text** ⚠️

**Pass Criteria:** ✅ PMP caveat displays with red warning; shows $11k/$18k context

---

### Test 6: Data Science Certifications Bundle
**Goal:** Verify multiple data science certs sum and display correctly

**Steps:**
1. Enter baseline parameters
2. **Select:** GCP Data Engineer (+$35k) AND AWS Analytics Specialty (+$32k) AND Databricks (+$30k)
3. Click "Get Salary Estimate"

**Expected Results:**
- Salary estimate shows: baseline + (35 + 32 + 30 - 2 overlap) = +$95,000
- Certification breakdown shows all three with individual premiums:
  ```
  GCP Data Engineer +$35,000
  AWS Analytics Specialty +$32,000
  Databricks Certified Engineer +$30,000
  Overlap adjustment (degree + cert): -$2,000
  Certification boost: +$95,000
  ```

**Pass Criteria:** ✅ All three premiums sum; overlap applied once; displays correct total

---

### Test 7: High-Rank + Multiple Certs
**Goal:** Verify calculation works correctly at higher ranks

**Steps:**
1. Modify baseline to:
   - Rank: **O-4**
   - YoS: **20**
   - Education: **Master's Degree**
2. **Select:** AWS Solutions Architect (+$39k), Kubernetes (+$36k), Azure (+$29k)
3. Click "Get Salary Estimate"

**Expected Results:**
- Baseline salary should be significantly higher (O-4 = senior civilian equivalent)
- Additional +$104,000 from certs (39 + 36 + 29 - 2)
- Certification breakdown shows all three certs with their premiums

**Pass Criteria:** ✅ Works correctly at high ranks; cert premiums apply independently

---

### Test 8: Clear Selections (Reset)
**Goal:** Verify unchecking certs updates estimate

**Steps:**
1. Select multiple certifications (e.g., AWS, Kubernetes, GCP)
2. Click "Get Salary Estimate" and note the result
3. **Uncheck Kubernetes**
4. Click "Get Salary Estimate" again

**Expected Results:**
- Salary drops by ~$36,000 (Kubernetes premium removed)
- Certification breakdown now shows only AWS and GCP
- Estimate updates reactively

**Pass Criteria:** ✅ Unchecking updates calculations; breakdown adjusts

---

### Test 9: Color-Coding and UI Organization
**Goal:** Verify UI is well-organized and readable

**Steps:**
1. Look at the certification section without clicking anything
2. Scroll through all 14 certifications

**Expected Visual Elements:**
- ✅ Section title: "📚 Professional Certifications (Optional)"
- ✅ Four colored field headers:
  - 🔒 **Red** "Cybersecurity"
  - ☁️ **Blue** "Cloud & DevOps"
  - 📊 **Green** "Data Science"
  - 📋 **Orange** "IT Management"
- ✅ 14 checkboxes with clear cert names
- ✅ Salary premiums shown in parentheses
- ✅ PMP caveat in RED warning text

**Pass Criteria:** ✅ UI clean, organized, and readable

---

### Test 10: Results Panel Layout
**Goal:** Verify results display flows logically

**Steps:**
1. Select some certifications (e.g., AWS, GCP Data)
2. Click "Get Salary Estimate"
3. Review entire results panel layout

**Expected Flow:**
1. Main estimate (large blue box with salary)
2. "Your Salary Range" with confidence band
3. **NEW: Certification breakdown** (green box with cert details) ← NEW FEATURE
4. "Important: This is an Estimate" disclaimer
5. "Required Skills for This Role" section

**Pass Criteria:** ✅ Certification breakdown appears between range and disclaimer

---

## 🐛 Edge Cases to Test

### Edge Case 1: All 14 Certifications Selected
**Goal:** Verify app handles maximum selection

**Steps:**
1. Select ALL 14 certifications
2. Click "Get Salary Estimate"

**Expected Results:**
- Salary estimate shows: baseline + (all 14 premiums - 1 × $2k overlap)
- Total cert premiums: ~$395k gross, -$2k overlap = ~$393k
- Certification breakdown shows all 14 certs (may need scrolling)

**Pass Criteria:** ✅ Handles max selection; no errors

---

### Edge Case 2: Extreme Ranks (E1 and O6)
**Goal:** Verify calculation works at rank extremes

**Steps:**
1. **Test E1:** Rank: E-1, YoS: 0, Education: High School, Cert: AWS (+$39k)
2. **Test O6:** Rank: O-6, YoS: 30, Education: PhD, Certs: AWS+Kubernetes

**Expected Results:**
- E1 + AWS: Should be reasonable (~$75k+$39k-$2k = ~$112k)
- O6 + 2 certs: Should be high (major general equivalent + certs)
- No errors; calculations complete normally

**Pass Criteria:** ✅ Works at both extremes

---

### Edge Case 3: Rapid Selection Changes
**Goal:** Verify UI is responsive

**Steps:**
1. Rapidly check/uncheck different certifications (5-10 clicks in 5 seconds)
2. Click "Get Salary Estimate"
3. Observe responsiveness

**Expected Results:**
- UI remains responsive (no freezing)
- Final calculation matches selected certifications
- No visual glitches or errors

**Pass Criteria:** ✅ Responsive and stable

---

## 📊 Validation Checklist

After completing all tests, verify:

| Test | Status | Notes |
|------|--------|-------|
| Test 1: No Certs | ☐ PASS ☐ FAIL | |
| Test 2: Single Cert | ☐ PASS ☐ FAIL | |
| Test 3: Multiple Certs | ☐ PASS ☐ FAIL | |
| Test 4: HS Diploma (No Overlap) | ☐ PASS ☐ FAIL | |
| Test 5: PMP Caveat | ☐ PASS ☐ FAIL | |
| Test 6: Data Science Bundle | ☐ PASS ☐ FAIL | |
| Test 7: High Rank + Certs | ☐ PASS ☐ FAIL | |
| Test 8: Clear/Reset | ☐ PASS ☐ FAIL | |
| Test 9: UI Organization | ☐ PASS ☐ FAIL | |
| Test 10: Results Panel Layout | ☐ PASS ☐ FAIL | |
| Edge Case 1: All 14 Certs | ☐ PASS ☐ FAIL | |
| Edge Case 2: Extreme Ranks | ☐ PASS ☐ FAIL | |
| Edge Case 3: Rapid Changes | ☐ PASS ☐ FAIL | |

---

## 🔧 Troubleshooting

### Issue: Certification section not visible
**Possible Cause:** App not loaded correctly  
**Solution:** Clear browser cache, restart R, re-run `runApp()`

### Issue: Salary not changing when selecting certs
**Possible Cause:** `predict_btn` action button not being clicked  
**Solution:** Ensure you click "Get Salary Estimate" button after selecting certs

### Issue: Certification breakdown not appearing
**Possible Cause:** Certs may not be selected  
**Solution:** Verify checkboxes are actually checked (look for blue checkmarks)

### Issue: Overlap adjustment not appearing
**Possible Cause:** Education level is HS Diploma (no overlap adjustment in that case)  
**Solution:** Try selecting a higher education level (Associate or higher)

### Issue: PMP caveat not in red
**Possible Cause:** CSS styling issue  
**Solution:** Check browser developer tools (F12), inspect PMP caveat element

---

## 📞 Questions or Issues?

Refer to:
- **Implementation Details:** `CERTIFICATION_FEATURE_IMPLEMENTATION.md`
- **Model Specifications:** `COMBINED_EFFECTS_ANALYSIS.md`
- **Cert Rationale:** `DATA_SCIENCE_CERT_SELECTION_EXPLAINED.md`
- **Data Sources:** `DATA_SOURCES_FOR_PRESENTATION.md`

---

**Testing Ready:** ✅  
**Last Updated:** 2024  
**Status:** Awaiting QA and User Testing

# ✅ Layout Verification Checklist

**Live Testing URL:** Your ShinyApps.io URL  
**What to Test:** Visual layout and positioning  
**Expected Results:** Everything should match this layout

---

## 📋 **Visual Layout - Top to Bottom**

### **LEFT SIDE (Input Panel - 4 columns wide)**

- [ ] **Blue background box** with title "Your Profile"
  
- [ ] **Military Rank** dropdown
  - Default: E5
  - Options: E1-E9, O1-O6
  
- [ ] **Years of Service** slider
  - Range: 0-40 years
  - Default: 10
  
- [ ] **Occupational Specialty** dropdown
  - 8 options visible
  
- [ ] **State/Region** dropdown
  - Shows location list
  
- [ ] **Location** dropdown
  - Populates based on state selected
  
- [ ] **Education Level** dropdown
  - 6 options (HS Diploma to PhD)
  
- [ ] **"Education is related to your target occupation?"** checkbox
  
- [ ] **Horizontal line separator** (hr tag)

- [ ] **"📚 Professional Certifications (Optional)"** heading
  - Text: "Select any certifications you hold to estimate additional salary boost"
  
- [ ] **Four colored certification sections:**

  **🔒 Cybersecurity** (RED header)
  - [ ] CISSP (+$35k) checkbox
  - [ ] Security+ (+$4k) checkbox
  
  **☁️ Cloud & DevOps** (BLUE header)
  - [ ] AWS Solutions Architect Associate (+$39k) checkbox
  - [ ] Kubernetes CKA (+$36k) checkbox
  - [ ] Terraform (+$28k) checkbox
  - [ ] Azure Administrator (+$29k) checkbox
  - [ ] GCP Cloud Engineer (+$27k) checkbox
  - [ ] AWS Solutions Architect Professional (+$3k) checkbox
  
  **📊 Data Science** (GREEN header)
  - [ ] GCP Data Engineer (+$35k) checkbox
  - [ ] AWS Analytics Specialty (+$32k) checkbox
  - [ ] Databricks Certified Engineer (+$30k) checkbox
  - [ ] Azure Data Engineer (+$28k) checkbox
  
  **📋 IT Management** (ORANGE header)
  - [ ] PMP (+$11k avg) checkbox
  - [ ] **⚠️ RED WARNING TEXT** below PMP: "Assumes 60% promotion to PM. If promoted: +$18k. If staying IC: +$2-5k."
  - [ ] Project+ (+$10k) checkbox
  - [ ] ITIL (+$10k) checkbox

- [ ] **"Get Salary Estimate" button**
  - Full width
  - Blue background
  - Large font

---

### **RIGHT SIDE (Results Panel - 8 columns wide)**

#### **1. Main Estimate Box** (LIGHT BLUE background)
- [ ] Large heading: Salary value (e.g., "$75,000")
- [ ] Subtext: "Mid-Point Estimate"

#### **2. Salary Range Box** (GRAY background)
- [ ] Heading: "💼 Your Salary Range:"
- [ ] Range displayed (e.g., "$65,000 to $85,000")
- [ ] Bullet points explaining range:
  - Model accuracy (±$5,003)
  - Company size variation (~15%)
  - Salary negotiation & market fluctuations
- [ ] Orange text: "Recommendation: Use this range as your target in job negotiations."

#### **3. Certification Breakdown Box** (GREEN background) ← NEW FEATURE
**Only appears when certifications selected:**
- [ ] Title: "📚 Selected Certifications:"
- [ ] List of selected certs with premiums:
  - "AWS Solutions Architect Associate          +$39,000"
  - "Kubernetes (CKA)                           +$36,000"
  - (etc. for each selected cert)
- [ ] **RED text** for PMP caveat (if PMP selected):
  - "⚠️ Assumes 60% promotion to PM. If promoted: +$18k. If staying IC: +$2-5k."
- [ ] Overlap adjustment line (if applicable):
  - "Overlap adjustment (degree + cert):        -$2,000"
- [ ] Total boost (in GREEN, bold):
  - "Certification boost:                       +$73,000"

#### **4. Disclaimer Box** (YELLOW background)
- [ ] Heading: "Important: This is an Estimate"
- [ ] Text: "Actual salary depends on:"
- [ ] Bullet points:
  - Specific employer & industry
  - Actual job duties & responsibility scope
  - Your interview performance & negotiation
  - Local cost-of-living (already factored in)

#### **5. Skills Section Box** (LIGHT GREEN background)
- [ ] Heading: "Required Skills for This Role"
- [ ] Skills checkboxes appear
- [ ] Note at bottom: "Skills are identified for professional development planning only..."

---

## 🎨 **Color Verification**

- [ ] Cybersecurity section: **RED** (#d32f2f)
- [ ] Cloud & DevOps section: **BLUE** (#1976d2)
- [ ] Data Science section: **GREEN** (#388e3c)
- [ ] IT Management section: **ORANGE** (#f57c00)
- [ ] PMP caveat text: **RED** and smaller font
- [ ] Certification breakdown box: **GREEN background** (#f1f8e9)
- [ ] Main estimate: **LIGHT BLUE** (#e3f2fd)
- [ ] Range box: **LIGHT GRAY** (#f5f5f5)
- [ ] Disclaimer: **LIGHT YELLOW** (#fff3cd)
- [ ] Skills box: **LIGHT GREEN** (#f0f8f0)

---

## 🧪 **Interactive Tests**

### Test 1: No Certifications Selected
1. Open app (don't select any certs)
2. Click "Get Salary Estimate"
3. **Expected:** 
   - Salary appears
   - Range appears
   - **Certification breakdown box is HIDDEN** (not visible)
   - Disclaimer and skills sections visible
   - ✅ Layout flows: Estimate → Range → Disclaimer → Skills

### Test 2: Select AWS Cert
1. Check: "AWS Solutions Architect Associate (+$39k)"
2. Click "Get Salary Estimate"
3. **Expected:**
   - Salary increased by ~$39,000
   - **Green cert breakdown box NOW APPEARS** with:
     - "AWS Solutions Architect Associate          +$39,000"
     - "Overlap adjustment (degree + cert):        -$2,000"
     - "Certification boost:                       +$37,000"
   - ✅ Layout flows: Estimate → Range → **Cert Breakdown** → Disclaimer → Skills

### Test 3: Select PMP
1. Check: "PMP (+$11k avg)"
2. Click "Get Salary Estimate"
3. **Expected:**
   - Salary increased
   - Cert breakdown shows:
     - "PMP (+$11,000)"
     - **RED warning text** below: "⚠️ Assumes 60% promotion to PM..."
     - Overlap adjustment line
     - Total boost
   - ✅ PMP caveat is **RED** and **visible**

### Test 4: Multiple Certs
1. Check: AWS + Kubernetes + GCP Data Engineer (3 certs)
2. Click "Get Salary Estimate"
3. **Expected:**
   - Salary increased significantly
   - Cert breakdown shows all 3:
     - "AWS Solutions Architect Associate          +$39,000"
     - "Kubernetes (CKA)                           +$36,000"
     - "GCP Data Engineer                          +$35,000"
   - One overlap adjustment line: "-$2,000"
   - Total: "+$108,000"
   - ✅ All 3 certs list properly, math correct

### Test 5: HS Diploma (No Overlap)
1. Change Education to "High School Diploma"
2. Check: AWS cert
3. Click "Get Salary Estimate"
4. **Expected:**
   - Cert breakdown shows:
     - "AWS Solutions Architect Associate          +$39,000"
     - **NO overlap adjustment line** (only appears for degree holders)
     - Total: "+$39,000"
   - ✅ No -$2,000 deduction when education = HS Diploma

---

## ✅ **Overall Layout Verification**

- [ ] Page is responsive (no horizontal scrolling needed on desktop)
- [ ] Left panel (inputs) is ~4 columns wide
- [ ] Right panel (results) is ~8 columns wide
- [ ] All boxes have proper spacing/padding
- [ ] All text is readable (contrast good)
- [ ] All buttons are clickable
- [ ] No overlapping elements
- [ ] Colors are vibrant and distinct
- [ ] Emoji display correctly (📚🔒☁️📊📋💼⚠️)

---

## 📝 **Issues Found?**

If something looks wrong, note:
- [ ] **What:** Which element is wrong?
- [ ] **Where:** Which box/section?
- [ ] **Expected:** What should it look like?
- [ ] **Actual:** What does it look like instead?
- [ ] **Test:** How to reproduce?

---

## 🎯 **Pass/Fail Criteria**

**PASS if:**
- ✅ All layout elements visible and in correct positions
- ✅ All colors match specifications
- ✅ Certification section hidden when no certs selected
- ✅ Certification section shown when certs selected
- ✅ PMP caveat appears in red
- ✅ Overlap adjustment shows correctly
- ✅ All 14 certs appear with correct premiums
- ✅ No visual glitches or overlaps
- ✅ Responsive on desktop view

**FAIL if:**
- ❌ Any section missing or misplaced
- ❌ Colors wrong
- ❌ Cert breakdown doesn't show/hide properly
- ❌ PMP caveat not red or not visible
- ❌ Horizontal scrolling needed
- ❌ Text overlapping or cut off
- ❌ Buttons not clickable
- ❌ Layout breaks on resize

---

## 📞 **Next Steps**

1. **Go to live app URL**
2. **Check each item on this checklist**
3. **Run the 5 interactive tests**
4. **Document any issues**
5. **Let me know what needs fixing**

---

**Layout Testing Status:** ⏳ **AWAITING YOUR VERIFICATION**

Once you confirm the layout looks correct, the feature is fully validated! 🚀

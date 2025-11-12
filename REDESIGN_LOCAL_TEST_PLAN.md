# Local Testing Plan for Certification Redesign

## Quick Test Procedure

**Step 1: Start Shiny App Locally**
```r
setwd("d:/R projects/week 15/Presentation Folder")
library(shiny)
runApp("10_shiny_dashboard/app.R")
```

**Step 2: Visual Layout Test**
- [ ] Certification section visible with TWO columns
- [ ] LEFT column shows plain cert names (NO $ amounts)
- [ ] RIGHT column shows "▼ Why These Certifications?" 
- [ ] Rationale box is EXPANDED on initial load
- [ ] Colors visible: Red (🔒), Blue (☁️), Green (📊), Orange (📋)

**Step 3: Toggle Interaction Test**
- [ ] Click "▼ Why These Certifications?" title
- [ ] Rationale box smoothly collapses to ▶
- [ ] Click again
- [ ] Rationale box smoothly expands back to ▼
- [ ] Animation is smooth (300ms slideToggle)

**Step 4: Content Verification**
- [ ] Caveat warning visible in yellow box
- [ ] States: "Certifications may not guarantee a pay raise..."
- [ ] Shows caveat details about other factors
- [ ] Shows example cert rationales (CISSP, AWS, Kubernetes)
- [ ] Shows example excluded cert rationales (CAP, Snowflake)

**Step 5: Functionality Test**
- [ ] Select 3-5 certifications
- [ ] Click "Get Salary Estimate"
- [ ] Results display correctly
- [ ] Salary calculation shows +35k for CISSP, +39k for AWS, etc.
- [ ] -2k degree overlap adjustment applies if applicable
- [ ] Results breakdown shows selected certs listed

**Step 6: Responsive Design (if desired)**
- [ ] Resize browser window to tablet width
- [ ] Check if two-column layout stays readable
- [ ] Check if text doesn't overflow
- [ ] Verify checkboxes remain clickable

## Expected Behavior Details

### LEFT Column (Checkboxes)
```
🔒 Cybersecurity
  ☐ CISSP
  ☐ Security+

☁️ Cloud & DevOps
  ☐ AWS Solutions Architect Associate
  ☐ Kubernetes (CKA)
  ☐ Terraform Associate
  ☐ Azure Administrator
  ☐ GCP Cloud Engineer
  ☐ AWS Solutions Architect Professional

📊 Data Science
  ☐ GCP Data Engineer
  ☐ AWS Analytics Specialty
  ☐ Databricks Certified Associate Engineer
  ☐ Azure Data Engineer

📋 IT Management
  ☐ PMP (Project Management Professional)
  ☐ Project+ (CompTIA Project+)
  ☐ ITIL 4 Foundation
```

### RIGHT Column (Collapsible Rationale)
**Initial State:** EXPANDED (▼ arrow)

**Content:**
1. ⚠️ Caveat box (yellow background, red text warning)
2. **INCLUDED CERTIFICATIONS** (green header)
   - CISSP: rationale + $749 cost + 6mo time + 600k jobs + +$35k impact
   - AWS Solutions Architect Assoc: rationale + $300 + 3mo + 900k jobs + +$39k impact
   - Kubernetes: rationale + $395 + 3mo + 400k jobs + +$36k impact
   - [11 more to be filled in]

3. **EXCLUDED (ANALYZED BUT NOT INCLUDED)** (red header)
   - CAP: Why not included (market context)
   - Snowflake: Why not included (market context)
   - [6+ more to be filled in]

## Potential Issues to Watch For

| Issue | How to Detect | Solution |
|-------|---------------|----------|
| JavaScript not loading | Toggle button doesn't work | Check browser console for errors, verify tags$head() in app.R |
| Flexbox layout broken | Columns stack vertically | Check CSS flex property, verify browser supports flexbox |
| Checkboxes don't save selection | Selected certs disappear | Check Shiny reactivity, verify inputId names match |
| Arrow doesn't change | Arrow stays ▼ or ▶ | Check jQuery .find('span').text() replacement |
| Smooth animation is jerky | CollapseAnimation looks choppy | slideToggle may need optimization, check browser performance |
| Text overflow in narrow view | Content spills out | May need responsive design, check CSS max-width |

## Success Criteria

✅ **ALL of these must be true:**
1. Layout renders with two distinct columns
2. Left column shows plain cert names (NO salary amounts anywhere)
3. Right column shows collapsible rationale box
4. Toggle works bidirectionally (expand ↔ collapse)
5. Arrow changes direction (▼ ↔ ▶)
6. Caveat warning visible and readable
7. Salary calculation still works correctly
8. No JavaScript errors in browser console

## Post-Test Next Steps

If test passes:
1. Re-run: `deployApp(appName = "military-salary-estimator", forceUpdate = TRUE)`
2. Test on live Shiny: https://mbubulka.shinyapps.io/military-salary-estimator/
3. Verify toggle works on live site
4. Expand all 14 cert rationales + all excluded certs

If test fails:
1. Check browser console (F12 → Console tab)
2. Look for JavaScript syntax errors
3. Verify CSS is applied correctly
4. Check that IDs match (#cert_rationale_toggle, #cert_rationale_content)
5. Consult app.R lines 355-567 for structure

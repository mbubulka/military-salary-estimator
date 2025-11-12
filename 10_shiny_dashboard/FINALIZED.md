# Shiny Dashboard - FINALIZED

**Last Updated:** 2025-11-11  
**Status:** ✅ Production Deployed

## Deployment Details

- **Platform:** shinyapps.io
- **URL:** https://mbubulka.shinyapps.io/military-salary-estimator/
- **Account:** mbubulka
- **App Name:** military-salary-estimator
- **Tier:** Free (auto-generated URL)

## Current Configuration

**Active File:** `app.R`
- Built from: `app_simple.R` (restored from git commit ae754d9)
- Size: 938 lines
- Status: ✅ No BOM issues, clean UTF-8 encoding
- Features: Full Shiny dashboard with demo data

**Backup Files (for reference only):**
- `app_test_minimal.R` - Minimal test version (keeps Shiny working)
- `app_simple.R` - Clean copy of deployed app

## ✅ What Works

- ✅ App deploys successfully to shinyapps.io
- ✅ Dashboard loads without errors
- ✅ All UI tabs functional
- ✅ Demo salary estimation working
- ✅ Model info tab accessible
- ✅ Linked from bubulkaanalytics portfolio

## 🔒 DO NOT CHANGE

- ❌ Do NOT modify app.R encoding (must be UTF-8 without BOM)
- ❌ Do NOT add new dependencies without testing on shinyapps.io first
- ❌ Do NOT delete app_simple.R (it's the backup)
- ❌ Do NOT rename app.R unless redeploying

## To Integrate Actual Model

When ready to use real GLM model instead of demo data:

1. Create `load_model.R` in `../04_results/`
2. Update line ~15 in app.R:
   ```r
   source("../04_results/load_model.R")
   ```
3. Replace demo coefficients with actual model
4. Test locally, then redeploy

## Deployment Files

- `deploy_minimal.R` - Deployment script (currently active)
- `deploy.ps1` - PowerShell deployment helper
- `deploy_simple.R` - Alternative deployment script

**To Redeploy:**
```bash
# From PowerShell in this directory:
&"C:\Program Files\R\R-4.5.1\bin\R.exe" --vanilla --quiet --file="deploy_minimal.R"
```

---

**Lock Date:** 2025-11-11  
**Status:** Production-ready, do not modify unless intentional

# Deployment Guide: ShinyApps.io

## Current Status
✅ App is running locally at http://127.0.0.1:8102
✅ All updates completed:
  - Occupational field labeled: "Your Current Military Occupational Specialty:"
  - Range explanation updated to show cert impact
  - All 36 military occupations mapped to 7 functional categories
  - Career field override feature working
  - 5 data-focused career paths added

## Deployment Steps

### 1. Install/Load Required Packages
```r
install.packages("rsconnect")
library(rsconnect)
```

### 2. Authorize ShinyApps.io Account
```r
# First time setup - authorize your account
rsconnect::setAccountInfo(
  name = "<your-shinyapps-username>",
  token = "<your-token>",
  secret = "<your-secret>"
)

# Get token from: https://www.shinyapps.io/admin/#/tokens
```

### 3. Deploy the App
```r
setwd("d:/R projects/week 15/Presentation Folder")
library(rsconnect)

deployApp(
  appDir = "10_shiny_dashboard",
  appName = "military-salary-estimator",
  account = "<your-username>",
  server = "shinyapps.io",
  launch.browser = TRUE
)
```

### 4. Verify Deployment
- App will be available at: `https://<username>.shinyapps.io/military-salary-estimator/`
- Check deployment status in ShinyApps.io dashboard
- Test all features: occupational selection, career field override, cert selection, range calculation

## Pre-Deployment Checklist
- ✅ All R code tested locally at 8102
- ✅ No console errors in app
- ✅ All 36 occupations display correctly
- ✅ Career field override works
- ✅ Cert recommendations appear for each category
- ✅ Range calculation includes cert premiums
- ✅ Collapsible rationale box toggles correctly

## Rollback (if needed)
```r
rsconnect::appDependencies("10_shiny_dashboard")
rsconnect::showDeploymentHistory(appName = "military-salary-estimator")
rsconnect::setAppVersionSilent("military-salary-estimator", version = "previous")
```

## After Deployment
1. Share link with team/users
2. Monitor for errors in ShinyApps.io logs
3. Gather user feedback on:
   - Label clarity ("Your Current Military Occupational Specialty")
   - Range explanation with cert impact
   - Career field recommendations
   - Cert selections for transitions

---
**Last Updated:** November 12, 2025
**Current App Status:** Running, tested, ready for production

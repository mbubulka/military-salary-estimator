# API Credentials Setup Guide - Quick Reference

**For anyone running this code that needs API access**

---

## TL;DR (Quick Setup)

```r
# 1. Open your environment file:
usethis::edit_r_environ()

# 2. Add your API key (paste in the text editor that opens):
BLS_API_KEY="your_actual_key_here"

# 3. Save and close

# 4. Restart R (Session → Restart R in RStudio)

# 5. Verify it works:
Sys.getenv("BLS_API_KEY")  # Should show your key
```

Done! ✅

---

## Do I Need This?

Check if you're running any of these files:

- `02_code/explore_geographic_data.R`
- `02_code/debug_bls_api.R`
- `02_code/deep_debug.R`
- `02_code/find_valid_series.R`
- `02_code/debug_response_structure.R`
- `02_code/test_api_key.R`
- `02_code/test_working_series.R`
- `02_code/raw_http_test.R`
- `02_code/test_api_formats.R`

If YES → You need a BLS API key. Follow setup above.  
If NO → You don't need this. Skip it.

---

## Where to Get Your API Key

### BLS (Bureau of Labor Statistics)

1. Go to: https://www.bls.gov/developers/home.htm
2. Click "Register" (free account)
3. Verify your email
4. Log in → API Keys section
5. Copy your API key
6. Paste it in `.Renviron` as shown above

Time needed: 5 minutes  
Cost: FREE

---

## What NOT to Do ❌

### ❌ NEVER do this:
```r
# DON'T paste your key directly in R code!
api_key <- "your_actual_bls_api_key_12345"  # ❌ WRONG

# DON'T save it in a file in the project
# (except .Renviron, which is already .gitignore'd)
```

### ❌ NEVER share your key:
- Don't post it on Slack, GitHub, Stack Overflow
- Don't email it
- Don't commit it to Git

### ❌ NEVER hardcode in documentation:
- No examples showing real keys
- No screenshots with exposed keys

---

## What TO Do ✅

### ✅ DO this:
```r
# ✅ Set it in .Renviron (not committed to Git)
# ✅ Load it with Sys.getenv()
api_key <- Sys.getenv("BLS_API_KEY")

# ✅ Check if it's set
if (api_key == "") {
  stop("BLS_API_KEY not found. Set it in .Renviron first!")
}
```

### ✅ DO keep it secure:
- Store in `.Renviron` (personal file, not committed)
- Never write it in code
- Treat it like a password

### ✅ DO this if you accidentally expose it:
1. Go to https://www.bls.gov/developers/home.htm
2. Delete the exposed key
3. Create a new key
4. Update your `.Renviron`

---

## Multiple Keys (If Needed)

If you need multiple API keys (AWS, Azure, GCP, etc.):

```r
# In .Renviron:
BLS_API_KEY="your_bls_key"
AWS_ACCESS_KEY_ID="your_aws_key"
AWS_SECRET_ACCESS_KEY="your_aws_secret"
AZURE_KEY="your_azure_key"
GCP_PROJECT_ID="your_gcp_project"

# In R code:
bls_key <- Sys.getenv("BLS_API_KEY")
aws_key <- Sys.getenv("AWS_ACCESS_KEY_ID")
azure_key <- Sys.getenv("AZURE_KEY")
# etc.
```

---

## Verify Setup Works

```r
# Test script
test_bls_api <- function() {
  key <- Sys.getenv("BLS_API_KEY")
  
  if (key == "") {
    cat("❌ BLS_API_KEY not set. Set it in .Renviron first.\n")
    return(FALSE)
  }
  
  cat("✅ BLS_API_KEY found!\n")
  cat("   Key length:", nchar(key), "characters\n")
  return(TRUE)
}

test_bls_api()
```

---

## Troubleshooting

### "BLS_API_KEY not found in environment"

**Problem:** You didn't set `.Renviron` yet.

**Solution:**
```r
usethis::edit_r_environ()
# Add: BLS_API_KEY="your_key"
# Save and restart R
```

### Key is set but still getting error

**Problem:** R hasn't reloaded the environment.

**Solution:**
```r
# Restart R completely:
# In RStudio: Session → Restart R
# In terminal R: quit() and restart
```

### Key works locally but not in GitHub Actions

**Problem:** You need to set GitHub Secrets (if using CI/CD).

**Solution:** See GitHub Actions setup (if using automated testing)

---

## For Developers: How Code Uses Keys

All code files follow this pattern:

```r
# 1. Load from environment
api_key <- Sys.getenv("BLS_API_KEY")

# 2. Check if present
if (api_key == "") {
  stop("BLS_API_KEY not found in environment. Please set it in .Renviron")
}

# 3. Use in API call
# (Key is safely passed to API, never logged or displayed)
```

This is the SECURE way. Never vary from this pattern.

---

## Summary

| Task | How |
|------|-----|
| Get BLS API key | Go to bls.gov/developers, register, copy key |
| Set in `.Renviron` | `usethis::edit_r_environ()`, add `BLS_API_KEY="..."`  |
| Verify it works | Run `Sys.getenv("BLS_API_KEY")` in R console |
| Use in code | `key <- Sys.getenv("BLS_API_KEY")` |
| Keep it secure | Never hardcode, never commit, treat like password |

---

## Questions?

See full audit: `08_documentation/API_CREDENTIALS_SECURITY_AUDIT.md`


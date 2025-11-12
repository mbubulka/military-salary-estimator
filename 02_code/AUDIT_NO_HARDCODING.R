#!/usr/bin/env Rscript
# ============================================================================
# HARDCODING & SYNTHETIC DATA AUDIT SCRIPT
# ============================================================================
# Purpose: Systematically check all visualization scripts for:
#   1. Hardcoded numeric values (especially R², metrics, coefficients)
#   2. Synthetic/fake data (c(...), data.frame(...), tribble(...))
#   3. Manual data frames instead of loading from CSV
#   4. Static test data
# ============================================================================

library(tidyverse)

cat("\n", strrep("=", 80), "\n", sep="")
cat("HARDCODING & SYNTHETIC DATA AUDIT\n")
cat("Checking all visualization scripts for fake data...\n")
cat(strrep("=", 80), "\n\n", sep="")

# ============================================================================
# SETUP: Define which scripts to audit
# ============================================================================

# PRIORITY 1: EDA Phase (Visual analysis scripts)
eda_scripts <- c(
  "03j_eda_with_colors_ENHANCED.R",
  "03k_statistical_analysis_COMPREHENSIVE.R"
)

# PRIORITY 2: Phase 4 (Baseline model visualizations)
phase4_scripts <- c(
  "04_phase4_enrichment_bls_onet.R",
  "04_phase4_FIXED.R",
  "04_phase4b_REAL_baseline.R"
)

# PRIORITY 3: Phase 5 (Model comparison visualizations)
phase5_scripts <- c(
  "05_phase5_cv_realistic.R",
  "06_phase5b_visualizations.R"
)

# ============================================================================
# FUNCTION: Scan file for red flags
# ============================================================================

scan_file_for_issues <- function(filepath, filename) {
  
  cat("\n", strrep("-", 80), "\n", sep="")
  cat(sprintf("📄 FILE: %s\n", filename))
  cat(strrep("-", 80), "\n", sep="")
  
  # Check if file exists
  if (!file.exists(filepath)) {
    cat("❌ FILE NOT FOUND\n")
    return(data.frame(
      File = filename,
      Issue = "FILE NOT FOUND",
      Line = NA,
      Code = NA,
      Severity = "CRITICAL"
    ))
  }
  
  # Read file
  content <- readLines(filepath)
  
  issues <- list()
  
  # ========================================================================
  # CHECK 1: Hardcoded numeric vectors (RED FLAG: c(0.38, 6.57) pattern)
  # ========================================================================
  
  hardcoded_patterns <- list(
    "c\\s*\\([\\d., ]+\\)" = "Hardcoded numeric vector",
    "data\\.frame\\s*\\(" = "Manual data frame creation",
    "tribble\\s*\\(" = "Manual tribble creation",
    "data_frame\\s*\\(" = "Manual data_frame creation",
    "\\bcbind\\s*\\(" = "Manual cbind creation",
    "\\brbind\\s*\\(" = "Manual rbind creation"
  )
  
  for (pattern_name in names(hardcoded_patterns)) {
    pattern_desc <- hardcoded_patterns[[pattern_name]]
    
    # Find lines matching pattern
    matches <- grep(pattern_name, content, perl = TRUE)
    
    if (length(matches) > 0) {
      # Filter: exclude read_csv, read_excel, load_data, download.file, etc.
      for (line_num in matches) {
        line_text <- content[line_num]
        
        # SKIP: Lines that are loading real data
        skip_keywords <- c(
          "read_csv", "read_excel", "read.csv", "read.table", "readLines",
          "readRDS", "load", "source", "#", "comment", "path", "file",
          "url", "download", "API", "http", "library", "require",
          "getwd", "setwd", "list.files", "dir.create"
        )
        
        is_data_load <- any(sapply(skip_keywords, function(kw) grepl(kw, line_text, ignore.case = TRUE)))
        
        if (!is_data_load) {
          cat(sprintf("  ⚠️  LINE %d: %s\n", line_num, pattern_desc))
          cat(sprintf("      CODE: %s\n", trimws(line_text)))
          
          issues[[length(issues) + 1]] <- data.frame(
            File = filename,
            Issue = pattern_desc,
            Line = line_num,
            Code = trimws(line_text),
            Severity = "MEDIUM"
          )
        }
      }
    }
  }
  
  # ========================================================================
  # CHECK 2: Hardcoded metric values (R², RMSE, MAE, coefficients)
  # ========================================================================
  
  # Pattern: label = "0.XXXX (X.XX%)" or similar
  hardcoded_metrics <- grep(
    'label\\s*=\\s*["\']\\d\\.\\d{3,}|label\\s*=\\s*["\']\\$[\\d,]+',
    content,
    perl = TRUE
  )
  
  if (length(hardcoded_metrics) > 0) {
    for (line_num in hardcoded_metrics) {
      line_text <- content[line_num]
      
      # SKIP: lines that reference dataframe columns or sprintf
      if (!grepl("as.character|sprintf|\\$|\\[|\\]", line_text)) {
        cat(sprintf("  🔴 LINE %d: Hardcoded metric value (CRITICAL)\n", line_num))
        cat(sprintf("      CODE: %s\n", trimws(line_text)))
        
        issues[[length(issues) + 1]] <- data.frame(
          File = filename,
          Issue = "Hardcoded metric value (R², RMSE, MAE, etc.)",
          Line = line_num,
          Code = trimws(line_text),
          Severity = "CRITICAL"
        )
      }
    }
  }
  
  # ========================================================================
  # CHECK 3: Synthetic test data patterns
  # ========================================================================
  
  # Pattern: "synthetic", "fake", "test", "dummy", "example"
  synthetic_keywords <- c("synthetic", "fake", "test_data", "dummy", "example_data")
  
  for (keyword in synthetic_keywords) {
    synthetic_lines <- grep(keyword, content, ignore.case = TRUE)
    
    if (length(synthetic_lines) > 0) {
      for (line_num in synthetic_lines) {
        line_text <- content[line_num]
        
        # SKIP: comment lines
        if (!grepl("^\\s*#", line_text)) {
          cat(sprintf("  ⚠️  LINE %d: Contains '%s' keyword\n", line_num, keyword))
          cat(sprintf("      CODE: %s\n", trimws(line_text)))
          
          issues[[length(issues) + 1]] <- data.frame(
            File = filename,
            Issue = sprintf("Contains '%s' keyword (possible synthetic data)", keyword),
            Line = line_num,
            Code = trimws(line_text),
            Severity = "MEDIUM"
          )
        }
      }
    }
  }
  
  # ========================================================================
  # CHECK 4: Annotate with hardcoded text
  # ========================================================================
  
  annotate_lines <- grep('annotate\\("text"', content)
  
  if (length(annotate_lines) > 0) {
    cat(sprintf("\n  📌 Found %d annotate() calls (check for hardcoded values):\n", length(annotate_lines)))
    
    for (line_num in annotate_lines[1:min(5, length(annotate_lines))]) {  # Show first 5
      line_text <- content[line_num]
      
      # Check if label uses dataframe reference or sprintf
      has_dynamic <- grepl("\\$|sprintf|as.character|\\[", line_text)
      
      if (!has_dynamic) {
        cat(sprintf("    🔴 LINE %d: Static label (CRITICAL)\n", line_num))
        cat(sprintf("        CODE: %s\n", trimws(substring(line_text, 1, 100))))
        
        issues[[length(issues) + 1]] <- data.frame(
          File = filename,
          Issue = "Annotate with hardcoded text (not dynamic)",
          Line = line_num,
          Code = trimws(line_text),
          Severity = "CRITICAL"
        )
      } else {
        cat(sprintf("    ✅ LINE %d: Dynamic label (OK)\n", line_num))
      }
    }
    
    if (length(annotate_lines) > 5) {
      cat(sprintf("    ... and %d more annotate() calls\n", length(annotate_lines) - 5))
    }
  }
  
  # ========================================================================
  # CHECK 5: Look for data loading statements
  # ========================================================================
  
  data_load_patterns <- c("read_csv", "read_excel", "readRDS")
  data_loads <- integer()
  
  for (pattern in data_load_patterns) {
    data_loads <- c(data_loads, grep(pattern, content))
  }
  
  cat(sprintf("\n  📊 Data loading statements found: %d\n", length(data_loads)))
  if (length(data_loads) > 0) {
    for (line_num in data_loads[1:min(3, length(data_loads))]) {
      line_text <- content[line_num]
      cat(sprintf("    ✅ LINE %d: %s\n", line_num, trimws(line_text)))
    }
  } else {
    cat("    ⚠️  WARNING: No data loading statements found!\n")
  }
  
  # Convert issues to dataframe
  if (length(issues) > 0) {
    do.call(rbind, issues)
  } else {
    data.frame()
  }
}

# ============================================================================
# RUN AUDITS BY PHASE
# ============================================================================

all_issues <- data.frame()

cat("\n\n", strrep("=", 80), "\n", sep="")
cat("PHASE 3: EDA ANALYSIS SCRIPTS\n")
cat(strrep("=", 80), "\n", sep="")

for (script in eda_scripts) {
  filepath <- file.path("D:/R projects/week 15/Presentation Folder/02_code", script)
  issues <- scan_file_for_issues(filepath, script)
  if (nrow(issues) > 0) {
    all_issues <- rbind(all_issues, issues)
  }
}

cat("\n\n", strrep("=", 80), "\n", sep="")
cat("PHASE 4: BASELINE MODEL SCRIPTS\n")
cat(strrep("=", 80), "\n", sep="")

for (script in phase4_scripts) {
  filepath <- file.path("D:/R projects/week 15/Presentation Folder/02_code", script)
  issues <- scan_file_for_issues(filepath, script)
  if (nrow(issues) > 0) {
    all_issues <- rbind(all_issues, issues)
  }
}

cat("\n\n", strrep("=", 80), "\n", sep="")
cat("PHASE 5: MODEL COMPARISON SCRIPTS\n")
cat(strrep("=", 80), "\n", sep="")

for (script in phase5_scripts) {
  filepath <- file.path("D:/R projects/week 15/Presentation Folder/02_code", script)
  issues <- scan_file_for_issues(filepath, script)
  if (nrow(issues) > 0) {
    all_issues <- rbind(all_issues, issues)
  }
}

# ============================================================================
# SUMMARY REPORT
# ============================================================================

cat("\n\n", strrep("=", 80), "\n", sep="")
cat("AUDIT SUMMARY\n")
cat(strrep("=", 80), "\n\n", sep="")

if (nrow(all_issues) == 0) {
  cat("✅ SUCCESS: No hardcoding or synthetic data detected!\n\n")
} else {
  cat(sprintf("❌ ISSUES FOUND: %d problems detected\n\n", nrow(all_issues)))
  
  # Group by severity
  critical <- all_issues %>% filter(Severity == "CRITICAL")
  medium <- all_issues %>% filter(Severity == "MEDIUM")
  
  if (nrow(critical) > 0) {
    cat(sprintf("🔴 CRITICAL (%d):\n", nrow(critical)))
    for (i in 1:nrow(critical)) {
      cat(sprintf("  • %s (Line %d in %s)\n", critical$Issue[i], critical$Line[i], critical$File[i]))
    }
    cat("\n")
  }
  
  if (nrow(medium) > 0) {
    cat(sprintf("⚠️  MEDIUM (%d):\n", nrow(medium)))
    for (i in 1:nrow(medium)) {
      cat(sprintf("  • %s (Line %d in %s)\n", medium$Issue[i], medium$Line[i], medium$File[i]))
    }
    cat("\n")
  }
}

# Save report
report_path <- "D:/R projects/week 15/Presentation Folder/AUDIT_HARDCODING_REPORT.csv"
write_csv(all_issues, report_path)
cat(sprintf("📄 Full report saved to: %s\n\n", report_path))

cat(strrep("=", 80), "\n\n", sep="")


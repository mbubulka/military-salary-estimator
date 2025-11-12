# ============================================================================
# TUFTE VISUALIZATION QUALITY CHECKER
# ============================================================================
# Purpose: Implement automated checks for visualization quality based on
#          Edward Tufte principles
# Date: November 10, 2025
# ============================================================================

# Load required libraries
library(ggplot2)
library(dplyr)
library(gridExtra)
library(grid)
library(ggplotify)
library(scales)

# ============================================================================
# VISUALIZATION QUALITY CHECKS
# ============================================================================

#' Check a ggplot object for compliance with Tufte principles
#' 
#' @param plot A ggplot object to check
#' @param plot_name A name for the plot (for reporting)
#' @return A list with check results
check_visualization <- function(plot, plot_name) {
  # Initialize results
  results <- list(
    plot_name = plot_name,
    issues = list(),
    warnings = list(),
    suggestions = list(),
    score = 100  # Start with perfect score
  )
  
  # Extract plot components
  plot_build <- ggplot_build(plot)
  plot_data <- plot_build$data
  plot_layout <- plot_build$layout
  plot_theme <- plot$theme
  plot_layers <- plot$layers
  plot_scales <- plot$scales$scales
  plot_labels <- plot$labels
  
  # Check 1: Data-ink ratio (geom properties)
  check_data_ink_ratio(plot, results)
  
  # Check 2: Chartjunk (unnecessary elements)
  check_chartjunk(plot, results)
  
  # Check 3: Color usage
  check_color_usage(plot, results)
  
  # Check 4: Text and typography
  check_typography(plot, results)
  
  # Check 5: Axes and scales
  check_axes_scales(plot, results)
  
  # Check 6: Legends
  check_legends(plot, results)
  
  # Calculate final score (subtract penalties)
  results$score <- max(0, results$score)
  
  # Add overall assessment
  if (results$score >= 90) {
    results$assessment <- "Excellent - Follows Tufte principles well"
  } else if (results$score >= 75) {
    results$assessment <- "Good - Generally follows Tufte principles with minor issues"
  } else if (results$score >= 50) {
    results$assessment <- "Fair - Some Tufte principles applied but needs improvement"
  } else {
    results$assessment <- "Poor - Significant violations of Tufte principles"
  }
  
  return(results)
}

#' Check data-ink ratio
#' 
#' @param plot A ggplot object
#' @param results Results list to update
check_data_ink_ratio <- function(plot, results) {
  # Check for borders on bars, points, etc.
  for (layer in plot$layers) {
    # Check geom type
    geom_type <- class(layer$geom)[1]
    
    # Check for borders on bars
    if (geom_type %in% c("GeomBar", "GeomCol")) {
      if (!is.null(layer$aes_params$colour) || 
          !is.null(layer$aes_params$color) ||
          !is.null(layer$mapping$colour) ||
          !is.null(layer$mapping$color)) {
        results$issues <- c(results$issues, "Bars have borders, reducing data-ink ratio")
        results$score <- results$score - 10
      }
      
      # Check for border size
      if (!is.null(layer$aes_params$size) && layer$aes_params$size > 0.5) {
        results$issues <- c(results$issues, "Thick borders on bars (size > 0.5)")
        results$score <- results$score - 5
      }
    }
    
    # Check for large point sizes
    if (geom_type == "GeomPoint") {
      if (!is.null(layer$aes_params$size) && layer$aes_params$size > 3) {
        results$issues <- c(results$issues, "Large point sizes (> 3) reduce data-ink ratio")
        results$score <- results$score - 5
      }
    }
    
    # Check for thick lines
    if (geom_type %in% c("GeomLine", "GeomPath", "GeomSegment")) {
      if (!is.null(layer$aes_params$size) && layer$aes_params$size > 1) {
        results$issues <- c(results$issues, "Thick lines (size > 1) reduce data-ink ratio")
        results$score <- results$score - 5
      }
    }
  }
  
  # Check for grid lines
  if (is.null(plot$theme$panel.grid.minor) || 
      !identical(plot$theme$panel.grid.minor$colour, "transparent") ||
      !identical(plot$theme$panel.grid.minor$color, "transparent")) {
    results$warnings <- c(results$warnings, "Minor grid lines present (consider removing)")
    results$score <- results$score - 3
  }
  
  if (is.null(plot$theme$panel.grid.major.x) || 
      !identical(plot$theme$panel.grid.major.x$colour, "transparent") ||
      !identical(plot$theme$panel.grid.major.x$color, "transparent")) {
    results$warnings <- c(results$warnings, "Horizontal grid lines present (consider removing)")
    results$score <- results$score - 2
  }
}

#' Check for chartjunk
#' 
#' @param plot A ggplot object
#' @param results Results list to update
check_chartjunk <- function(plot, results) {
  # Check for background fill
  if (!is.null(plot$theme$panel.background$fill) && 
      plot$theme$panel.background$fill != "transparent" &&
      plot$theme$panel.background$fill != "white") {
    results$issues <- c(results$issues, "Panel has background fill (chartjunk)")
    results$score <- results$score - 10
  }
  
  # Check for border around plot
  if (!is.null(plot$theme$panel.border$colour) && 
      plot$theme$panel.border$colour != "transparent" &&
      plot$theme$panel.border$colour != "white") {
    results$issues <- c(results$issues, "Panel has border (unnecessary element)")
    results$score <- results$score - 5
  }
  
  # Check for 3D effects or shadows (difficult to detect directly)
  # Instead, check for specific geoms that might indicate 3D
  for (layer in plot$layers) {
    geom_type <- class(layer$geom)[1]
    if (geom_type %in% c("GeomRibbon", "GeomArea")) {
      results$warnings <- c(results$warnings, "Area/ribbon geoms may create unnecessary visual complexity")
      results$score <- results$score - 3
    }
  }
  
  # Check for excessive text elements
  text_elements <- 0
  for (layer in plot$layers) {
    if (class(layer$geom)[1] == "GeomText" || class(layer$geom)[1] == "GeomLabel") {
      text_elements <- text_elements + 1
    }
  }
  
  if (text_elements > 5) {
    results$warnings <- c(results$warnings, paste("Excessive text elements (", text_elements, ")", sep = ""))
    results$score <- results$score - 5
  }
}

#' Check color usage
#' 
#' @param plot A ggplot object
#' @param results Results list to update
check_color_usage <- function(plot, results) {
  # Count distinct fill and color scales
  fill_scale <- NULL
  color_scale <- NULL
  
  for (scale in plot$scales$scales) {
    if ("fill" %in% scale$aesthetics) {
      fill_scale <- scale
    }
    if (any(c("colour", "color") %in% scale$aesthetics)) {
      color_scale <- scale
    }
  }
  
  # Check for brewer palettes (often too colorful for Tufte)
  if (!is.null(fill_scale) && inherits(fill_scale, "ScaleBrewer")) {
    results$warnings <- c(results$warnings, "Using colorful brewer palette for fill (consider grayscale)")
    results$score <- results$score - 5
  }
  
  if (!is.null(color_scale) && inherits(color_scale, "ScaleBrewer")) {
    results$warnings <- c(results$warnings, "Using colorful brewer palette for color (consider grayscale)")
    results$score <- results$score - 5
  }
  
  # Check for manual color scales with many colors
  if (!is.null(fill_scale) && inherits(fill_scale, "ScaleManual")) {
    if (length(fill_scale$palette) > 3) {
      results$warnings <- c(results$warnings, paste("Using", length(fill_scale$palette), "fill colors (Tufte recommends fewer)"))
      results$score <- results$score - 3
    }
  }
  
  if (!is.null(color_scale) && inherits(color_scale, "ScaleManual")) {
    if (length(color_scale$palette) > 3) {
      results$warnings <- c(results$warnings, paste("Using", length(color_scale$palette), "line/point colors (Tufte recommends fewer)"))
      results$score <- results$score - 3
    }
  }
}

#' Check typography
#' 
#' @param plot A ggplot object
#' @param results Results list to update
check_typography <- function(plot, results) {
  # Check for excessive text formatting
  if (!is.null(plot$theme$plot.title$face) && plot$theme$plot.title$face == "bold") {
    results$warnings <- c(results$warnings, "Bold title text (consider normal weight)")
    results$score <- results$score - 2
  }
  
  if (!is.null(plot$theme$plot.title$size) && plot$theme$plot.title$size > 14) {
    results$warnings <- c(results$warnings, "Large title text (consider smaller size)")
    results$score <- results$score - 2
  }
  
  if (!is.null(plot$theme$axis.title$face) && plot$theme$axis.title$face == "bold") {
    results$warnings <- c(results$warnings, "Bold axis titles (consider normal weight)")
    results$score <- results$score - 2
  }
  
  # Check for ALL CAPS in labels
  if (!is.null(plot$labels$title) && grepl("[A-Z]{3,}", plot$labels$title)) {
    results$warnings <- c(results$warnings, "Title appears to use ALL CAPS (avoid for readability)")
    results$score <- results$score - 3
  }
  
  if (!is.null(plot$labels$subtitle) && grepl("[A-Z]{3,}", plot$labels$subtitle)) {
    results$warnings <- c(results$warnings, "Subtitle appears to use ALL CAPS (avoid for readability)")
    results$score <- results$score - 2
  }
  
  # Check for long titles
  if (!is.null(plot$labels$title) && nchar(plot$labels$title) > 50) {
    results$warnings <- c(results$warnings, "Long title (consider shortening)")
    results$score <- results$score - 2
  }
}

#' Check axes and scales
#' 
#' @param plot A ggplot object
#' @param results Results list to update
check_axes_scales <- function(plot, results) {
  # Check for truncated y-axis in bar charts
  has_bar <- FALSE
  for (layer in plot$layers) {
    if (class(layer$geom)[1] %in% c("GeomBar", "GeomCol")) {
      has_bar <- TRUE
      break
    }
  }
  
  if (has_bar) {
    # Try to detect if y-axis starts at zero
    y_scale <- NULL
    for (scale in plot$scales$scales) {
      if ("y" %in% scale$aesthetics) {
        y_scale <- scale
        break
      }
    }
    
    if (!is.null(y_scale) && !is.null(y_scale$limits) && y_scale$limits[1] > 0) {
      results$issues <- c(results$issues, "Bar chart with y-axis not starting at zero (misleading)")
      results$score <- results$score - 15
    }
  }
  
  # Check for unnecessary axis labels when obvious
  if (!is.null(plot$labels$x) && plot$labels$x %in% c("x", "X", "category", "Category", "group", "Group")) {
    results$suggestions <- c(results$suggestions, "Generic x-axis label (consider removing)")
    results$score <- results$score - 1
  }
  
  if (!is.null(plot$labels$y) && plot$labels$y %in% c("y", "Y", "value", "Value", "count", "Count")) {
    results$suggestions <- c(results$suggestions, "Generic y-axis label (consider removing)")
    results$score <- results$score - 1
  }
}

#' Check legends
#' 
#' @param plot A ggplot object
#' @param results Results list to update
check_legends <- function(plot, results) {
  # Check if legend could be replaced with direct labeling
  has_legend <- !is.null(plot$theme$legend.position) && 
                plot$theme$legend.position != "none"
  
  if (has_legend) {
    # Count number of geoms
    geom_count <- length(plot$layers)
    
    # Check if this is a simple plot where direct labeling might work
    if (geom_count <= 2) {
      results$suggestions <- c(results$suggestions, "Consider direct labeling instead of legend")
      results$score <- results$score - 2
    }
    
    # Check legend position (Tufte prefers bottom or integrated with data)
    if (!is.null(plot$theme$legend.position) && 
        plot$theme$legend.position %in% c("right", "left")) {
      results$suggestions <- c(results$suggestions, "Legend position (right/left) takes up space; consider bottom")
      results$score <- results$score - 2
    }
  }
}

# ============================================================================
# REPORTING FUNCTIONS
# ============================================================================

#' Generate a report for visualization check results
#' 
#' @param results A list of check results
#' @param file Output file (NULL for console output)
#' @return Invisibly returns the report text
generate_report <- function(results, file = NULL) {
  # Create report header
  report <- c(
    "════════════════════════════════════════════════════════════════",
    "TUFTE VISUALIZATION QUALITY REPORT",
    "════════════════════════════════════════════════════════════════",
    "",
    paste("Plot:", results$plot_name),
    paste("Score:", results$score, "/ 100"),
    paste("Assessment:", results$assessment),
    ""
  )
  
  # Add issues
  if (length(results$issues) > 0) {
    report <- c(report, "ISSUES (High Priority):", "")
    for (i in seq_along(results$issues)) {
      report <- c(report, paste("  •", results$issues[[i]]))
    }
    report <- c(report, "")
  }
  
  # Add warnings
  if (length(results$warnings) > 0) {
    report <- c(report, "WARNINGS (Medium Priority):", "")
    for (i in seq_along(results$warnings)) {
      report <- c(report, paste("  •", results$warnings[[i]]))
    }
    report <- c(report, "")
  }
  
  # Add suggestions
  if (length(results$suggestions) > 0) {
    report <- c(report, "SUGGESTIONS (Low Priority):", "")
    for (i in seq_along(results$suggestions)) {
      report <- c(report, paste("  •", results$suggestions[[i]]))
    }
    report <- c(report, "")
  }
  
  # Add recommendations based on score
  report <- c(report, "RECOMMENDATIONS:", "")
  if (results$score < 50) {
    report <- c(report, "  • Consider a complete redesign following Tufte principles")
    report <- c(report, "  • Focus on maximizing data-ink ratio and removing chartjunk")
    report <- c(report, "  • Refer to the VISUALIZATION_STYLE_GUIDE.md document")
  } else if (results$score < 75) {
    report <- c(report, "  • Address the issues and warnings listed above")
    report <- c(report, "  • Simplify visual elements and remove decorative features")
    report <- c(report, "  • Consider using the theme_tufte_custom() function")
  } else if (results$score < 90) {
    report <- c(report, "  • Make minor adjustments based on warnings and suggestions")
    report <- c(report, "  • Fine-tune typography and color usage")
  } else {
    report <- c(report, "  • Visualization follows Tufte principles well")
    report <- c(report, "  • Consider suggestions for further refinement if needed")
  }
  
  report <- c(report, "", "════════════════════════════════════════════════════════════════")
  
  # Output report
  report_text <- paste(report, collapse = "\n")
  if (is.null(file)) {
    cat(report_text)
  } else {
    writeLines(report_text, file)
    cat(sprintf("Report saved to %s\n", file))
  }
  
  invisible(report_text)
}

#' Check multiple visualizations and generate a summary report
#' 
#' @param plots A list of ggplot objects
#' @param plot_names A vector of plot names
#' @param output_dir Directory to save reports
#' @return A data frame with summary results
check_multiple_plots <- function(plots, plot_names, output_dir = "visualization_reports") {
  # Create output directory if it doesn't exist
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Initialize results
  summary_results <- data.frame(
    plot_name = character(),
    score = numeric(),
    assessment = character(),
    issues = numeric(),
    warnings = numeric(),
    suggestions = numeric(),
    stringsAsFactors = FALSE
  )
  
  # Check each plot
  for (i in seq_along(plots)) {
    plot <- plots[[i]]
    name <- plot_names[i]
    
    # Skip if not a ggplot object
    if (!inherits(plot, "ggplot")) {
      cat(sprintf("Skipping %s: Not a ggplot object\n", name))
      next
    }
    
    # Check plot
    results <- check_visualization(plot, name)
    
    # Generate report
    report_file <- file.path(output_dir, paste0(gsub("[^a-zA-Z0-9]", "_", name), "_report.txt"))
    generate_report(results, report_file)
    
    # Add to summary
    summary_results <- rbind(summary_results, data.frame(
      plot_name = name,
      score = results$score,
      assessment = results$assessment,
      issues = length(results$issues),
      warnings = length(results$warnings),
      suggestions = length(results$suggestions),
      stringsAsFactors = FALSE
    ))
  }
  
  # Generate summary report
  summary_file <- file.path(output_dir, "00_summary_report.txt")
  writeLines(
    c(
      "════════════════════════════════════════════════════════════════",
      "TUFTE VISUALIZATION QUALITY SUMMARY",
      "════════════════════════════════════════════════════════════════",
      "",
      paste("Total visualizations checked:", nrow(summary_results)),
      paste("Average score:", round(mean(summary_results$score), 1)),
      paste("Visualizations with issues:", sum(summary_results$issues > 0)),
      "",
      "VISUALIZATION SCORES:",
      ""
    ),
    summary_file
  )
  
  # Add individual scores to summary
  scores_text <- character()
  for (i in 1:nrow(summary_results)) {
    scores_text <- c(scores_text, sprintf(
      "  • %s: %d/100 - %s",
      summary_results$plot_name[i],
      summary_results$score[i],
      summary_results$assessment[i]
    ))
  }
  write(scores_text, summary_file, append = TRUE)
  
  # Add recommendations
  writeLines(
    c(
      "",
      "RECOMMENDATIONS:",
      "",
      "  • Review individual reports for detailed feedback",
      paste("  • Focus on improving visualizations with scores below", 
            round(mean(summary_results$score) - 10)),
      "  • Apply theme_tufte_custom() for consistent styling",
      "  • Refer to VISUALIZATION_STYLE_GUIDE.md for best practices",
      "",
      "════════════════════════════════════════════════════════════════"
    ),
    summary_file,
    append = TRUE
  )
  
  cat(sprintf("Summary report saved to %s\n", summary_file))
  
  return(summary_results)
}

# ============================================================================
# EXAMPLE USAGE
# ============================================================================

#' Example function to demonstrate the visualization checker
#' 
#' @param output_dir Directory to save reports
example_check <- function(output_dir = "03_visualizations/TUFTE_CHECKS") {
  # Source the template with example visualizations
  source("02_code/tufte_visualization_template.R")
  
  # Create a list of plots to check
  plots <- list(
    before_bar,
    after_bar,
    before_hist,
    after_hist,
    before_scatter,
    after_scatter,
    before_box,
    after_box
  )
  
  # Create plot names
  plot_names <- c(
    "Bar Chart (Before)",
    "Bar Chart (After)",
    "Histogram (Before)",
    "Histogram (After)",
    "Scatter Plot (Before)",
    "Scatter Plot (After)",
    "Box Plot (Before)",
    "Box Plot (After)"
  )
  
  # Check plots and generate reports
  results <- check_multiple_plots(plots, plot_names, output_dir)
  
  # Return results
  return(results)
}

# Uncomment to run the example
# example_results <- example_check()

# ============================================================================
# USAGE INSTRUCTIONS
# ============================================================================

# To check a single visualization:
# 
# ```r
# # Load your ggplot visualization
# my_plot <- ggplot(data, aes(x = x, y = y)) + geom_point()
# 
# # Check the visualization
# results <- check_visualization(my_plot, "My Visualization")
# 
# # Generate a report
# generate_report(results)
# ```
# 
# To check multiple visualizations:
# 
# ```r
# # Create a list of plots
# my_plots <- list(plot1, plot2, plot3)
# plot_names <- c("Plot 1", "Plot 2", "Plot 3")
# 
# # Check all plots and generate reports
# results <- check_multiple_plots(my_plots, plot_names, "my_reports")
# ```
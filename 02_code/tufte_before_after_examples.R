# ============================================================================
# TUFTE BEFORE/AFTER COMPARISON EXAMPLES
# ============================================================================
# Purpose: Generate side-by-side comparisons of visualizations before and after
#          applying Edward Tufte principles
# Date: November 10, 2025
# Output: Comparison images in 03_visualizations/TUFTE_COMPARISONS/
# ============================================================================

# Load required libraries
library(ggplot2)
library(dplyr)
library(gridExtra)
library(cowplot)
library(patchwork)

# Source Tufte theme and helper functions
source("02_code/tufte_visualization_template.R")

# Set output directory
output_dir <- "03_visualizations/TUFTE_COMPARISONS/"

# Create output directory if not exists
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# ============================================================================
# HELPER FUNCTION: CREATE COMPARISON IMAGES
# ============================================================================

#' Create a side-by-side comparison of before and after visualizations
#' 
#' @param before_plot The original visualization
#' @param after_plot The Tufte-style visualization
#' @param title The title for the comparison
#' @param filename The output filename
#' @param width The output width in inches
#' @param height The output height in inches
create_comparison <- function(before_plot, after_plot, title, filename, 
                             width = 12, height = 6) {
  # Add labels to the plots
  before_with_label <- before_plot + 
    labs(subtitle = "BEFORE: Standard Visualization") +
    theme(plot.subtitle = element_text(hjust = 0.5, face = "bold"))
  
  after_with_label <- after_plot + 
    labs(subtitle = "AFTER: Tufte Principles Applied") +
    theme(plot.subtitle = element_text(hjust = 0.5, face = "bold"))
  
  # Create comparison using patchwork
  comparison <- before_with_label + after_with_label +
    plot_annotation(
      title = title,
      theme = theme(plot.title = element_text(size = 16, hjust = 0.5, face = "bold"))
    )
  
  # Save comparison
  ggsave(paste0(output_dir, filename), comparison, width = width, height = height, dpi = 300)
  cat(sprintf("✓ Saved comparison: %s\n", filename))
  
  return(comparison)
}

# ============================================================================
# EXAMPLE 1: BAR CHART COMPARISON
# ============================================================================
cat("Creating bar chart comparison...\n")

# Get before and after plots from template
before_bar <- bar_chart_before(experience_data)
after_bar <- bar_chart_after(experience_data)

# Create comparison
bar_comparison <- create_comparison(
  before_bar, 
  after_bar, 
  "Bar Chart: Experience Level Distribution", 
  "01_bar_chart_comparison.png"
)

# ============================================================================
# EXAMPLE 2: HISTOGRAM COMPARISON
# ============================================================================
cat("Creating histogram comparison...\n")

# Get before and after plots from template
before_hist <- histogram_before(salary_data)
after_hist <- histogram_after(salary_data)

# Create comparison
hist_comparison <- create_comparison(
  before_hist, 
  after_hist, 
  "Histogram: Salary Multiple Distribution", 
  "02_histogram_comparison.png"
)

# ============================================================================
# EXAMPLE 3: SCATTER PLOT COMPARISON
# ============================================================================
cat("Creating scatter plot comparison...\n")

# Get before and after plots from template
before_scatter <- scatter_before(scatter_data)
after_scatter <- scatter_after(scatter_data)

# Create comparison
scatter_comparison <- create_comparison(
  before_scatter, 
  after_scatter, 
  "Scatter Plot: Salary vs. Years of Service", 
  "03_scatter_plot_comparison.png"
)

# ============================================================================
# EXAMPLE 4: SMALL MULTIPLES COMPARISON
# ============================================================================
cat("Creating small multiples comparison...\n")

# Get before and after plots from template
before_multiples <- multiples_before(multiples_data)
after_multiples <- multiples_after(multiples_data)

# Create comparison (wider for small multiples)
multiples_comparison <- create_comparison(
  before_multiples, 
  after_multiples, 
  "Small Multiples: Salary Trends by Military Branch", 
  "04_small_multiples_comparison.png",
  width = 14,
  height = 7
)

# ============================================================================
# EXAMPLE 5: BOX PLOT COMPARISON
# ============================================================================
cat("Creating box plot comparison...\n")

# Get before and after plots from template
before_box <- boxplot_before(boxplot_data)
after_box <- boxplot_after(boxplot_data)

# Create comparison
box_comparison <- create_comparison(
  before_box, 
  after_box, 
  "Box Plot: Salary Distribution by Experience Level", 
  "05_box_plot_comparison.png"
)

# ============================================================================
# EXAMPLE 6: CORRELATION MATRIX COMPARISON
# ============================================================================
cat("Creating correlation matrix comparison...\n")

# Create sample correlation data
set.seed(123)
n <- 100
p <- 8
X <- matrix(rnorm(n * p), ncol = p)
colnames(X) <- c("Salary", "Experience", "Rank", "Education", 
                "Skills", "Location", "Industry", "Company_Size")
cor_matrix <- cor(X)
cor_melted <- reshape2::melt(cor_matrix)

# Before: Standard correlation matrix
before_corr <- ggplot(cor_melted, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white", size = 0.5) +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red",
                      midpoint = 0, limits = c(-1, 1)) +
  geom_text(aes(label = round(value, 2)), size = 3) +
  labs(title = "Correlation Matrix of Features",
       subtitle = "Relationship between all numeric variables",
       x = "Features", y = "Features", fill = "Correlation") +
  theme_minimal() +
  theme(plot.title = element_text(size = 14, face = "bold"),
        plot.subtitle = element_text(size = 11, color = "gray40"),
        axis.title = element_text(size = 11, face = "bold"),
        legend.position = "right",
        legend.title = element_text(face = "bold"),
        axis.text.x = element_text(angle = 45, hjust = 1))

# After: Tufte-style correlation matrix
after_corr <- ggplot(cor_melted, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = NA) +
  scale_fill_gradient2(low = "white", mid = "gray80", high = "black",
                      midpoint = 0, limits = c(-1, 1)) +
  geom_text(aes(label = ifelse(abs(value) > 0.5, round(value, 2), "")), 
            size = 2.5) +
  labs(title = "Correlation matrix of features",
       x = NULL, y = NULL) +
  theme_tufte_custom() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 7),
    axis.text.y = element_text(size = 7),
    legend.position = "none"
  )

# Create comparison (square format for correlation matrix)
corr_comparison <- create_comparison(
  before_corr, 
  after_corr, 
  "Correlation Matrix: Feature Relationships", 
  "06_correlation_matrix_comparison.png",
  width = 14,
  height = 8
)

# ============================================================================
# EXAMPLE 7: COMBINED VISUALIZATION COMPARISON
# ============================================================================
cat("Creating combined visualization comparison...\n")

# Create sample data for combined visualization
set.seed(456)
combined_data <- data.frame(
  category = rep(c("A", "B", "C"), each = 4),
  quarter = rep(c("Q1", "Q2", "Q3", "Q4"), 3),
  value = c(25, 30, 28, 32, 18, 22, 20, 24, 30, 35, 33, 38)
)

# Before: Complex combined visualization
before_combined <- ggplot(combined_data, aes(x = quarter, y = value, fill = category, group = category)) +
  geom_bar(stat = "identity", position = "dodge", color = "black", size = 0.5) +
  geom_line(aes(color = category), position = position_dodge(width = 0.9), size = 1.2) +
  geom_point(aes(color = category), position = position_dodge(width = 0.9), size = 3) +
  scale_fill_brewer(palette = "Set1") +
  scale_color_brewer(palette = "Set1") +
  labs(title = "Quarterly Performance by Category",
       subtitle = "Combined bar chart and line graph showing trends",
       x = "Quarter", y = "Value", fill = "Category", color = "Category") +
  theme_minimal() +
  theme(plot.title = element_text(size = 14, face = "bold"),
        plot.subtitle = element_text(size = 11, color = "gray40"),
        axis.title = element_text(size = 11, face = "bold"),
        legend.position = "right",
        legend.title = element_text(face = "bold"))

# After: Tufte-style small multiples
after_combined <- ggplot(combined_data, aes(x = quarter, y = value)) +
  geom_line(size = 0.5, color = "gray40") +
  geom_point(size = 1.5, color = "black") +
  facet_wrap(~ category, nrow = 1) +
  labs(title = "Quarterly performance by category",
       x = NULL, y = NULL) +
  theme_tufte_custom() +
  theme(
    strip.text = element_text(size = 9),
    panel.spacing = unit(1, "lines")
  )

# Create comparison
combined_comparison <- create_comparison(
  before_combined, 
  after_combined, 
  "Combined Visualization: Quarterly Performance", 
  "07_combined_visualization_comparison.png",
  width = 14,
  height = 7
)

# ============================================================================
# CREATE SUMMARY IMAGE
# ============================================================================
cat("Creating summary of all comparisons...\n")

# Function to create a thumbnail version of a plot
create_thumbnail <- function(plot, title) {
  plot + 
    labs(title = title, subtitle = NULL) + 
    theme(
      plot.title = element_text(size = 8),
      axis.text = element_text(size = 6),
      legend.position = "none"
    )
}

# Create thumbnails for before plots
before_bar_thumb <- create_thumbnail(before_bar, "Bar Chart (Before)")
before_hist_thumb <- create_thumbnail(before_hist, "Histogram (Before)")
before_scatter_thumb <- create_thumbnail(before_scatter, "Scatter Plot (Before)")
before_box_thumb <- create_thumbnail(before_box, "Box Plot (Before)")

# Create thumbnails for after plots
after_bar_thumb <- create_thumbnail(after_bar, "Bar Chart (After)")
after_hist_thumb <- create_thumbnail(after_hist, "Histogram (After)")
after_scatter_thumb <- create_thumbnail(after_scatter, "Scatter Plot (After)")
after_box_thumb <- create_thumbnail(after_box, "Box Plot (After)")

# Arrange thumbnails in a grid
summary_grid <- (before_bar_thumb + after_bar_thumb) / 
                (before_hist_thumb + after_hist_thumb) / 
                (before_scatter_thumb + after_scatter_thumb) / 
                (before_box_thumb + after_box_thumb) +
  plot_annotation(
    title = "Edward Tufte Visualization Principles: Before & After",
    subtitle = "Examples of visualizations improved by applying Tufte principles",
    theme = theme(
      plot.title = element_text(size = 16, hjust = 0.5, face = "bold"),
      plot.subtitle = element_text(size = 12, hjust = 0.5)
    )
  )

# Save summary grid
ggsave(paste0(output_dir, "00_tufte_principles_summary.png"), 
       summary_grid, width = 12, height = 14, dpi = 300)
cat("✓ Saved summary grid: 00_tufte_principles_summary.png\n")

# ============================================================================
# SUMMARY
# ============================================================================
cat("\n")
cat("════════════════════════════════════════════════════════════════\n")
cat("TUFTE BEFORE/AFTER COMPARISONS COMPLETE\n")
cat("════════════════════════════════════════════════════════════════\n")
cat(sprintf("✓ Created %d comparison images in %s\n", 8, output_dir))
cat("✓ Comparison types:\n")
cat("  • Bar charts\n")
cat("  • Histograms\n")
cat("  • Scatter plots\n")
cat("  • Small multiples\n")
cat("  • Box plots\n")
cat("  • Correlation matrices\n")
cat("  • Combined visualizations\n")
cat("  • Summary grid of all examples\n")
cat("════════════════════════════════════════════════════════════════\n")
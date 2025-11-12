# ============================================================================
# TUFTE VISUALIZATION TEMPLATE
# ============================================================================
# Purpose: Implement Edward Tufte visualization principles for the
#          Military-to-Civilian Salary Prediction project
# Date: November 10, 2025
# ============================================================================

# Load required libraries
library(ggplot2)
library(dplyr)
library(gridExtra)

# ============================================================================
# TUFTE THEME AND HELPER FUNCTIONS
# ============================================================================

#' Create a custom theme based on Tufte principles
#' 
#' This theme maximizes data-ink ratio by removing unnecessary elements
#' and simplifying the visual presentation.
#' 
#' @return A ggplot2 theme object
theme_tufte_custom <- function() {
  theme_minimal() +
  theme(
    # Typography
    text = element_text(family = "Arial", size = 9),
    plot.title = element_text(size = 10, hjust = 0),
    plot.subtitle = element_text(size = 9, color = "gray50"),
    axis.title = element_text(size = 9),
    axis.text = element_text(size = 8),
    
    # Legends
    legend.position = "bottom",
    legend.title = element_blank(),
    legend.key.size = unit(0.5, "lines"),
    legend.margin = margin(0, 0, 0, 0),
    
    # Grid lines and borders
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "gray90", size = 0.1),
    panel.border = element_blank(),
    
    # Facets
    strip.background = element_blank(),
    strip.text = element_text(size = 9),
    panel.spacing = unit(0.1, "lines")
  )
}

#' Create a grayscale fill scale
#' 
#' @return A ggplot2 scale object
scale_fill_tufte <- function() {
  scale_fill_grey(start = 0.8, end = 0.2)
}

#' Create a grayscale color scale
#' 
#' @return A ggplot2 scale object
scale_color_tufte <- function() {
  scale_color_grey(start = 0.8, end = 0.2)
}

#' Tufte color palette for when color is necessary
tufte_palette <- c("#4D4D4D", "#5DA5DA", "#FAA43A", "#60BD68", "#F17CB0")

# ============================================================================
# EXAMPLE 1: BAR CHART (BEFORE AND AFTER)
# ============================================================================

# Sample data
experience_data <- data.frame(
  experience_level = factor(c("Entry", "Mid", "Senior"), 
                           levels = c("Entry", "Mid", "Senior")),
  count = c(35, 42, 20),
  percentage = c(36.1, 43.3, 20.6)
)

# BEFORE: Standard bar chart with excessive elements
bar_chart_before <- function(data) {
  ggplot(data, aes(x = experience_level, y = count, fill = experience_level)) +
    geom_bar(stat = "identity", color = "black", size = 1) +
    geom_text(aes(label = paste0(count, "\n(", percentage, "%)")), 
              vjust = -0.5, size = 4, fontface = "bold") +
    scale_fill_brewer(palette = "Set1") +
    labs(title = "Experience Level Distribution",
         subtitle = "Career Stage Groups (Entry: 0-3 yrs, Mid: 4-10 yrs, Senior: 11-18 yrs)",
         x = "Experience Level", y = "Count", fill = "Level") +
    theme_minimal() +
    theme(plot.title = element_text(size = 14, face = "bold"),
          plot.subtitle = element_text(size = 11, color = "gray40"),
          axis.title = element_text(size = 11, face = "bold"),
          legend.position = "bottom")
}

# AFTER: Tufte-inspired bar chart
bar_chart_after <- function(data) {
  ggplot(data, aes(x = experience_level, y = count)) +
    geom_bar(stat = "identity", fill = "gray80", color = NA) +
    # Direct labeling instead of legend
    geom_text(aes(label = count), vjust = -0.8, size = 3) +
    labs(title = "Experience level distribution",
         x = NULL, y = NULL) +
    theme_tufte_custom()
}

# ============================================================================
# EXAMPLE 2: HISTOGRAM (BEFORE AND AFTER)
# ============================================================================

# Sample data
set.seed(123)
salary_data <- data.frame(
  salary_multiple = rnorm(100, mean = 1.5, sd = 0.3)
)

# BEFORE: Standard histogram with excessive elements
histogram_before <- function(data) {
  ggplot(data, aes(x = salary_multiple)) +
    geom_histogram(bins = 20, fill = "#95E1D3", color = "black", size = 0.8, alpha = 0.8) +
    geom_vline(aes(xintercept = mean(salary_multiple), color = "Mean"),
               linetype = "dashed", size = 1.2) +
    geom_vline(aes(xintercept = median(salary_multiple), color = "Median"),
               linetype = "dashed", size = 1.2) +
    scale_color_manual(values = c("Mean" = "#FF6B6B", "Median" = "#4ECDC4")) +
    labs(title = "Civilian Salary Multiple Distribution",
         subtitle = "Ratio of civilian to military salary (higher is better)",
         x = "Civilian Salary Multiple", y = "Count", color = "Statistics") +
    theme_minimal() +
    theme(plot.title = element_text(size = 14, face = "bold"),
          plot.subtitle = element_text(size = 11, color = "gray40"),
          axis.title = element_text(size = 11, face = "bold"),
          legend.position = "bottom",
          legend.title = element_text(face = "bold"))
}

# AFTER: Tufte-inspired histogram
histogram_after <- function(data) {
  mean_val <- mean(data$salary_multiple)
  median_val <- median(data$salary_multiple)
  
  ggplot(data, aes(x = salary_multiple)) +
    geom_histogram(bins = 20, fill = "gray80", color = NA) +
    # Subtle reference lines
    geom_vline(xintercept = mean_val, color = "gray30", size = 0.3) +
    # Direct annotation
    annotate("text", x = mean_val + 0.05, y = 5, 
             label = paste("Mean:", round(mean_val, 2)), 
             hjust = 0, size = 2.5) +
    labs(title = "Civilian-to-military salary multiple",
         x = NULL, y = NULL) +
    theme_tufte_custom()
}

# ============================================================================
# EXAMPLE 3: SCATTER PLOT (BEFORE AND AFTER)
# ============================================================================

# Sample data
set.seed(456)
scatter_data <- data.frame(
  years_of_service = sample(1:20, 50, replace = TRUE),
  salary = 30000 + 2000 * sample(1:20, 50, replace = TRUE) + rnorm(50, 0, 5000)
)

# BEFORE: Standard scatter plot with excessive elements
scatter_before <- function(data) {
  ggplot(data, aes(x = years_of_service, y = salary)) +
    geom_point(aes(color = "Data Points"), size = 3, alpha = 0.7) +
    geom_smooth(method = "lm", aes(color = "Trend Line"), size = 1.5, se = TRUE) +
    scale_color_manual(values = c("Data Points" = "#FF6B6B", "Trend Line" = "#4ECDC4")) +
    labs(title = "Salary vs. Years of Service",
         subtitle = "Relationship between military experience and compensation",
         x = "Years of Service", y = "Annual Salary ($)", color = "Elements") +
    theme_minimal() +
    theme(plot.title = element_text(size = 14, face = "bold"),
          plot.subtitle = element_text(size = 11, color = "gray40"),
          axis.title = element_text(size = 11, face = "bold"),
          legend.position = "bottom",
          legend.title = element_text(face = "bold"))
}

# AFTER: Tufte-inspired scatter plot
scatter_after <- function(data) {
  model <- lm(salary ~ years_of_service, data = data)
  r2 <- round(summary(model)$r.squared, 2)
  
  ggplot(data, aes(x = years_of_service, y = salary)) +
    geom_point(size = 1, alpha = 0.7, color = "gray40") +
    geom_smooth(method = "lm", color = "black", size = 0.5, se = FALSE) +
    # Add R² directly on the plot
    annotate("text", x = max(data$years_of_service) * 0.8, 
             y = min(data$salary) * 1.1, 
             label = paste("R² =", r2), size = 3) +
    labs(title = "Salary by years of service",
         x = NULL, y = NULL) +
    scale_y_continuous(labels = scales::dollar_format()) +
    theme_tufte_custom()
}

# ============================================================================
# EXAMPLE 4: SMALL MULTIPLES (BEFORE AND AFTER)
# ============================================================================

# Sample data
set.seed(789)
categories <- rep(c("Army", "Navy", "Air Force"), each = 30)
years <- rep(1:10, 9)
values <- 50000 + 5000 * (as.numeric(factor(categories)) - 1) + 2000 * years + rnorm(90, 0, 3000)
multiples_data <- data.frame(
  branch = categories,
  year = years,
  salary = values
)

# BEFORE: Single plot with multiple lines
multiples_before <- function(data) {
  ggplot(data, aes(x = year, y = salary, color = branch, group = branch)) +
    geom_line(size = 1.5) +
    geom_point(size = 3) +
    scale_color_brewer(palette = "Set1") +
    labs(title = "Salary Trends by Military Branch",
         subtitle = "10-year progression across different service branches",
         x = "Years of Service", y = "Annual Salary ($)", color = "Branch") +
    theme_minimal() +
    theme(plot.title = element_text(size = 14, face = "bold"),
          plot.subtitle = element_text(size = 11, color = "gray40"),
          axis.title = element_text(size = 11, face = "bold"),
          legend.position = "bottom",
          legend.title = element_text(face = "bold"))
}

# AFTER: Tufte-inspired small multiples
multiples_after <- function(data) {
  ggplot(data, aes(x = year, y = salary)) +
    geom_line(size = 0.5, color = "gray40") +
    facet_wrap(~ branch, nrow = 1) +
    labs(title = "Salary trends by military branch",
         x = NULL, y = NULL) +
    scale_y_continuous(labels = scales::dollar_format()) +
    theme_tufte_custom() +
    theme(
      strip.text = element_text(size = 9),
      axis.text.y = element_text(size = 7),
      panel.spacing = unit(0.5, "lines")
    )
}

# ============================================================================
# EXAMPLE 5: BOX PLOT (BEFORE AND AFTER)
# ============================================================================

# Sample data
set.seed(101)
categories <- rep(c("Entry", "Mid", "Senior"), each = 30)
values <- 50000 + 15000 * (as.numeric(factor(categories)) - 1) + rnorm(90, 0, 5000)
boxplot_data <- data.frame(
  experience = factor(categories, levels = c("Entry", "Mid", "Senior")),
  salary = values
)

# BEFORE: Standard box plot with excessive elements
boxplot_before <- function(data) {
  ggplot(data, aes(x = experience, y = salary, fill = experience)) +
    geom_boxplot(color = "black", size = 1, outlier.size = 3) +
    scale_fill_brewer(palette = "Set2") +
    labs(title = "Salary Distribution by Experience Level",
         subtitle = "Comparison of salary ranges across career stages",
         x = "Experience Level", y = "Annual Salary ($)", fill = "Experience") +
    theme_minimal() +
    theme(plot.title = element_text(size = 14, face = "bold"),
          plot.subtitle = element_text(size = 11, color = "gray40"),
          axis.title = element_text(size = 11, face = "bold"),
          legend.position = "bottom",
          legend.title = element_text(face = "bold"))
}

# AFTER: Tufte-inspired box plot
boxplot_after <- function(data) {
  ggplot(data, aes(x = experience, y = salary)) +
    geom_boxplot(fill = "gray90", color = "gray50", size = 0.2, outlier.size = 1) +
    labs(title = "Salary distribution by experience level",
         x = NULL, y = NULL) +
    scale_y_continuous(labels = scales::dollar_format()) +
    theme_tufte_custom()
}

# ============================================================================
# SAVE EXAMPLES
# ============================================================================

# Function to save before/after examples
save_examples <- function(output_dir = "03_visualizations/tufte_examples/") {
  # Create directory if it doesn't exist
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Bar chart examples
  ggsave(paste0(output_dir, "bar_chart_before.png"), 
         bar_chart_before(experience_data), 
         width = 8, height = 6, dpi = 300)
  
  ggsave(paste0(output_dir, "bar_chart_after.png"), 
         bar_chart_after(experience_data), 
         width = 8, height = 6, dpi = 300)
  
  # Histogram examples
  ggsave(paste0(output_dir, "histogram_before.png"), 
         histogram_before(salary_data), 
         width = 8, height = 6, dpi = 300)
  
  ggsave(paste0(output_dir, "histogram_after.png"), 
         histogram_after(salary_data), 
         width = 8, height = 6, dpi = 300)
  
  # Scatter plot examples
  ggsave(paste0(output_dir, "scatter_before.png"), 
         scatter_before(scatter_data), 
         width = 8, height = 6, dpi = 300)
  
  ggsave(paste0(output_dir, "scatter_after.png"), 
         scatter_after(scatter_data), 
         width = 8, height = 6, dpi = 300)
  
  # Small multiples examples
  ggsave(paste0(output_dir, "multiples_before.png"), 
         multiples_before(multiples_data), 
         width = 10, height = 6, dpi = 300)
  
  ggsave(paste0(output_dir, "multiples_after.png"), 
         multiples_after(multiples_data), 
         width = 10, height = 4, dpi = 300)
  
  # Box plot examples
  ggsave(paste0(output_dir, "boxplot_before.png"), 
         boxplot_before(boxplot_data), 
         width = 8, height = 6, dpi = 300)
  
  ggsave(paste0(output_dir, "boxplot_after.png"), 
         boxplot_after(boxplot_data), 
         width = 8, height = 6, dpi = 300)
  
  cat("Saved all before/after examples to", output_dir, "\n")
}

# Uncomment to save examples
# save_examples()

# ============================================================================
# USAGE INSTRUCTIONS
# ============================================================================

# To use the Tufte theme in your visualizations:
# 
# 1. Source this file at the beginning of your script:
#    source("02_code/tufte_visualization_template.R")
# 
# 2. Apply the theme to your ggplot:
#    ggplot(data, aes(x = x, y = y)) +
#      geom_point() +
#      theme_tufte_custom()
# 
# 3. Use the Tufte color scales:
#    ggplot(data, aes(x = x, y = y, fill = category)) +
#      geom_bar(stat = "identity") +
#      theme_tufte_custom() +
#      scale_fill_tufte()
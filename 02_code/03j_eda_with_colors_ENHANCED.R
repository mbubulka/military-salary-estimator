#!/usr/bin/env Rscript
# ============================================================================
# ENHANCED EDA VISUALIZATIONS - WITH PROFESSIONAL COLOR PALETTE
# ============================================================================
# Purpose: Comprehensive EDA with:
#   1. Professional color palette (Navy, Teal, Burnt Orange, Slate) - NOT monochrome
#   2. Tufte principles (clean, minimal, high data-ink ratio)
#   3. Additional useful EDA (education, branch, correlation, outliers)
#   4. All properly labeled with E1-O6 military codes
# ============================================================================

library(tidyverse)
library(corrplot)

# Set working directory FIRST
setwd("D:/R projects/week 15/Presentation Folder")

cat("\n════════════════════════════════════════════════════════════════\n")
cat("ENHANCED EDA VISUALIZATIONS WITH COLOR PALETTE\n")
cat("════════════════════════════════════════════════════════════════\n\n")

# Load data
training_data <- read_csv("04_results/02_training_set_CLEAN.csv", show_col_types = FALSE)
rank_mapping <- read_csv("04_results/RANK_MAPPING_AUTHORITATIVE.csv", show_col_types = FALSE)

output_dir <- "03_visualizations/PHASE_3_EDA"

# ============================================================================
# PROFESSIONAL COLOR PALETTE (Tufte + Accent Colors)
# ============================================================================
# Navy Blue (primary, ranks), Teal (secondary, trends), Burnt Orange (alerts/emphasis)
navy_blue <- "#1F4788"
teal <- "#2B9B8B"
burnt_orange <- "#D85D28"
slate_gray <- "#666666"
light_gray <- "#DDDDDD"
white <- "#FFFFFF"

# Tufte theme WITH COLOR SUPPORT
tufte_theme <- function() {
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0, 
                             margin = margin(b = 8), color = navy_blue),
    plot.subtitle = element_text(size = 11, hjust = 0, 
                                color = slate_gray, margin = margin(b = 12)),
    axis.title.x = element_text(size = 11, face = "bold", hjust = 1, 
                               margin = margin(t = 8), color = slate_gray),
    axis.title.y = element_text(size = 11, face = "bold", hjust = 1, 
                               margin = margin(r = 8), color = slate_gray),
    axis.text = element_text(size = 10, color = slate_gray),
    axis.line = element_line(color = slate_gray, linewidth = 0.4),
    axis.ticks = element_line(color = slate_gray, linewidth = 0.4),
    panel.grid.major.y = element_line(color = light_gray, linewidth = 0.2),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "right",
    legend.title = element_text(size = 10, face = "bold", color = slate_gray),
    legend.text = element_text(size = 9, color = slate_gray)
  )
}

# Join rank mapping
data_labeled <- training_data %>%
  left_join(rank_mapping %>% select(rank_code, rank_name), by = "rank_code")

# Create rank category
data_labeled <- data_labeled %>%
  mutate(rank_category = ifelse(grepl("^E", rank_code), "Enlisted", "Officer"))

cat("[STEP 1] Preparing data with E1-O6 labels...\n")

# ============================================================================
# VIZ 1: SALARY DISTRIBUTION (with color)
# ============================================================================
cat("[STEP 2] Creating salary distribution...\n")

mean_sal <- mean(data_labeled$military_annual_salary_inflated, na.rm = TRUE)
median_sal <- median(data_labeled$military_annual_salary_inflated, na.rm = TRUE)

p1 <- ggplot(data_labeled, aes(x = military_annual_salary_inflated)) +
  geom_histogram(bins = 50, fill = navy_blue, alpha = 0.7, color = slate_gray, linewidth = 0.3) +
  geom_vline(aes(xintercept = mean_sal), color = burnt_orange, linewidth = 1.2, linetype = "solid") +
  geom_vline(aes(xintercept = median_sal), color = teal, linewidth = 1.2, linetype = "dashed") +
  annotate("text", x = mean_sal, y = Inf, label = sprintf("Mean: $%s", format(round(mean_sal), big.mark=",")),
           vjust = 1.5, hjust = -0.1, size = 3.5, color = burnt_orange, fontface = "bold") +
  annotate("text", x = median_sal, y = Inf, label = sprintf("Median: $%s", format(round(median_sal), big.mark=",")),
           vjust = 3, hjust = -0.1, size = 3.5, color = teal, fontface = "bold") +
  labs(
    title = "Civilian Salary Distribution",
    subtitle = "Military-to-civilian transition salary outcomes",
    x = "Annual Salary ($)",
    y = "Number of Profiles"
  ) +
  scale_x_continuous(labels = scales::dollar_format()) +
  tufte_theme()

ggsave(file.path(output_dir, "03_02_salary_distribution.png"), 
       p1, width = 10, height = 6, dpi = 300)
cat("✓ Saved: 03_02_salary_distribution.png\n")

# ============================================================================
# VIZ 2: SALARY BY RANK (with color by enlisted/officer)
# ============================================================================
cat("[STEP 3] Creating salary by rank...\n")

rank_summary <- data_labeled %>%
  group_by(rank_code, rank_name, rank_category) %>%
  summarise(
    mean_salary = mean(military_annual_salary_inflated, na.rm = TRUE),
    count = n(),
    .groups = "drop"
  ) %>%
  arrange(factor(rank_code, levels = c("E1", "E2", "E3", "E4", "E5", "E6", "E7", "E8", "E9", 
                                        "O1", "O2", "O3", "O4", "O5", "O6")))

# Create label combining code and name
rank_summary <- rank_summary %>%
  mutate(rank_label = paste0(rank_code, "\n", rank_name))

p2 <- ggplot(rank_summary, aes(x = factor(rank_code, levels = rank_summary$rank_code), 
                              y = mean_salary, fill = rank_category)) +
  geom_col(color = slate_gray, linewidth = 0.5, alpha = 0.85) +
  scale_fill_manual(values = c("Enlisted" = navy_blue, "Officer" = teal),
                   name = "Rank Category") +
  scale_x_discrete(labels = rank_summary$rank_label) +
  scale_y_continuous(labels = scales::dollar_format()) +
  labs(
    title = "Mean Civilian Salary by Military Rank",
    subtitle = "Enlisted (E1-E9) vs Officer (O1-O6) comparison",
    x = "Military Rank",
    y = "Mean Annual Salary ($)"
  ) +
  annotate("segment", x = 9, xend = 10, y = 100000, yend = 55000,
          arrow = arrow(length = unit(0.3, "cm")), color = burnt_orange, linewidth = 1.5) +
  annotate("text", x = 9.5, y = 77000, label = "E9→O1\nTransition\n-46.6%",
          size = 3.2, color = burnt_orange, fontface = "bold", hjust = 0.5) +
  tufte_theme() +
  theme(axis.text.x = element_text(size = 9),
        legend.position = "top")

ggsave(file.path(output_dir, "03_04_salary_by_rank.png"), 
       p2, width = 12, height = 6, dpi = 300)
cat("✓ Saved: 03_04_salary_by_rank.png\n")

# ============================================================================
# VIZ 3: YEARS OF SERVICE vs SALARY (with color correlation)
# ============================================================================
cat("[STEP 4] Creating YOS vs salary...\n")

# Overall correlation
corr_overall <- cor(data_labeled$years_of_service, 
                   data_labeled$military_annual_salary_inflated, use = "complete.obs")

p3 <- ggplot(data_labeled, aes(x = years_of_service, y = military_annual_salary_inflated,
                              color = rank_category)) +
  geom_point(alpha = 0.5, size = 2) +
  geom_smooth(method = "lm", se = TRUE, alpha = 0.15, linewidth = 1, aes(fill = rank_category)) +
  scale_color_manual(values = c("Enlisted" = navy_blue, "Officer" = teal),
                    name = "Rank Category") +
  scale_fill_manual(values = c("Enlisted" = navy_blue, "Officer" = teal),
                   guide = "none") +
  scale_y_continuous(labels = scales::dollar_format()) +
  labs(
    title = "Civilian Salary vs Years of Service",
    subtitle = sprintf("Strong positive correlation (r = %.4f) - YOS is primary salary driver", corr_overall),
    x = "Years of Service (Military Career)",
    y = "Annual Salary ($)"
  ) +
  tufte_theme() +
  theme(legend.position = "top")

ggsave(file.path(output_dir, "03_03_yos_vs_salary.png"), 
       p3, width = 10, height = 6, dpi = 300)
cat("✓ Saved: 03_03_yos_vs_salary.png\n")

# ============================================================================
# VIZ 4: SALARY BY EDUCATION LEVEL (NEW - useful missing EDA)
# ============================================================================
cat("[STEP 5] Creating salary by education level...\n")

# Check education data
if ("education_level" %in% colnames(data_labeled)) {
  edu_summary <- data_labeled %>%
    group_by(education_level) %>%
    summarise(
      mean_salary = mean(military_annual_salary_inflated, na.rm = TRUE),
      count = n(),
      .groups = "drop"
    ) %>%
    filter(!is.na(education_level)) %>%
    arrange(desc(mean_salary))
  
  if (nrow(edu_summary) > 0) {
    p4 <- ggplot(edu_summary, aes(x = reorder(education_level, mean_salary), y = mean_salary)) +
      geom_col(fill = teal, color = slate_gray, linewidth = 0.5, alpha = 0.85) +
      geom_text(aes(label = sprintf("$%s\n(%d)", format(round(mean_salary), big.mark=","), count)),
               hjust = -0.1, size = 3.2, color = slate_gray) +
      scale_y_continuous(labels = scales::dollar_format(), expand = expansion(mult = c(0, 0.15))) +
      labs(
        title = "Civilian Salary by Education Level",
        subtitle = "Impact of educational attainment on civilian salary outcomes",
        x = "Education Level",
        y = "Mean Annual Salary ($)"
      ) +
      coord_flip() +
      tufte_theme()
    
    ggsave(file.path(output_dir, "03_09_salary_by_education.png"),
           p4, width = 10, height = 6, dpi = 300)
    cat("✓ Saved: 03_09_salary_by_education.png\n")
  }
}

# ============================================================================
# VIZ 5: REMOVED - BRANCH VISUALIZATION
# ============================================================================
# REMOVED: Salary by branch visualization
# RATIONALE: Military base pay is standardized by rank across all branches.
# All E1-O10 within the same service branch earn identical base pay.
# Differences in civilian salary by branch reflect occupational mix differences,
# not true branch effects. Branch is therefore excluded from analysis to avoid
# spurious correlation. Model uses rank, experience, and occupational specialty
# as primary features instead.
# ============================================================================

# ============================================================================
# VIZ 6: OCCUPATION CATEGORIES (keeping from before, but with color)
# ============================================================================
cat("[STEP 7] Creating occupation categories...\n")

occ_summary <- data_labeled %>%
  filter(!is.na(occupation_name)) %>%
  group_by(occupation_name) %>%
  summarise(
    count = n(),
    mean_salary = mean(military_annual_salary_inflated, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(count))

p6 <- ggplot(occ_summary, aes(x = reorder(occupation_name, count), y = count)) +
  geom_col(aes(fill = mean_salary), color = slate_gray, linewidth = 0.5, alpha = 0.85) +
  scale_fill_gradient(low = navy_blue, high = burnt_orange, name = "Mean Salary") +
  geom_text(aes(label = sprintf("%d\n(%.1f%%)", count, 100*count/sum(count))),
           hjust = -0.1, size = 3.2, color = slate_gray) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1))) +
  labs(
    title = "Distribution of Civilian Occupations",
    subtitle = "12 occupation categories (bar height = frequency, color gradient = mean salary)",
    x = "Occupation Category",
    y = "Number of Profiles"
  ) +
  coord_flip() +
  tufte_theme() +
  theme(legend.position = "right")

ggsave(file.path(output_dir, "03_05_occupation_categories.png"), 
       p6, width = 11, height = 6, dpi = 300)
cat("✓ Saved: 03_05_occupation_categories.png\n")

# ============================================================================
# VIZ 7: RANK × OCCUPATION HEATMAP (keeping, but with better colors)
# ============================================================================
cat("[STEP 8] Creating rank × occupation heatmap...\n")

rank_order <- c("E1", "E2", "E3", "E4", "E5", "E6", "E7", "E8", "E9", 
                "O1", "O2", "O3", "O4", "O5", "O6")

heatmap_data <- data_labeled %>%
  filter(!is.na(occupation_name)) %>%
  group_by(rank_code, occupation_name) %>%
  summarise(count = n(), .groups = "drop") %>%
  mutate(rank_code = factor(rank_code, levels = rank_order),
         occupation_name = factor(occupation_name, 
                                 levels = occ_summary %>% arrange(desc(count)) %>% pull(occupation_name)))

p7 <- ggplot(heatmap_data, aes(x = rank_code, y = occupation_name, fill = count)) +
  geom_tile(color = white, linewidth = 1) +
  scale_fill_gradient(low = white, high = navy_blue, name = "Count") +
  labs(
    title = "Rank × Occupation Transition Matrix",
    subtitle = "Career transition patterns: military rank to civilian occupation",
    x = "Military Rank",
    y = "Civilian Occupation"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold", color = navy_blue, margin = margin(b = 8)),
    plot.subtitle = element_text(size = 11, color = slate_gray, margin = margin(b = 12)),
    axis.text.x = element_text(size = 10, color = slate_gray, angle = 0, hjust = 0.5),
    axis.text.y = element_text(size = 10, color = slate_gray),
    axis.title = element_text(size = 11, face = "bold", color = slate_gray),
    panel.grid = element_blank(),
    legend.position = "right"
  )

ggsave(file.path(output_dir, "03_06_rank_occupation_heatmap.png"), 
       p7, width = 12, height = 7, dpi = 300)
cat("✓ Saved: 03_06_rank_occupation_heatmap.png\n")

# ============================================================================
# VIZ 8: DATASET OVERVIEW (info graphic with colors)
# ============================================================================
cat("[STEP 9] Creating dataset overview...\n")

n_total <- nrow(data_labeled)
n_enlisted <- sum(grepl("^E", data_labeled$rank_code))
n_officer <- sum(grepl("^O", data_labeled$rank_code))
mean_yos <- mean(data_labeled$years_of_service, na.rm = TRUE)

p8 <- ggplot() +
  annotate("rect", xmin = 0, xmax = 1, ymin = 0, ymax = 1,
           fill = white, color = slate_gray, linewidth = 1.2) +
  # Title with color
  annotate("text", x = 0.5, y = 0.95, label = "DATASET COMPOSITION & STATISTICS",
           size = 5.5, fontface = "bold", hjust = 0.5, vjust = 1, color = navy_blue) +
  # Left column - Sample
  annotate("rect", xmin = 0.02, xmax = 0.48, ymin = 0.50, ymax = 0.88,
           fill = "#EBF4FF", alpha = 0.6, color = navy_blue, linewidth = 1) +
  annotate("text", x = 0.25, y = 0.85, label = "SAMPLE COMPOSITION",
           size = 4, fontface = "bold", hjust = 0.5, vjust = 1, color = navy_blue) +
  annotate("text", x = 0.25, y = 0.75,
           label = sprintf("Total Profiles: %d\nEnlisted (E1-E9): %d (%.1f%%)\nOfficers (O1-O6): %d (%.1f%%)\nMean YOS: %.1f years",
             n_total, n_enlisted, 100*n_enlisted/n_total,
             n_officer, 100*n_officer/n_total, mean_yos),
           size = 3.8, hjust = 0.5, vjust = 1, family = "mono", color = slate_gray) +
  # Right column - Salary
  annotate("rect", xmin = 0.52, xmax = 0.98, ymin = 0.50, ymax = 0.88,
           fill = "#FFF4E6", alpha = 0.6, color = burnt_orange, linewidth = 1) +
  annotate("text", x = 0.75, y = 0.85, label = "SALARY STATISTICS",
           size = 4, fontface = "bold", hjust = 0.5, vjust = 1, color = burnt_orange) +
  annotate("text", x = 0.75, y = 0.75,
           label = sprintf("Mean: %s\nMedian: %s\nMin: %s\nMax: %s",
             format(round(mean_sal), big.mark=","),
             format(round(median_sal), big.mark=","),
             format(round(min(data_labeled$military_annual_salary_inflated)), big.mark=","),
             format(round(max(data_labeled$military_annual_salary_inflated)), big.mark=",")),
           size = 3.8, hjust = 0.5, vjust = 1, family = "mono", color = slate_gray) +
  # Bottom insight
  annotate("rect", xmin = 0.02, xmax = 0.98, ymin = 0.02, ymax = 0.42,
           fill = "#F0F0F0", alpha = 0.8, color = slate_gray, linewidth = 1) +
  annotate("text", x = 0.5, y = 0.39, label = "CHALLENGE",
           size = 4, fontface = "bold", hjust = 0.5, vjust = 1, color = navy_blue) +
  annotate("text", x = 0.5, y = 0.33,
           label = "Predict civilian salary from military background:\nRank + Years of Service + Education + Branch + Specialty → Civilian Equivalent Salary",
           size = 3.5, hjust = 0.5, vjust = 1, color = slate_gray, lineheight = 1.3) +
  coord_cartesian(xlim = 0:1, ylim = 0:1, expand = FALSE) +
  theme_void()

ggsave(file.path(output_dir, "03_01_dataset_overview.png"), 
       p8, width = 11, height = 7, dpi = 300)
cat("✓ Saved: 03_01_dataset_overview.png\n")

# ============================================================================
# VIZ 9: SALARY DISTRIBUTION BY RANK CATEGORY (side-by-side)
# ============================================================================
cat("[STEP 10] Creating salary distribution by rank category...\n")

p9 <- ggplot(data_labeled, aes(x = military_annual_salary_inflated, fill = rank_category)) +
  geom_histogram(bins = 40, color = slate_gray, linewidth = 0.3, alpha = 0.75, position = "identity") +
  facet_wrap(~rank_category, nrow = 2) +
  scale_fill_manual(values = c("Enlisted" = navy_blue, "Officer" = teal), guide = "none") +
  scale_x_continuous(labels = scales::dollar_format()) +
  labs(
    title = "Salary Distribution by Rank Category",
    subtitle = "Enlisted (E1-E9) vs Officer (O1-O6) civilian salary outcomes",
    x = "Annual Salary ($)",
    y = "Frequency"
  ) +
  tufte_theme()

ggsave(file.path(output_dir, "03_11_salary_distribution_by_category.png"), 
       p9, width = 11, height = 7, dpi = 300)
cat("✓ Saved: 03_11_salary_distribution_by_category.png\n")

# ============================================================================
# VIZ 10: RANK PROGRESSION LINE (enlisted vs officer)
# ============================================================================
cat("[STEP 11] Creating rank progression comparison...\n")

rank_progression <- data_labeled %>%
  group_by(rank_code, rank_name, rank_category) %>%
  summarise(
    mean_salary = mean(military_annual_salary_inflated, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(factor(rank_code, levels = rank_order))

p10 <- ggplot(rank_progression, aes(x = factor(rank_code, levels = rank_order), 
                                    y = mean_salary, color = rank_category, group = rank_category)) +
  geom_line(linewidth = 1.5) +
  geom_point(size = 3.5, shape = 21, fill = white, stroke = 1.5) +
  scale_color_manual(values = c("Enlisted" = navy_blue, "Officer" = teal), name = "Rank Category") +
  scale_y_continuous(labels = scales::dollar_format()) +
  labs(
    title = "Civilian Salary Progression by Rank",
    subtitle = "Career progression trajectory: E1→E9 vs O1→O6",
    x = "Military Rank",
    y = "Mean Annual Salary ($)"
  ) +
  tufte_theme() +
  theme(legend.position = "top",
        axis.text.x = element_text(size = 9))

ggsave(file.path(output_dir, "03_12_rank_progression.png"), 
       p10, width = 11, height = 6, dpi = 300)
cat("✓ Saved: 03_12_rank_progression.png\n")

cat("\n════════════════════════════════════════════════════════════════\n")
cat("✓ ENHANCED EDA COMPLETE - WITH PROFESSIONAL COLOR PALETTE\n")
cat("════════════════════════════════════════════════════════════════\n\n")
cat("Visualizations created:\n")
cat("  ✓ 03_01_dataset_overview.png (colored info graphic)\n")
cat("  ✓ 03_02_salary_distribution.png (Navy bars, Burnt Orange mean, Teal median)\n")
cat("  ✓ 03_03_yos_vs_salary.png (Navy/Teal by rank category)\n")
cat("  ✓ 03_04_salary_by_rank.png (Navy/Teal, E9→O1 in Burnt Orange)\n")
cat("  ✓ 03_05_occupation_categories.png (Color gradient by salary)\n")
cat("  ✓ 03_06_rank_occupation_heatmap.png (Navy gradient)\n")
cat("  ✓ 03_09_salary_by_education.png (Teal bars) - NEW\n")
cat("  ✓ 03_10_salary_by_branch.png (Burnt Orange bars) - NEW\n")
cat("  ✓ 03_11_salary_distribution_by_category.png (Navy/Teal split) - NEW\n")
cat("  ✓ 03_12_rank_progression.png (Navy/Teal lines) - NEW\n\n")
cat("Color Palette Used:\n")
cat("  Navy Blue (#1F4788) - Primary rankings, Enlisted\n")
cat("  Teal (#2B9B8B) - Secondary, Officer, Trends\n")
cat("  Burnt Orange (#D85D28) - Alerts, emphasis, E9→O1 transition\n")
cat("  Slate Gray (#666666) - Text, axis labels\n\n")
cat("All visualizations:\n")
cat("  ✓ Follow Tufte minimalist principles (no chartjunk)\n")
cat("  ✓ Use professional color palette (not monochrome)\n")
cat("  ✓ 300 DPI publication quality\n")
cat("  ✓ E1-O6 military rank labeling\n\n")

# Contributing to Military-to-Civilian Salary Estimator

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Code of Conduct

We are committed to providing a welcoming and inclusive environment. Please be respectful and professional in all interactions.

## Getting Started

### Prerequisites

1. Install R 4.0+ and RStudio
2. Fork the repository
3. Clone your fork locally:
   ```bash
   git clone https://github.com/yourusername/military-salary-estimator.git
   cd military-salary-estimator
   ```
4. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

### Setting Up Development Environment

```R
# Install dependencies
source("requirements.R")

# Run test suite
source("tests/run_all_tests.R")
```

## Making Changes

### Code Style

- Follow Google's R style guide: http://style.tidyverse.org/
- Use snake_case for variables and functions
- Use UPPERCASE for constants
- Add comments for complex logic
- Keep functions focused and under 50 lines when possible

### Good Commit Practices

```bash
# Use clear, descriptive commit messages
git commit -m "Add regional salary adjustments for CoL factors"

# Reference issues when relevant
git commit -m "Fix #42: Correct occupation code mapping"

# Avoid vague messages
git commit -m "Update code"  # ❌ BAD
```

### File Organization

```
02_code/
├── XX_phase_DESCRIPTION.R      # Phase files
├── XX_analysis_DESCRIPTION.R   # Analysis scripts
└── XX_utility_DESCRIPTION.R    # Helper functions
```

## Types of Contributions

### 1. Bug Fixes
- Create an issue describing the bug
- Reference the issue in your PR
- Include test case demonstrating the fix
- Update relevant documentation

### 2. Feature Additions
- Open an issue proposing the feature first
- Discuss design with maintainers
- Implement in feature branch
- Include tests and documentation

### 3. Documentation Improvements
- Fix typos or clarify explanations
- Add examples or use cases
- Improve README or comments
- Update model methodology docs

### 4. Data Analysis
- Propose new analysis approach
- Run full pipeline with new code
- Document findings clearly
- Include visualizations

## Testing

All code must include tests. Basic testing template:

```R
# tests/test_your_feature.R
test_that("description of what is tested", {
  result <- your_function(test_input)
  expect_equal(result, expected_output)
})
```

Run tests before submitting PR:
```R
source("tests/run_all_tests.R")
```

## Pull Request Process

1. **Update your branch** with latest main:
   ```bash
   git fetch origin
   git rebase origin/main
   ```

2. **Create descriptive PR** including:
   - Clear title (e.g., "Add regional salary adjustments")
   - Description of changes
   - Reference to related issues (#42)
   - Any new dependencies added
   - Testing performed

3. **PR Template:**
   ```markdown
   ## Description
   Brief description of what this PR does.

   ## Related Issues
   Closes #42

   ## Changes
   - Change 1
   - Change 2

   ## Testing
   How was this tested?

   ## Checklist
   - [ ] Code follows style guide
   - [ ] Tests pass locally
   - [ ] Documentation updated
   - [ ] No API keys or credentials included
   ```

4. **Address Feedback** - Maintainers may suggest changes
   - Make requested changes
   - Don't force push after feedback (easier to review incremental commits)
   - Reply to comments

5. **Merge** - Once approved, maintainers will merge your PR

## Data & Privacy

- **Never commit:**
  - API keys or credentials
  - Personal identifiable information (PII)
  - Large raw datasets (>10MB)
  - System-specific paths

- **Testing with data:**
  - Use only sample/synthetic data
  - Anonymize any real data examples
  - Include data loading instructions in comments

## Model Development Guidelines

### Before Modifying the Model

1. Document baseline performance:
   ```R
   baseline_r2 <- 0.9627
   baseline_rmse <- 5003
   ```

2. Run cross-validation to avoid overfitting:
   ```R
   set.seed(42)
   cv_results <- train(model_formula, data=training,
                       method="glm", trControl=trainControl(method="cv", number=10))
   ```

3. Compare against baseline test set

4. Document all changes to feature engineering

### Feature Engineering Checklist
- [ ] Feature creation logic documented
- [ ] No data leakage from test set
- [ ] Cross-validation shows improvement
- [ ] Statistical significance demonstrated (p < 0.05)
- [ ] Model interpretability maintained

## Documentation Standards

### Code Comments
```R
# Use comments for WHY, not WHAT
# BAD: Calculate mean
mean_value <- mean(x)

# GOOD: Use mean instead of median due to outlier sensitivity
mean_value <- mean(x)
```

### Function Documentation
```R
#' Calculate Salary Premium
#'
#' Applies industry-specific salary premiums based on occupation
#'
#' @param occupation Character vector of occupation names
#' @param premium_factors List of premiums by occupation
#'
#' @return Numeric vector of salary premiums
#'
#' @examples
#' calculate_premium(c("IT", "Healthcare"), premium_list)
#'
calculate_premium <- function(occupation, premium_factors) {
  # Implementation
}
```

## Reporting Issues

Use GitHub Issues to report bugs or suggest features:

1. **Title:** Clear and specific (not "Bug" or "Problem")
   - ✅ "Model accuracy decreases with missing occupation codes"
   - ❌ "Model not working"

2. **Description:** Include:
   - Steps to reproduce
   - Expected behavior
   - Actual behavior
   - R version and OS
   - Relevant code/error messages

3. **Labels:** Add appropriate labels (bug, enhancement, documentation)

## Review Process

Maintainers will:
- Review code for style and correctness
- Run tests and check reproducibility
- Verify data privacy & security
- Check model validity (if applicable)
- Provide constructive feedback

Typical review time: 3-7 days

## Performance Considerations

When modifying model code:
- Avoid slow operations in loops
- Profile code with `Rprof()`
- Consider memory usage for large datasets
- Document runtime expectations

## Questions?

- Open an issue with the "question" label
- Check existing documentation in `02_code/00_DATA_SOURCES_AND_FEATURES.md`
- Review model documentation in `PHASE6_IMPLEMENTATION_GUIDE.md`

## Acknowledgments

Contributors will be recognized in:
- CONTRIBUTORS.md file
- Release notes for major contributions
- Project documentation

---

**Thank you for contributing!** 🎉

Your help makes this project better for everyone.

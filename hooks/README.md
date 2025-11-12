# Git Hooks for R Code Quality

This directory contains Git hooks to help maintain code quality in the project.

## Available Hooks

- **pre-commit**: Runs lintr on staged R files before each commit to check for style issues

## Installation Instructions

### Windows

1. Open a PowerShell window in the project root directory
2. Run the following commands:

```powershell
# Create hooks directory if it doesn't exist
if (-not (Test-Path .git\hooks)) {
    New-Item -ItemType Directory -Path .git\hooks
}

# Copy the pre-commit hook
Copy-Item hooks\pre-commit .git\hooks\pre-commit

# Make the hook executable (if using Git Bash or WSL)
# If using pure Windows, this step may not be necessary
```

### macOS/Linux

1. Open a terminal in the project root directory
2. Run the following commands:

```bash
# Create hooks directory if it doesn't exist
mkdir -p .git/hooks

# Copy the pre-commit hook
cp hooks/pre-commit .git/hooks/pre-commit

# Make the hook executable
chmod +x .git/hooks/pre-commit
```

## Usage

Once installed, the pre-commit hook will run automatically whenever you attempt to commit changes that include R files. If any style issues are found, the commit will be aborted with an error message explaining the issues.

### Requirements

- R must be installed and available in your PATH
- The lintr package must be installed in R

To install lintr:

```r
install.packages("lintr")
```

### Bypassing the Hook

In rare cases where you need to commit code that doesn't pass the style check (e.g., during emergency fixes), you can bypass the hook using:

```bash
git commit --no-verify
```

However, this should be used sparingly, as maintaining consistent code style is important for the project.

## Troubleshooting

### Hook Not Running

If the hook doesn't seem to be running:

1. Check that it's properly installed in `.git/hooks/pre-commit`
2. Ensure it's executable (on macOS/Linux)
3. Verify that R and lintr are properly installed

### Errors in the Hook

If you encounter errors in the hook itself:

1. Check that R is in your PATH
2. Ensure the lintr package is installed
3. Try running lintr manually on your files:

```r
library(lintr)
lint("path/to/your/file.R")
```

## Additional Information

For more information about Git hooks, see:
- [Git Documentation on Hooks](https://git-scm.com/docs/githooks)
- [Customizing Git Hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)

For more information about lintr and R code style, see:
- [lintr Package Documentation](https://lintr.r-lib.org/)
- [The tidyverse style guide](https://style.tidyverse.org/)
#' @title Utility Functions for Military-to-Civilian Salary Prediction
#' @description A collection of reusable helper functions for data processing,
#'   validation, and transformation.

#' @title Normalize column names to snake_case
#' @description Converts column names to lowercase and replaces spaces and
#'   hyphens with underscores.
#' @param df A data frame whose column names need to be normalized
#' @return A data frame with normalized column names
#' @examples
#' df <- data.frame("First Name" = c("John"), "Last-Name" = c("Doe"))
#' normalize_names(df)
normalize_names <- function(df) {
  if (!is.data.frame(df)) {
    stop("Input must be a data frame")
  }
  
  df %>%
    dplyr::rename_all(tolower) %>%
    dplyr::rename_all(~stringr::str_replace_all(., " ", "_")) %>%
    dplyr::rename_all(~stringr::str_replace_all(., "-", "_"))
}

#' @title Validate absence of NA values
#' @description Checks if a data frame contains any NA values and stops
#'   execution if NAs are found.
#' @param df A data frame to check for NA values
#' @param name A character string identifying the data frame (for error messages)
#' @return Invisibly returns the input data frame if no NAs are found
#' @examples
#' df <- data.frame(x = 1:5, y = letters[1:5])
#' validate_no_nas(df, "example_data")
validate_no_nas <- function(df, name) {
  if (!is.data.frame(df)) {
    stop("Input must be a data frame")
  }
  
  if (!is.character(name) || length(name) != 1) {
    stop("Name must be a single character string")
  }
  
  na_count <- sum(is.na(df))
  if (na_count > 0) {
    stop(sprintf("ERROR: %s contains %d NA values!", name, na_count))
  }
  
  cat(sprintf("✓ %s: No NAs detected\n", name))
  invisible(df)
}

#' @title Create NA validation report
#' @description Generates a report of NA values before and after cleaning
#' @param datasets A named list of data frames before cleaning
#' @param clean_datasets A named list of data frames after cleaning
#' @return A tibble with NA validation statistics
#' @examples
#' before <- list(data1 = data.frame(x = c(1, NA, 3)))
#' after <- list(data1 = data.frame(x = c(1, 3)))
#' create_na_report(before, after)
create_na_report <- function(datasets, clean_datasets) {
  if (!is.list(datasets) || !is.list(clean_datasets)) {
    stop("Inputs must be lists of data frames")
  }
  
  if (!identical(names(datasets), names(clean_datasets))) {
    stop("Dataset lists must have identical names")
  }
  
  purrr::map2_dfr(
    datasets, 
    clean_datasets,
    function(before, after, name) {
      tibble::tibble(
        Dataset = name,
        Rows_Before = nrow(before),
        Rows_After = nrow(after),
        Rows_Removed = Rows_Before - Rows_After,
        Pct_Removed = round(100 * Rows_Removed / Rows_Before, 2),
        Status = ifelse(Rows_Removed > 0, "CLEANED", "CLEAN")
      )
    },
    .id = "Dataset"
  )
}

#' @title Apply inflation to salary data
#' @description Applies an inflation factor to salary columns
#' @param df A data frame containing salary data
#' @param salary_col The name of the salary column
#' @param inflation_factor The inflation multiplier (default: 1.21)
#' @param new_col_name The name for the inflated salary column (default: adds "_inflated")
#' @return A data frame with the inflated salary column added
#' @examples
#' df <- data.frame(salary = c(50000, 60000, 70000))
#' apply_inflation(df, "salary")
apply_inflation <- function(df, salary_col, 
                           inflation_factor = 1.21,
                           new_col_name = paste0(salary_col, "_inflated")) {
  if (!is.data.frame(df)) {
    stop("Input must be a data frame")
  }
  
  if (!salary_col %in% names(df)) {
    stop(sprintf("Column '%s' not found in data frame", salary_col))
  }
  
  if (!is.numeric(df[[salary_col]])) {
    stop(sprintf("Column '%s' must be numeric", salary_col))
  }
  
  if (!is.numeric(inflation_factor) || length(inflation_factor) != 1) {
    stop("Inflation factor must be a single numeric value")
  }
  
  df[[new_col_name]] <- df[[salary_col]] * inflation_factor
  
  cat(sprintf("✓ Applied %.2fx inflation to '%s', created '%s'\n", 
              inflation_factor, salary_col, new_col_name))
  
  return(df)
}

#' @title Create train/test split
#' @description Splits a data frame into training and test sets
#' @param df A data frame to split
#' @param train_prop Proportion for training set (default: 0.7)
#' @param seed Random seed for reproducibility (default: NULL)
#' @return A list with two elements: train and test data frames
#' @examples
#' df <- data.frame(x = 1:100, y = rnorm(100))
#' splits <- create_train_test_split(df, seed = 42)
create_train_test_split <- function(df, train_prop = 0.7, seed = NULL) {
  if (!is.data.frame(df)) {
    stop("Input must be a data frame")
  }
  
  if (!is.numeric(train_prop) || train_prop <= 0 || train_prop >= 1) {
    stop("train_prop must be a number between 0 and 1")
  }
  
  # Set seed if provided
  if (!is.null(seed)) {
    set.seed(seed)
    seed_message <- sprintf("(seed: %d)", seed)
  } else {
    seed_message <- "(no seed set)"
  }
  
  # Calculate row counts
  total_rows <- nrow(df)
  train_size <- floor(train_prop * total_rows)
  test_size <- total_rows - train_size
  
  # Create index for random sampling
  train_index <- sample(1:total_rows, train_size)
  
  # Create training and test sets
  training_set <- df[train_index, ]
  test_set <- df[-train_index, ]
  
  # Validate no overlap
  if (length(intersect(rownames(training_set), rownames(test_set))) > 0) {
    stop("Error: Overlap detected between training and test sets")
  }
  
  cat(sprintf("✓ Created training set: %d rows (%.1f%%) %s\n", 
              nrow(training_set), 100 * train_prop, seed_message))
  cat(sprintf("✓ Created test set: %d rows (%.1f%%)\n", 
              nrow(test_set), 100 * (1 - train_prop)))
  
  return(list(train = training_set, test = test_set))
}

#' @title Safe file path creation
#' @description Creates a file path using here::here and ensures directory exists
#' @param ... Components of the path, passed to here::here()
#' @param create_dir Logical, whether to create directory if it doesn't exist
#' @return A character string with the full file path
#' @examples
#' # Get path to results directory, creating it if needed
#' safe_path("04_results", create_dir = TRUE)
safe_path <- function(..., create_dir = FALSE) {
  path <- here::here(...)
  
  if (create_dir) {
    dir_path <- dirname(path)
    if (!dir.exists(dir_path)) {
      dir.create(dir_path, recursive = TRUE)
      cat(sprintf("✓ Created directory: %s\n", dir_path))
    }
  }
  
  return(path)
}
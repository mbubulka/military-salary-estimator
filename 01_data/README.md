# Data Directory

## Structure

```
01_data/
├── raw/              # Original downloaded datasets
└── processed/        # Cleaned and merged datasets
```

## Datasets to Download

### 1. Glassdoor Salaries
- **Source:** Kaggle
- **URL:** Search "Glassdoor Salaries" on Kaggle
- **Key columns:** job_title, salary, experience_level, location, company_name
- **Size:** ~1000-5000 records
- **File name:** glassdoor_salaries.csv

### 2. LinkedIn Job Postings (or similar)
- **Source:** Kaggle
- **URL:** Search "LinkedIn Jobs" on Kaggle
- **Key columns:** job_title, salary, seniority_level, location, industry
- **File name:** linkedin_jobs.csv

### 3. Tech Jobs Salary Data
- **Source:** Kaggle
- **URL:** Search "Tech Jobs Salary" on Kaggle
- **Key columns:** job_title, salary, years_of_experience, skills, location
- **File name:** tech_jobs.csv

### 4. Data Science Job Salaries (Optional)
- **Source:** Kaggle
- **URL:** salikhussain016/data-science-job-salaries
- **Key columns:** job_title, salary, experience_level, remote_ratio, location
- **File name:** ds_salaries.csv

## Data Dictionary

Once datasets are downloaded, create a data dictionary documenting:
- Column names
- Data types
- Value ranges
- Missing data patterns
- Units (USD, EUR, etc.)

## Processing Notes

- **Raw data:** Unmodified, as downloaded
- **Processed data:** Cleaned, standardized, ready for analysis
- Store both versions for reproducibility

## File Naming Convention

```
[source]_[date]_[version].csv
Example: glassdoor_salaries_2025-11-15_v1.csv
```

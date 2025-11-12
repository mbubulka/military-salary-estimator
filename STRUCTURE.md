# Repository Structure: GitHub vs Academic

## 📁 GITHUB REPOSITORY (What Gets Pushed)
These folders/files are clean, open-source, and ready for public GitHub:

```
military-salary-estimator/
├── 01_data/                          # Cleaned, anonymized training data
├── 02_code/                          # Core analysis & feature engineering code
│   └── (deploy scripts cleaned: no secrets)
├── 04_results/                       # EXCLUDED - raw results, data files
├── 10_shiny_dashboard/               # Dashboard code (deployed to shinyapps.io)
├── 11_rank_vs_skills_analysis/       # Validation & ablation studies
├── 12_certification_market_analysis/ # Certification research & ROI analysis
├── README.md                         # Quick start & overview
├── CONTRIBUTING.md                   # How to contribute
├── LICENSE                           # MIT or selected license
├── requirements.R                    # R package dependencies
├── renv.lock                         # R environment snapshot
└── .gitignore                        # Excludes sensitive data
```

## 📚 ACADEMIC REPOSITORY (Local Only - NOT on GitHub)
Archive for university coursework, presentations, papers:

```
ACADEMIC/
├── Presentations/
│   ├── Military_Salary_Estimator_DS_Peer_Review.Rmd
│   ├── Military_Salary_Estimator_DS_Peer_Review.pdf
│   └── *.pptx, *.ppt
├── Research_Papers/
│   ├── RESEARCH_PAPER_MILITARY_SALARY_TRANSITION.Rmd
│   ├── RESEARCH_PAPER_MILITARY_SALARY_TRANSITION.html
│   └── *.pdf
├── Videos/
│   └── *.mp4, *.mov, *.mkv
├── Documentation/
│   └── Lab reports, project summaries, checklists
└── Archive/
    └── Historical versions, drafts, working notes
```

## 🔐 Removed from GitHub
- ❌ ShinyApps credentials (now use `Sys.getenv()`)
- ❌ BLS API keys (only in `.Renviron`)
- ❌ Presentations & videos
- ❌ Large result/model files
- ❌ Training/test data sets
- ❌ Working notes & debug files

## ✅ Still in GitHub
- ✅ Production-ready code (no secrets)
- ✅ Data schema & README explaining data
- ✅ Shiny app deployment files
- ✅ Model validation scripts
- ✅ Tests & reproducible analysis
- ✅ Documentation for running locally
- ✅ LICENSE & CONTRIBUTING guidelines

## 🔄 Setup Instructions for New Users
Users cloning from GitHub can:
1. Install R packages: `renv::restore()`
2. Set up credentials: Add to `~/.Renviron`: `SHINYAPPS_TOKEN='...'` and `BLS_API_KEY='...'`
3. Run dashboard locally: `shiny::runApp('10_shiny_dashboard/app.R')`
4. Reproduce analysis: Source scripts in `02_code/`

---

**Last Updated:** November 12, 2025

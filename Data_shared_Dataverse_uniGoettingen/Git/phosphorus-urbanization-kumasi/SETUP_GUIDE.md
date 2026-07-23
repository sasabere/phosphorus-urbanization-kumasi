# GitHub Repository Setup Guide

## 📦 What You Have

I've created a complete GitHub repository structure for your phosphorus urbanization analysis:

```
phosphorus-urbanization-kumasi/
├── README.md                      ✓ Comprehensive documentation
├── LICENSE                        ✓ CC BY 4.0 license
├── CITATION.cff                   ✓ Machine-readable citation
├── .gitignore                     ✓ Git configuration
│
├── scripts/
│   ├── run_full_analysis.R        ✓ Master pipeline script
│   ├── modules/                   ⚠️ Need to split your original R script
│   └── utils/
│       └── load_packages.R        ✓ Package management
│
├── data/
│   ├── README.md                  ✓ Data access instructions
│   └── download_data.R            ✓ Download helper
│
├── output/                        ✓ Ready for figures/tables
│
└── docs/
    ├── packages.txt               ✓ Dependency list
    └── MODULE_GUIDE.md            ✓ Script splitting guide

```

---

## 🚀 Next Steps

### Step 1: Create Module Scripts from Your Original R File

Your original script (`R_P_analysis_2026_JBR.R`) needs to be split into 4 modules.

**See `docs/MODULE_GUIDE.md` for detailed instructions.**

**Quick breakdown:**

1. **Module 1** (`01_data_preparation.R`): Lines 1-699  
   - Data loading, merging, stock calculations

2. **Module 2** (`02_descriptive_stats.R`): Lines 700-1200  
   - Statistical tests, linear models, contrasts

3. **Module 3** (`03_visualizations.R`): Lines 1200-1645  
   - All figure generation code

4. **Module 4** (`04_SEM_analysis.R`): Lines 1647-1810  
   - Structural equation modeling

**Key changes when splitting:**
- Remove absolute file paths (use relative: `data/ksitotal_P.csv`)
- Remove `setwd()` calls
- Remove duplicate package loading
- Add progress messages (`cat()`)

---

### Step 2: Upload to GitHub

#### Option A: Command Line (Recommended)

```bash
cd /path/to/phosphorus-urbanization-kumasi

# Initialize git repository
git init

# Add all files
git add .

# First commit
git commit -m "Initial commit: P urbanization analysis code"

# Create repository on GitHub
# Go to: https://github.com/new
# Repository name: phosphorus-urbanization-kumasi
# Description: R code for soil P urbanization analysis in Kumasi, Ghana
# Public repository
# DO NOT initialize with README (you already have one)

# Link to your GitHub repository
git remote add origin https://github.com/sasabere/phosphorus-urbanization-kumasi.git

# Push to GitHub
git branch -M main
git push -u origin main
```

#### Option B: GitHub Desktop

1. Open GitHub Desktop
2. File → Add Local Repository
3. Choose the `phosphorus-urbanization-kumasi` folder
4. Publish repository to GitHub
5. Set as Public
6. Push changes

---

### Step 3: Link Dataset and Code in Your Manuscript

Add to your **Data Availability Statement**:

```
Data are available from the University of Göttingen Research Data 
Repository (https://doi.org/10.25625/DA3TOR). R code for reproducing 
all analyses and figures is available on GitHub 
(https://github.com/sasabere/phosphorus-urbanization-kumasi).
```

---

### Step 4: Update Dataverse README

Add this to your Dataverse dataset description:

```
## Associated Code

R code for reproducing all analyses and figures is available at:
https://github.com/sasabere/phosphorus-urbanization-kumasi

The repository includes:
- Complete data processing pipeline
- Statistical analysis scripts
- Figure generation code
- Structural equation modeling code
```

---

## ✅ Pre-Upload Checklist

Before pushing to GitHub, verify:

- [ ] Module scripts created from original R file
- [ ] All file paths are relative (no `C:/Users/...`)
- [ ] No absolute paths in any script
- [ ] Test: `source("scripts/run_full_analysis.R")` works
- [ ] Figures generate correctly
- [ ] Update README with your co-author names
- [ ] Update CITATION.cff with co-authors and DOIs
- [ ] Add your ORCID ID to CITATION.cff (if you have one)

---

## 📝 To-Do After Publication

Once your paper is accepted:

1. **Update CITATION.cff** with publication DOI
2. **Update README.md** with publication DOI
3. **Create a GitHub Release** (v1.0.0)
4. **Optional:** Archive on Zenodo for permanent DOI
5. **Tweet/announce** your open code!

---

## 🔗 Important Links to Update

**In your files, replace placeholders with:**

1. **Co-author names** (README.md, CITATION.cff)
2. **Publication DOI** (when available)
3. **Your ORCID ID** (optional, in CITATION.cff)
4. **Your email** (already set to stephen.asabere@uni-goettingen.de)

---

## 🆘 Troubleshooting

### "Module scripts not working"
→ See `docs/MODULE_GUIDE.md` for detailed conversion steps

### "Git errors"
→ Make sure you've created the GitHub repository first (https://github.com/new)

### "Data download not working"
→ Users must manually download from Dataverse (your download script provides instructions)

---

## 📧 Questions?

If you need help with:
- Splitting the R script into modules
- Git/GitHub setup
- Any other repository issues

Contact me or open an issue on GitHub!

---

## 🎉 You're Ready!

Your repository structure is professional and follows best practices for:
- ✓ Reproducible research
- ✓ Open science
- ✓ FAIR principles (Findable, Accessible, Interoperable, Reusable)
- ✓ Software citation

Good luck with your publication! 🚀

---

*Last updated: February 2025*

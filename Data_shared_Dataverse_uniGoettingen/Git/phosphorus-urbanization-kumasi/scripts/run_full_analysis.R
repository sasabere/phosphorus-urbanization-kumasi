################################################################################
# Master Analysis Pipeline
# 
# Runs the complete phosphorus urbanization analysis
#
# Usage: source("scripts/run_full_analysis.R")
#
# Author: Stephen Baffoe Asabere
# Project: Urbanization and soil P in tropical West Africa
# Last updated: February 2025
################################################################################

cat("\n")
cat("========================================\n")
cat("PHOSPHORUS URBANIZATION ANALYSIS\n")
cat("Kumasi, Ghana\n")
cat("========================================\n\n")

# Set working directory (adjust if needed)
# setwd("path/to/phosphorus-urbanization-kumasi")

# Check data availability
if (!file.exists("data/ksitotal_P.csv")) {
  cat("✗ ERROR: Dataset not found!\n\n")
  cat("Please download the dataset first:\n")
  cat("  source('data/download_data.R')\n\n")
  stop("Dataset missing. Download from https://doi.org/10.25625/DA3TOR")
}

cat("✓ Dataset found\n\n")

# Set seed for reproducibility
set.seed(2410)

# Create output directories if they don't exist
dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("output/tables", recursive = TRUE, showWarnings = FALSE)

# Load required packages
cat("[0/4] Loading packages...\n")
source("scripts/utils/load_packages.R")

# Run analysis modules
cat("\n[1/4] Data preparation...\n")
source("scripts/modules/01_data_preparation.R")

cat("\n[2/4] Descriptive statistics...\n")
source("scripts/modules/02_descriptive_stats.R")

cat("\n[3/4] Generating figures...\n")
source("scripts/modules/03_visualizations.R")

cat("\n[4/4] SEM analysis...\n")
source("scripts/modules/04_SEM_analysis.R")

cat("\n")
cat("========================================\n")
cat("✓ ANALYSIS COMPLETE!\n")
cat("========================================\n\n")

cat("Outputs saved to:\n")
cat("  - Figures: output/figures/\n")
cat("  - Tables: output/tables/\n\n")

cat("Citation:\n")
cat("  Asabere, S.B., et al. (2025). JGR: Biogeosciences.\n")
cat("  Data: https://doi.org/10.25625/DA3TOR\n")
cat("  Code: https://github.com/sasabere/phosphorus-urbanization-kumasi\n\n")

cat("========================================\n\n")

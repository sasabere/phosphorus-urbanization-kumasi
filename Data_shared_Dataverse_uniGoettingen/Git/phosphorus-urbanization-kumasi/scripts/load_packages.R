################################################################################
# Package Loader and Installer
# 
# Automatically installs and loads all required R packages for the analysis
#
# Author: Stephen Boahen Asabere (University of Goettingen, stephen.asabere@icloud.com)
# Last updated: July 2026

################################################################################

# Function to install and load packages
load_pkg <- function(packages) {
  cat("\n========================================\n")
  cat("PACKAGE MANAGEMENT\n")
  cat("========================================\n\n")
  
  for (pkg in packages) {
    if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
      cat(paste0("Installing ", pkg, "...\n"))
      install.packages(pkg, dependencies = TRUE)
      library(pkg, character.only = TRUE)
      cat(paste0("✓ ", pkg, " installed and loaded\n"))
    } else {
      cat(paste0("✓ ", pkg, " already installed\n"))
    }
  }
  
  cat("\n✓ All packages loaded successfully!\n\n")
}

# List of required packages
packages <- c(
  # Data manipulation
  "dplyr",           # Data wrangling
  "tidyr",           # Data tidying
  "plyr",            # Data manipulation (for join function)
  "reshape2",        # Data reshaping
  "stringr",         # String operations
  "doBy",            # Groupwise operations
  
  # Visualization
  "ggplot2",         # Main plotting package
  "cowplot",         # Plot arrangements
  "scales",          # Scale functions
  "RColorBrewer",    # Color palettes
  "viridis",         # Perceptually uniform colors
  "ggpmisc",         # ggplot2 extensions (equations, etc.)
  "ggExtra",         # Marginal plots
  "ggcorrplot",      # Correlation plots
  
  # Statistical modeling
  "lmerTest",        # Linear mixed models
  "emmeans",         # Estimated marginal means
  "multcomp",        # Multiple comparisons
  
  # Structural equation modeling
  "lavaan",          # SEM framework
  "semPlot"          # SEM visualization
)

# Install and load packages
cat("Checking and installing required packages...\n")
load_pkg(packages)

# Print session info for reproducibility
cat("\n========================================\n")
cat("R SESSION INFORMATION\n")
cat("========================================\n\n")
cat("R version:", paste(R.version$major, R.version$minor, sep = "."), "\n")
cat("Platform:", R.version$platform, "\n")
cat("\nKey package versions:\n")
for (pkg in c("ggplot2", "dplyr", "lavaan", "lmerTest")) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    cat(sprintf("  %-15s %s\n", pkg, packageVersion(pkg)))
  }
}
cat("\n")

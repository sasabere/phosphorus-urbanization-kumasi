################################################################################
# Master Analysis Pipeline
#
# Reproduces all manuscript figures from:
#
#   Asabere, S.B. & Sauer, D. (2026). Oxide-occluded to calcium-bound:
#   Urbanization increases soil phosphorus stocks and diversifies pools in
#   tropical West African agroecosystems.
#   Journal of Geophysical Research: Biogeosciences.
#
# Usage:
#   1. source("scripts/load_packages.R")   # install/load packages
#   2. source("data/download_data.R")       # fetch data from Dataverse
#   3. source("scripts/run_full_analysis.R")
#
# All outputs are written to output/figures/ (PNG + PDF).
#
# Author:       Stephen Boahen Asabere
# Last updated: July 2026
################################################################################

cat("\n========================================\n")
cat(" PHOSPHORUS URBANIZATION ANALYSIS\n")
cat(" Kumasi, Ghana\n")
cat("========================================\n\n")

# ── Preflight checks ───────────────────────────────────────────────────────────
data_path <- "data/MAIN_DATA_P_fractions_2026.csv"

if (!file.exists(data_path)) {
  cat("\u2717 Dataset not found:", data_path, "\n\n")
  cat("  Run: source(\"data/download_data.R\")\n\n")
  stop("Dataset missing. Download from https://doi.org/10.25625/DA3TOR")
}

cat("\u2713 Dataset found:", data_path, "\n")

# ── Setup ──────────────────────────────────────────────────────────────────────
set.seed(2410)

dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("output/tables",  recursive = TRUE, showWarnings = FALSE)

# ── Packages ───────────────────────────────────────────────────────────────────
cat("\n[0/4] Loading packages...\n")
source("scripts/load_packages.R")

# ── Figure 4: P fraction stocks across urbanisation classes (panels a–f) ───────
cat("\n[1/4] Figure 4 — P fraction stocks (panels a\u2013f)...\n")
source("scripts/Figure4.R")

# ── Figure 5: Mean relative proportions of P fractions ────────────────────────
cat("\n[2/4] Figure 5 — Relative P proportions...\n")
source("scripts/Figure5.R")

# ── Figure 6: Bivariate regressions PPa vs reserve pools (panels a–c) ─────────
cat("\n[3/4] Figure 6 — Bivariate regressions PPa vs reserve pools (panels a\u2013c)...\n")
source("scripts/Figure6.R")

# ── Figure 7: SEM path diagrams by duration and intensity (panels a–d) ────────
cat("\n[4/4] Figure 7 — SEM path diagrams (panels a\u2013d)...\n")
source("scripts/Figure7.R")

# ── Summary ────────────────────────────────────────────────────────────────────
cat("\n========================================\n")
cat(" \u2713 ANALYSIS COMPLETE\n")
cat("========================================\n\n")
cat("Outputs saved to: output/figures/\n\n")
cat("  Figure4.png / Figure4.pdf\n")
cat("  Figure5.png / Figure5.pdf\n")
cat("  Figure6.png / Figure6.pdf\n")
cat("  Figure7.png / Figure7.pdf\n\n")
cat("Citation:\n")
cat("  Asabere, S.B. & Sauer, D. (2026). JGR: Biogeosciences.\n")
cat("  Data: https://doi.org/10.25625/DA3TOR\n")
cat("  Code: https://github.com/sasabere/phosphorus-urbanization-kumasi\n\n")
cat("========================================\n\n")

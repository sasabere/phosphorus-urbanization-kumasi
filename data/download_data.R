################################################################################
# Download Dataset from Göttingen Research Online (Dataverse)
#
# Dataset: Soil Phosphorus Stocks and Partitioning Along an Urbanization
#          Gradient in Kumasi, Ghana
# DOI:     10.25625/DA3TOR
#
# Author:      Stephen Boahen Asabere
# Last updated: July 2026
################################################################################

# Install dataverse package if needed
if (!requireNamespace("dataverse", quietly = TRUE)) {
  install.packages("dataverse")
}
library(dataverse)

# ── Configuration ─────────────────────────────────────────────────────────────

server    <- "data.goettingen-research-online.de"
file_doi  <- "doi:10.25625/DA3TOR/IXQRO6"
out_dir   <- file.path(dirname(rstudioapi::getSourceEditorContext()$path))
out_file  <- file.path(out_dir, "MAIN_DATA_P_fractions_2026.csv")

# ── Download ──────────────────────────────────────────────────────────────────

Sys.setenv(DATAVERSE_SERVER = server)

if (file.exists(out_file)) {
  message("File already exists: ", out_file)
  message("Delete it manually if you want to re-download.")
} else {
  message("Downloading from Göttingen Dataverse...")

  raw <- get_dataframe_by_id(
    fileid  = file_doi,
    server  = server,
    .f      = read.csv,
    original = TRUE
  )

  write.csv(raw, out_file, row.names = FALSE)
  message("✓ Saved to: ", out_file)

  # Basic verification
  message(sprintf("  Rows: %d | Columns: %d", nrow(raw), ncol(raw)))
}

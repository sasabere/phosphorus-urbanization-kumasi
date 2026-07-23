################################################################################
# Download Dataset from Göttingen Dataverse
# 
# DOI: 10.25625/DA3TOR
# Dataset: Soil Phosphorus Stocks and Partitioning Along an Urbanization 
#          Gradient in Kumasi, Ghana
#
# Author: Stephen Asabere
# Last updated: July 2026
################################################################################

cat("\n========================================\n")
cat("DATASET DOWNLOAD\n")
cat("========================================\n\n")

# Dataset information
doi <- "10.25625/DA3TOR"
dataverse_url <- "https://data.goettingen-research-online.de"
file_name <- "ksitotal_P.csv"
output_path <- file.path("data", file_name)

cat("DOI:", doi, "\n")
cat("File:", file_name, "\n")
cat("Destination:", output_path, "\n\n")

# Check if file exists
if (file.exists(output_path)) {
  cat("✓ File already exists: ", output_path, "\n")
  response <- readline(prompt = "Re-download? (y/n): ")
  if (tolower(response) != "y") {
    cat("\nUsing existing file.\n")
    quit(save = "no")
  }
}

cat("\n========================================\n")
cat("MANUAL DOWNLOAD REQUIRED\n")
cat("========================================\n\n")

cat("Please download the dataset manually:\n\n")
cat("1. Visit:", paste0(dataverse_url, "/dataset.xhtml?persistentId=doi:", doi), "\n\n")
cat("2. Click 'Access Dataset' → 'Original Format ZIP'\n\n")
cat("3. Extract 'ksitotal_P.csv' from the ZIP file\n\n")
cat("4. Place it in this 'data/' directory\n\n")

cat("After downloading, verify the file:\n")
cat("  - File should be ~50 KB\n")
cat("  - Should contain 225 rows + 1 header\n")
cat("  - Should have 81 columns\n\n")

cat("========================================\n")
cat("Alternative: Programmatic Download\n")
cat("========================================\n\n")

cat("If you have the dataverse R package installed:\n\n")
cat('  install.packages("dataverse")\n')
cat('  library(dataverse)\n')
cat('  \n')
cat('  # Set Dataverse server\n')
cat('  Sys.setenv("DATAVERSE_SERVER" = "data.goettingen-research-online.de")\n')
cat('  \n')
cat('  # Download dataset\n')
cat('  dataset <- get_dataset("doi:10.25625/DA3TOR")\n')
cat('  writeBin(get_file("ksitotal_P.csv", "doi:10.25625/DA3TOR"), \n')
cat('           "data/ksitotal_P.csv")\n\n')

cat("========================================\n\n")

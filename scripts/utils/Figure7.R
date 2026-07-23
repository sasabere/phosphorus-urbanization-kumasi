################################################################################
# Figure 7: SEM Path Diagrams — Duration and Intensity of Urbanization (a–d)
#
# Structural equation model path diagrams showing relationships among soil
# properties (SOC, pH, exchangeable Ca), reserve P pools (PSOM, PCa, POCC),
# and plant-available P (PPa) across two grouping dimensions:
#
#   Row 1 — Urbanization duration (fit_class):
#     (a) Short-duration urban soils
#     (b) Long-duration urban soils
#
#   Row 2 — Urbanization intensity (fit_road_class):
#     (c) Low-intensity urban soils
#     (d) High-intensity urban soils
#
# Note: semPlot uses base-R graphics. Each 2-group model is saved to a
# temporary PNG, then the two rows are combined with cowplot.
#
# Requires:
#   - data/MAIN_DATA_P_fractions_2026.csv  (run data/download_data.R first)
#
# Author:       Stephen Boahen Asabere
# Last updated: July 2026
################################################################################

# ── 0. Packages ────────────────────────────────────────────────────────────────
source("scripts/utils/load_packages.R")
library(lavaan)
library(semPlot)
library(cowplot)

# ── 1. Load data ───────────────────────────────────────────────────────────────
data_path <- "data/MAIN_DATA_P_fractions_2026.csv"
if (!file.exists(data_path)) {
  stop("Dataset not found. Run data/download_data.R first to fetch it from Dataverse.")
}
ksitotal_P <- read.csv(data_path)

# ── 2. Factor setup ─────────────────────────────────────────────────────────────
ksitotal_P$class <- factor(ksitotal_P$class,
  levels = c("Profile", "RURAL", "FOREST", "Short-duration", "Long-duration")
)
ksitotal_P$road_class <- factor(ksitotal_P$road_class,
  levels = c("Reference", "Profile", "Low-intensity", "High-intensity")
)
ksitotal_P$urbimpact <- factor(ksitotal_P$urbimpact,
  levels = c("Profile", "RURAL", "FOREST", "Weak", "Mild", "Moderate", "Strong")
)

# ── 3. Prepare SEM data ─────────────────────────────────────────────────────────
# Urban-only (exclude FOREST, RURAL, and Profile)
urban_data <- ksitotal_P |>
  dplyr::filter(!(class %in% c("Profile", "FOREST", "RURAL"))) |>
  droplevels()

# Log-transforms (all variables except pH)
urban_data <- urban_data |>
  dplyr::mutate(
    log_p_available_gm2_lod = log1p(p_available_gm2_lod0),
    log_p_SOM_gm2           = log1p(p_SOM_gm2_lod0),
    log_p_Ca_gm2            = log1p(p_Ca_gm2_lod0),
    log_p_OCC_gm2           = log1p(p_OCC_gm2_lod0),
    logSOC_kgm2             = log1p(as.numeric(SOC_kgm2)),
    logExCa_gm2             = log1p(exch_Ca_stocks_gm2)
  )

vars <- c("log_p_available_gm2_lod", "log_p_SOM_gm2",
          "log_p_Ca_gm2", "log_p_OCC_gm2",
          "logSOC_kgm2", "pH", "logExCa_gm2",
          "class", "road_class")

SEM_P_data <- na.omit(urban_data[, vars])

# ── 4. SEM model specification ──────────────────────────────────────────────────
sem_model <- '
  # Exogenous soil properties → reserve pools
  log_p_SOM_gm2 ~ logSOC_kgm2 + pH + logExCa_gm2
  log_p_Ca_gm2  ~ logSOC_kgm2 + pH + logExCa_gm2
  log_p_OCC_gm2 ~ logSOC_kgm2 + pH + logExCa_gm2

  # Reserve pools + soil properties → plant-available P
  log_p_available_gm2_lod ~ logSOC_kgm2 + pH + logExCa_gm2 +
                             log_p_SOM_gm2 + log_p_Ca_gm2 + log_p_OCC_gm2

  # Residual covariances among reserve pools
  log_p_SOM_gm2 ~~ log_p_Ca_gm2 + log_p_OCC_gm2
  log_p_Ca_gm2  ~~ log_p_OCC_gm2
'

# ── 5. Fit models ──────────────────────────────────────────────────────────────
# Group by urbanization duration: Short-duration vs Long-duration
fit_class <- lavaan::sem(sem_model, data = SEM_P_data,
                         group = "class", estimator = "MLR", missing = "fiml")

# Group by urbanization intensity: Low-intensity vs High-intensity
fit_road_class <- lavaan::sem(sem_model, data = SEM_P_data,
                              group = "road_class", estimator = "MLR", missing = "fiml")

# ── 6. Node colour palette ─────────────────────────────────────────────────────
# Manifest variable order (lavaan default): P fractions first, then soil props
node_cols <- c("#80CDC1",  # PSOM
               "#DFC27D",  # PCa
               "#A6611A",  # POCC
               "#018571",  # PPa (plant-available)
               "white",    # logSOC_kgm2
               "white",    # pH
               "white")    # logExCa_gm2

sem_args <- list(
  edge.label.cex = 1,
  whatLabels     = "std",
  what           = "std",
  reorder        = FALSE,
  intercepts     = FALSE,
  layout         = "tree",
  nCharNodes     = 0,
  nCharEdges     = 0,
  sizeMan        = 6,
  edge.color     = "black",
  mar            = c(10, 5, 10, 5),
  fixedStyle     = 1,
  curvePivot     = TRUE,
  color          = list(
    lat = rgb(220, 220, 220, maxColorValue = 255),
    man = node_cols
  )
)

# ── 7. Save each row to a temporary PNG ────────────────────────────────────────
tmp_ab <- tempfile(fileext = ".png")  # (a) Short-duration | (b) Long-duration
tmp_cd <- tempfile(fileext = ".png")  # (c) Low-intensity  | (d) High-intensity

# Row 1: duration groups (style = "lisrel")
png(tmp_ab, width = 5000, height = 2200, res = 300)
do.call(semPaths, c(list(object = fit_class,      style = "lisrel"), sem_args))
dev.off()

# Row 2: intensity groups (style = "ram")
png(tmp_cd, width = 5000, height = 2200, res = 300)
do.call(semPaths, c(list(object = fit_road_class, style = "ram"),    sem_args))
dev.off()

# ── 8. Combine rows and add panel labels ───────────────────────────────────────
p_ab <- ggdraw() + draw_image(tmp_ab)
p_cd <- ggdraw() + draw_image(tmp_cd)

# Add (a)/(b) and (c)/(d) labels at top of each half-panel
p_ab_labeled <- ggdraw(p_ab) +
  draw_label("(a) Short-duration", x = 0.25, y = 0.98,
             hjust = 0.5, vjust = 1, size = 11, fontface = "bold") +
  draw_label("(b) Long-duration",  x = 0.75, y = 0.98,
             hjust = 0.5, vjust = 1, size = 11, fontface = "bold")

p_cd_labeled <- ggdraw(p_cd) +
  draw_label("(c) Low-intensity",  x = 0.25, y = 0.98,
             hjust = 0.5, vjust = 1, size = 11, fontface = "bold") +
  draw_label("(d) High-intensity", x = 0.75, y = 0.98,
             hjust = 0.5, vjust = 1, size = 11, fontface = "bold")

fig7 <- plot_grid(p_ab_labeled, p_cd_labeled, ncol = 1)

# ── 9. Save ────────────────────────────────────────────────────────────────────
out_dir <- "output/figures"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

ggsave(file.path(out_dir, "Figure7.png"), fig7,
       width = 50, height = 44, units = "cm", dpi = 300)

ggsave(file.path(out_dir, "Figure7.pdf"), fig7,
       width = 25, height = 22)

# Clean up temp files
file.remove(tmp_ab, tmp_cd)

message("\u2713 Figure 7 saved to ", out_dir)

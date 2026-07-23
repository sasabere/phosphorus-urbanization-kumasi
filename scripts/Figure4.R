################################################################################
# Figure 4: Soil P Fractions Across Urbanization Classes (panels a–f)
#
# Produces a 3×2 composite figure showing P stocks for:
#   a) HNO3-total P
#   b) Plant-available P (PPa)
#   c) SOM-bound P (PSOM)
#   d) Ca-bound P (PCa)
#   e) Oxide-occluded P (POCC)
#   f) Sum of extractable P fractions
#
# Requires:
#   - data/MAIN_DATA_P_fractions_2026.csv  (run data/download_data.R first)
#   - scripts/utils/function_twoway_boxplot.R
#   - scripts/utils/function_twoway_boxplot_points_Shape.R
#   - scripts/utils/function_twoway_boxplot_points_Shape_totalPfractions.R
#
# Author:       Stephen Boahen Asabere
# Last updated: July 2026
################################################################################

# ── 0. Packages ────────────────────────────────────────────────────────────────
source("scripts/load_packages.R")
library(patchwork)

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

# Filtered dataset: urban + reference classes, excluding soil profiles
d <- droplevels(subset(ksitotal_P, !(class %in% "Profile")))

# Ordinal urban intensity score for regression slope extraction
d$urbimpact <- factor(d$urbimpact, ordered = TRUE)
d$urbnumber <- as.numeric(d$urbimpact)

# LOQ flags as factor for point shaping in panel f
d$n_fractions_ge_loq        <- as.factor(d$n_fractions_ge_loq)
d$n_fractions_ge_loq_factor <- factor(
  d$n_fractions_ge_loq, levels = 1:4, labels = paste0(1:4, " \u2265LOQ")
)

# ── 3. Custom plot functions ────────────────────────────────────────────────────
source("scripts/utils/function_twoway_boxplot.R")
source("scripts/utils/function_twoway_boxplot_points_Shape.R")
source("scripts/utils/function_twoway_boxplot_points_Shape_totalPfractions.R")

# ── 4. Log-transforms ──────────────────────────────────────────────────────────
d <- d |>
  dplyr::mutate(
    log_P_total_HNO3_gm2     = log1p(P_total_HNO3_gm2),
    log_p_available_gm2_lod  = log1p(p_available_gm2_lod0),
    log_p_SOM_gm2            = log1p(p_SOM_gm2_lod0),
    log_p_Ca_gm2             = log1p(p_Ca_gm2_lod0),
    log_p_OCC_gm2            = log1p(p_OCC_gm2_lod0),
    log_p_sum_total_gm2_lod0 = log1p(p_EXT_total_gm2_lod0)
  )

# ── 5. Models and CLD significance letters ─────────────────────────────────────
set.seed(123456)

# Subset to urban classes only (no FOREST, RURAL) for model fitting
urban_only <- droplevels(subset(d, !(class %in% c("FOREST", "RURAL"))))

# Helper to extract compact letter display from emmeans
get_cld <- function(model) {
  emm <- emmeans::emmeans(model, ~ class + road_class, df = Inf)
  as.data.frame(multcomp::cld(emm, adjust = "tukey",
                               Letters = letters, alpha = 0.05, sort = TRUE))
}

mtotalP    <- lm(log_P_total_HNO3_gm2     ~ class + road_class, data = urban_only)
mPpa       <- lm(log_p_available_gm2_lod  ~ class + road_class, data = urban_only)
mPsom      <- lm(log_p_SOM_gm2            ~ class + road_class, data = urban_only)
mPca       <- lm(log_p_Ca_gm2             ~ class + road_class, data = urban_only)
mPocc      <- lm(log_p_OCC_gm2            ~ class + road_class, data = urban_only)
msumPtotal <- lm(log_p_sum_total_gm2_lod0 ~ class + road_class,
                 data = urban_only |> dplyr::filter(p_EXT_total_gm2 > 0))

emm_totalP    <- get_cld(mtotalP)
emm_Ppa       <- get_cld(mPpa)
emm_Psom      <- get_cld(mPsom)
emm_Pca       <- get_cld(mPca)
emm_Pocc      <- get_cld(mPocc)
emm_sumPtotal <- get_cld(msumPtotal)

# ── 6. Individual panels ───────────────────────────────────────────────────────

# a) HNO3-total P
p_total <- baseboxplot_rdinfluence(
             d, x_col = "class", y_col = "P_total_HNO3_gm2",
             z_class_col = "road_class") +
  geom_text(data = emm_totalP,
            aes(x = class, y = emmean, color = road_class,
                label = .group, group = road_class),
            show.legend = FALSE,
            position = position_dodge2(width = 0.9, preserve = "single"),
            vjust = -15, hjust = 2, size = 7) +
  scale_y_continuous(breaks = pretty(d$P_total_HNO3_gm2, n = 5)) +
  labs(x = "", tag = "a",
       y = bquote("HNO"[3] ~ "[" ~ g * ~~P ~ m^-2 ~ "]"),
       title = expression("HNO"[3] ~ "P  [duration = ***, intensity = ***]"),
       subtitle = "log1p(y) = 0.25 x + 2.5, *p* < 0.001, R\u00b2 = 0.24")

# b) Plant-available P
p_Ppa <- baseboxplot_rdinfluence_points_Shape(
           d |> dplyr::filter(p_available_gm2_lod0 < 40),
           x_col = "class", y_col = "p_available_gm2_lod0",
           z_class_col = "road_class", status_col = "pavail_status") +
  geom_text(data = emm_Ppa,
            aes(x = class, y = emmean, color = road_class,
                label = .group, group = road_class),
            show.legend = FALSE,
            position = position_dodge2(width = 0.9, preserve = "single"),
            vjust = -9, hjust = 1.5, size = 7) +
  labs(x = "", tag = "b",
       y = bquote("P"[Pa] ~ "[" ~ g * ~~P ~ m^-2 ~ "]"),
       title = expression("Plant-available P [duration = ***, intensity = ***]"),
       subtitle = "log1p(y) = 0.34 x \u2212 0.39, *p* < 0.001, R\u00b2 = 0.26")

# c) SOM-bound P
p_Psom <- baseboxplot_rdinfluence_points_Shape(
            d, x_col = "class", y_col = "p_SOM_gm2_lod0",
            z_class_col = "road_class", status_col = "psom_status") +
  geom_text(data = emm_Psom,
            aes(x = class, y = emmean, color = road_class,
                label = .group, group = road_class),
            show.legend = FALSE,
            position = position_dodge2(width = 0.9, preserve = "single"),
            vjust = -15, hjust = 2, size = 7) +
  scale_y_continuous(breaks = pretty(d$p_SOM_gm2_lod0, n = 5)) +
  labs(x = "", tag = "c",
       y = bquote("P"[SOM] ~ "[" ~ g * ~~P ~ m^-2 ~ "]"),
       title = expression("SOM-bound P [ duration = **, intensity = ** ]"),
       subtitle = "log1p(y) = 0.17 x \u2212 0.033, *p* < 0.001, R\u00b2 = 0.11")

# d) Ca-bound P
p_Pca <- baseboxplot_rdinfluence_points_Shape(
           d |> dplyr::filter(p_Ca_gm2_lod0 < 100),
           x_col = "class", y_col = "p_Ca_gm2_lod0",
           z_class_col = "road_class", status_col = "pca_status") +
  geom_text(data = emm_Pca,
            aes(x = class, y = emmean, color = road_class,
                label = .group, group = road_class),
            show.legend = FALSE,
            position = position_dodge2(width = 0.9, preserve = "single"),
            vjust = -11, hjust = 2, size = 7) +
  scale_y_continuous(breaks = pretty(d$p_Ca_gm2_lod0, n = 5)) +
  labs(x = "", tag = "d",
       y = bquote("P"[Ca] ~ "[" ~ g * ~~P ~ m^-2 ~ "]"),
       title = expression("Ca-bound P [ duration = ***, intensity = * ]"),
       subtitle = "log1p(y) = 0.44 x \u2212 0.60, *p* < 0.001, R\u00b2 = 0.13")

# e) Oxide-occluded P
p_Pocc <- baseboxplot_rdinfluence_points_Shape(
            d, x_col = "class", y_col = "p_OCC_gm2_lod0",
            z_class_col = "road_class", status_col = "pocc_status") +
  geom_text(data = emm_Pocc,
            aes(x = class, y = emmean, color = road_class,
                label = .group, group = road_class),
            show.legend = FALSE,
            position = position_dodge2(width = 0.9, preserve = "single"),
            vjust = -18, hjust = 2, size = 7) +
  scale_y_continuous(breaks = pretty(d$p_OCC_gm2_lod0, n = 5)) +
  labs(x = "", tag = "e",
       y = bquote("P"[OCC] ~ "[" ~ g * ~~P ~ m^-2 ~ "]"),
       title = expression("Occluded P [ duration = ***, intensity = ns ]"),
       subtitle = "log1p(y) = 0.11 x + 2.14, *p* < 0.0001, R\u00b2 = 0.07")

# f) Sum of extractable P fractions
p_sumPtotal <- d |>
  dplyr::filter(p_EXT_total_gm2 > 0, !(n_fractions_ge_loq %in% "0")) |>
  baseboxplot_rdinfluence_pointPfractions(
    x_col = "class", y_col = "p_EXT_total_gm2_lod0",
    z_class_col = "road_class", status_col = "n_fractions_ge_loq_factor") +
  geom_text(data = emm_sumPtotal,
            aes(x = class, y = emmean, color = road_class,
                label = .group, group = road_class),
            show.legend = FALSE,
            position = position_dodge2(width = 0.9, preserve = "single"),
            vjust = -12, hjust = 2, size = 7) +
  scale_y_continuous(breaks = pretty(d$p_EXT_total_gm2, n = 5)) +
  labs(x = "", tag = "f",
       y = expression(paste(sum(P[fractions], fractions = 1, 4),
                            "[" ~ ~~g * ~~m^-2 * ~"]")),
       title = expression(paste(sum(P[fractions], fractions = 1, 4),
                                " Extractable P [ duration = ***, intensity = ** ]")),
       subtitle = "log1p(y) = 0.29 x + 1.77, *p* < 0.001, R\u00b2 = 0.22")

# ── 7. Composite (3 columns × 2 rows) ──────────────────────────────────────────
fig4 <- (p_total | p_Ppa | p_Psom) /
        (p_Pca   | p_Pocc | p_sumPtotal)

# ── 8. Save ────────────────────────────────────────────────────────────────────
out_dir <- "output/figures"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

ggsave(file.path(out_dir, "Figure4.png"), fig4,
       width = 60, height = 40, units = "cm", dpi = 300)

ggsave(file.path(out_dir, "Figure4.pdf"), fig4,
       width = 30, height = 20)

message("\u2713 Figure 4 saved to ", out_dir)

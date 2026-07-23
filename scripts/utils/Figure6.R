################################################################################
# Figure 6: Bivariate Relationships Between Plant-Available P and Reserve Pools
#
# Produces a 3-panel composite (stacked vertically):
#   a) PPa vs PSOM — SOM-bound reserve pool
#   b) PPa vs PCa  — Calcium-bound reserve pool
#   c) PPa vs POCC — Oxide-occluded reserve pool
#
# Points sized by HNO3-total P stock; coloured and fitted by road intensity
# class; faceted by urbanisation duration class.
#
# Requires:
#   - data/MAIN_DATA_P_fractions_2026.csv  (run data/download_data.R first)
#
# Author:       Stephen Boahen Asabere
# Last updated: July 2026
################################################################################

# ── 0. Packages ────────────────────────────────────────────────────────────────
source("scripts/utils/load_packages.R")
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

# Filtered dataset: urban + reference classes, excluding soil profiles
d <- droplevels(subset(ksitotal_P, !(class %in% "Profile")))

# ── 3. Log-transforms ──────────────────────────────────────────────────────────
d <- d |>
  dplyr::mutate(
    log_p_available_gm2_lod = log1p(p_available_gm2_lod0),
    log_p_SOM_gm2           = log1p(p_SOM_gm2_lod0),
    log_p_Ca_gm2            = log1p(p_Ca_gm2_lod0),
    log_p_OCC_gm2           = log1p(p_OCC_gm2_lod0)
  )

# ── 4. Shared aesthetics ────────────────────────────────────────────────────────
formula <- y ~ x

col_vals  <- c("grey", "#BFA004FF", "#00B0F0")
fill_vals <- c("grey", "#BFA004FF", "#00B0F0")

shared_theme <- list(
  theme_light(base_size = 15),
  theme(
    axis.text.x      = element_text(size = 15),
    axis.text.y      = element_text(size = 15),
    legend.position  = "none",
    strip.background = element_blank(),
    strip.text.x     = element_text(colour = "grey30", face = "bold"),
    strip.text.y     = element_text(colour = "grey30", face = "bold", angle = 360),
    panel.grid       = element_blank(),
    panel.spacing.x  = unit(1.5, "lines")
  ),
  scale_fill_manual(values  = fill_vals),
  scale_color_manual(values = col_vals)
)

# ── 5. Individual panels ───────────────────────────────────────────────────────

# a) PPa vs PSOM
p_relatinship_pavail_psom <- ggplot(d,
    aes(y = log_p_available_gm2_lod, x = log_p_SOM_gm2, color = road_class)) +
  geom_point(
    aes(alpha = 0.5, size = P_total_HNO3_gm2_filled, fill = road_class),
    show.legend = FALSE, shape = 21, color = "black",
    position = position_jitterdodge(dodge.width = 0.6)
  ) +
  geom_smooth(method = "lm", linetype = 1, aes(color = road_class),
              se = TRUE, formula = formula) +
  facet_grid(. ~ class, scales = "free") +
  stat_poly_eq(use_label("eq", "R2", "P"), formula = formula, size = 5) +
  labs(
    tag = "a",
    y   = bquote("Log1p(y) P"[Pa] ~ "[" ~ g * ~~P ~ m^-2 ~ "]"),
    x   = bquote("Log1p(x) P"[SOM] ~ "[" ~ g * ~~P ~ m^-2 ~ "]")
  ) +
  shared_theme

# b) PPa vs PCa
p_relatinship_pavail_pca <- ggplot(d,
    aes(y = log_p_available_gm2_lod, x = log_p_Ca_gm2, color = road_class)) +
  geom_point(
    aes(alpha = 0.5, size = P_total_HNO3_gm2_filled, fill = road_class),
    show.legend = FALSE, shape = 21, color = "black",
    position = position_jitterdodge(dodge.width = 0.6)
  ) +
  geom_smooth(method = "lm", linetype = 1, aes(color = road_class),
              se = TRUE, formula = formula) +
  facet_grid(. ~ class, scales = "free") +
  expand_limits(x = 0, y = 0.5) +
  stat_poly_eq(use_label("eq", "R2", "P"), formula = formula, size = 5) +
  labs(
    tag = "b",
    y   = bquote("Log1p(y) P"[Pa] ~ "[" ~ g * ~~P ~ m^-2 ~ "]"),
    x   = bquote("Log1p(x) P"[Ca] ~ "[" ~ g * ~~P ~ m^-2 ~ "]")
  ) +
  shared_theme

# c) PPa vs POCC
p_relatinship_pavail_pocc <- ggplot(d,
    aes(y = log_p_available_gm2_lod, x = log_p_OCC_gm2, color = road_class)) +
  geom_point(
    aes(alpha = 0.5, size = P_total_HNO3_gm2_filled, fill = road_class),
    show.legend = FALSE, shape = 21, color = "black",
    position = position_jitterdodge(dodge.width = 0.6)
  ) +
  geom_smooth(method = "lm", linetype = 1, aes(color = road_class),
              se = TRUE, formula = formula) +
  facet_grid(. ~ class, scales = "free") +
  stat_poly_eq(use_label("eq", "R2", "P"), formula = formula, size = 5) +
  labs(
    tag = "c",
    y   = bquote("Log1p(y) P"[Pa] ~ "[" ~ g * ~~P ~ m^-2 ~ "]"),
    x   = bquote("Log1p(x) P"[OCC] ~ "[" ~ g * ~~P ~ m^-2 ~ "]")
  ) +
  shared_theme

# ── 6. Composite (stacked vertically) ──────────────────────────────────────────
fig6 <- p_relatinship_pavail_psom /
        p_relatinship_pavail_pca  /
        p_relatinship_pavail_pocc

# ── 7. Save ────────────────────────────────────────────────────────────────────
out_dir <- "output/figures"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

ggsave(file.path(out_dir, "Figure6.png"), fig6,
       width = 45, height = 40, units = "cm", dpi = 300)

ggsave(file.path(out_dir, "Figure6.pdf"), fig6,
       width = 20, height = 15)

message("\u2713 Figure 6 saved to ", out_dir)

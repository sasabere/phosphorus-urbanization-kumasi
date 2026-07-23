################################################################################
# Figure 5: Mean Relative Proportions of Soil P Fractions
#
# Produces a 100%-stacked bar chart showing the mean share of each P fraction
# (PPa, PSOM, PCa, POCC) relative to the extractable P sum, across six
# urbanisation groups ordered from reference → short-duration → long-duration.
#
# Requires:
#   - data/MAIN_DATA_P_fractions_2026.csv  (run data/download_data.R first)
#
# Author:       Stephen Boahen Asabere
# Last updated: July 2026
################################################################################

# ── 0. Packages ────────────────────────────────────────────────────────────────
source("scripts/load_packages.R")

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

# ── 3. Compute mean relative proportions ───────────────────────────────────────
pct_long <- d |>
  dplyr::select(sample_id, class, road_class, urbimpact,
                p_avail_PERCENT_sumtotalP_lod0,
                p_SOM_PERCENT_sumtotalP_lod0,
                p_Ca_PERCENT_sumtotalP_lod0,
                p_OCC_PERCENT_sumtotalP_lod0) |>
  tidyr::pivot_longer(
    cols      = tidyr::contains("_PERCENT_"),
    names_to  = "pfraction",
    values_to = "pct"
  ) |>
  dplyr::mutate(
    pfraction = stringr::str_remove(pfraction, "_PERCENT_.*$"),
    pfraction = factor(pfraction, levels = c("p_avail", "p_SOM", "p_Ca", "p_OCC"))
  )

pct_sum_cr <- pct_long |>
  dplyr::group_by(class, road_class, urbimpact, pfraction) |>
  dplyr::summarise(pct = mean(pct, na.rm = TRUE), .groups = "drop") |>
  dplyr::filter(!is.na(pfraction))

# ── 4. Figure ──────────────────────────────────────────────────────────────────
labels_Pfractions <- c(
  "p_avail" = expression(P[Pa]),
  "p_SOM"   = expression(P[SOM]),
  "p_Ca"    = expression(P[Ca]),
  "p_OCC"   = expression(P[OCC])
)

p_relative <- ggplot(pct_sum_cr, aes(x = urbimpact, y = pct, fill = pfraction)) +

  geom_col(position = "fill") +

  # percentage labels centred in each stack segment
  geom_text(
    aes(label = scales::percent(pct / 100, accuracy = 1), group = pfraction),
    position = position_fill(vjust = 0.5),
    size  = 6,
    color = "black"
  ) +

  # vertical dividers between reference / short-duration / long-duration blocks
  geom_vline(xintercept = 2.5, col = "grey70", linewidth = 0.5) +
  geom_vline(xintercept = 4.5, col = "grey70", linewidth = 0.5) +
  geom_hline(yintercept = 0,   col = "grey70", linewidth = 0.5) +

  # block annotations
  annotate("text", y = 1, x = 1.5, label = "REFERENCE",
           size = 5, fontface = "italic", vjust = -1.03) +
  annotate("text", y = 1, x = 3.5, label = "Short-duration",
           size = 5, fontface = "italic", vjust = -1.03) +
  annotate("text", y = 1, x = 5.5, label = "Long-duration",
           size = 5, fontface = "italic", vjust = -1.03) +

  scale_x_discrete(labels = c("RURAL", "FOREST",
                               "Low-intensity", "High-intensity",
                               "Low-intensity", "High-intensity")) +

  scale_fill_manual(
    values = c("#018571", "#80CDC1", "#DFC27D", "#A6611A"),
    labels = labels_Pfractions
  ) +

  labs(
    x = NULL,
    y = expression("Mean relative P proportion [ % ]")
  ) +

  theme_light(base_size = 15) +
  theme(
    axis.text.x      = element_text(size = 15),
    axis.text.y      = element_text(size = 15),
    legend.position  = "top",
    legend.title     = element_blank(),
    strip.background = element_blank(),
    strip.text.x     = element_text(colour = "grey30", face = "bold"),
    strip.text.y     = element_text(colour = "grey30", face = "bold"),
    panel.grid       = element_blank(),
    panel.spacing.x  = unit(1.5, "lines"),
    plot.background  = element_rect(color = "black", fill = NA, linewidth = 0.5)
  )

# ── 5. Save ────────────────────────────────────────────────────────────────────
out_dir <- "output/figures"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

ggsave(file.path(out_dir, "Figure5.png"), p_relative,
       width = 30, height = 25, units = "cm", dpi = 300)

ggsave(file.path(out_dir, "Figure5.pdf"), p_relative,
       width = 15, height = 10)

message("\u2713 Figure 5 saved to ", out_dir)

################################################################################
# baseboxplot_rdinfluence_points_Shape()
#
# Extends baseboxplot_rdinfluence() with point shape mapped to LOD/LOQ status:
#   >=LOQ   → filled circle (21)
#   LOD–LOQ → open triangle (2)
#   <LOD    → asterisk (8)
#
# Arguments:
#   dataframe     Data frame containing the variables below
#   x_col         Column name for x-axis grouping (e.g. "class")
#   y_col         Column name for the response variable
#   z_class_col   Column name for the dodging/colour variable (e.g. "road_class")
#   status_col    Column name for LOD/LOQ status (character: "<LOD","LOD–LOQ",">=LOQ")
#   dodge_width   Width passed to position_dodge2 / position_jitterdodge
#   boxplot_width Width of the boxplot boxes
#   alpha_val     Point and box transparency
#   fatten_val    Median line thickness
#
# Author:       Stephen Boahen Asabere
# Last updated: July 2026
################################################################################

baseboxplot_rdinfluence_points_Shape <- function(dataframe, x_col, y_col, z_class_col,
                                                  status_col    = NULL,
                                                  dodge_width   = 0.9,
                                                  boxplot_width = 0.6,
                                                  alpha_val     = 0.5,
                                                  fatten_val    = 0) {

  pd  <- position_dodge2(width = dodge_width, preserve = "single")
  pjd <- position_jitterdodge(jitter.width = 0.2, jitter.height = 0,
                               dodge.width  = dodge_width)

  ggplot(dataframe, aes(x = .data[[x_col]], y = .data[[y_col]])) +

    # jittered points with optional shape-by-status
    geom_point(
      aes(fill  = .data[[z_class_col]],
          shape = if (!is.null(status_col)) .data[[status_col]] else NULL,
          group = interaction(.data[[x_col]], .data[[z_class_col]])),
      alpha = alpha_val, size = 3, color = "black",
      position = pjd
    ) +

    # shape scale (only when status_col is supplied)
    {if (!is.null(status_col))
      scale_shape_manual(
        values = c("<LOD" = 8, "LOD\u2013LOQ" = 2, ">=LOQ" = 21),
        breaks = c("<LOD", "LOD\u2013LOQ", ">=LOQ"),
        name   = "LOD/LOQ"
      )
    } +

    # dodged boxplots
    geom_boxplot(
      aes(color = .data[[z_class_col]],
          fill  = .data[[z_class_col]],
          group = interaction(.data[[x_col]], .data[[z_class_col]])),
      outlier.shape = NA, alpha = alpha_val,
      width  = boxplot_width,
      fatten = fatten_val, lwd = 0.9,
      position = pd
    ) +

    theme_light(base_size = 15) +
    labs(x = "") +
    theme(
      axis.text.x      = element_text(size = 15),
      axis.text.y      = element_text(size = 15),
      legend.title     = element_blank(),
      legend.position  = c(0.14, 0.90),
      strip.background = element_blank(),
      strip.text.x     = element_text(colour = "grey30", face = "bold"),
      strip.text.y     = element_text(colour = "grey30", face = "bold", angle = 360),
      plot.title       = element_text(hjust = 0.5, face = "bold.italic"),
      panel.grid       = element_blank(),
      panel.spacing.x  = unit(1.5, "lines")
    ) +
    theme(axis.text.x = element_text(
      colour = c("grey10", "grey10", "black", "black", "black")
    )) +

    annotate("rect", xmin = -Inf, xmax = 2.2,
             ymin = -Inf, ymax = Inf, alpha = 0.25) +

    scale_fill_manual(values = c("grey30", "#BFA004FF", "#00B0F0")) +
    guides(fill = "none") +
    scale_color_manual(
      values = c("grey30", "#BFA004FF", "#00B0F0"),
      labels = c("Reference", "Low-intensity", "High-intensity")
    ) +

    stat_summary(
      aes(group = interaction(.data[[x_col]], .data[[z_class_col]])),
      geom = "crossbar", width = boxplot_width, color = "white",
      fatten = 3, position = pd,
      fun.data = function(x) c(y = median(x), ymin = median(x), ymax = median(x))
    ) +

    stat_summary(
      aes(group = interaction(.data[[x_col]], .data[[z_class_col]])),
      color = "black", size = 0.4,
      position = pd
    )
}

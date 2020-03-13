ggplot(
    cohens_d_by_subsystem,
    aes(
        x = subsystem_priority,
        y = cohens_d,
        color = if_else(cohens_d > 0, "up_regulated", "down_regulated"),
        alpha = if_else(adjusted_p_value < 0.1, "significant", "insignificant")
    )
) +
ggtitle("Up- and Down-Regulated Reactions Cross Pathway Boundaries") +
xlab("") +
ylab("Cohen's d") +
scale_color_manual(
    values = c(up_regulated = "#ca0020", down_regulated = "#0571b0"),
    guide = FALSE
) +
scale_alpha_manual(
    name = "",
    values = c(significant = 1, insignificant = 0.25),
    labels = c(significant = "BH-adjusted p-value < 0.1", insignificant = "insignificant")
) +
coord_flip() +
geom_point() +
geom_hline(yintercept = 0, linetype = "dashed") +
theme_bw() +
theme(legend.position = "bottom", legend.direction = "horizontal")

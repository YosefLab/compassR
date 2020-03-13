library(compassR)
library(tidyverse)

compass_settings <- CompassSettings$new(
    user_data_directory = system.file("extdata", "Th17", package = "compassR"),
    cell_id_col_name = "cell_id",
    gene_id_col_name = "HGNC.symbol"
)
compass_data <- CompassData$new(compass_settings)
compass_analyzer <- CompassAnalyzer$new(compass_settings)

group_A_cell_ids <-
    compass_data$cell_metadata %>%
    filter(cell_type == "Th17p") %>%
    pull(cell_id)
group_B_cell_ids <-
    compass_data$cell_metadata %>%
    filter(cell_type == "Th17n") %>%
    pull(cell_id)
wilcoxon_results <- compass_analyzer$conduct_wilcoxon_test(
    compass_data$reaction_consistencies,
    group_A_cell_ids,
    group_B_cell_ids,
    for_metareactions = FALSE
)

cohens_d_by_subsystem <-
    wilcoxon_results %>%
    left_join(
        select(compass_data$reaction_partitions, "reaction_id", "reaction_no_direction"),
        by = "reaction_id"
    ) %>%
    left_join(
        compass_data$reaction_metadata,
        by = "reaction_no_direction"
    ) %>%
    # Keep only "confident reactions", as defined in our paper.
    filter(!is.na(EC_number)) %>%
    filter(confidence == "0" | confidence == "4") %>%
    # Keep only "interesting subsystems", as defined in our paper.
    filter(!(subsystem == "Miscellaneous" | subsystem == "Unassigned")) %>%
    filter(!(startsWith(subsystem, "Transport") | startsWith(subsystem, "Exchange"))) %>%
    # Keep only subsystems of non-negligible size.
    group_by(subsystem) %>%
    filter(n() > 5) %>%
    ungroup() %>%
    # Order subsystems in a manner that will lend itself to a visually aesthetic plot.
    mutate(
        subsystem_priority = factor(subsystem) %>%
        fct_reorder2(
            cohens_d,
            adjusted_p_value,
            .fun = function(cohens_d, adjusted_p_value) {
                abs(median(cohens_d[adjusted_p_value < 0.1]))
            },
            .desc = FALSE
        )
    )

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
xlab("") + ylab("Cohen's d") +
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

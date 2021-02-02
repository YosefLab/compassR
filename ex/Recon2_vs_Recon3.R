library(compassR)
library(ggrepel)
library(tidyverse)

#Recon3

compass_settings <- CompassSettings$new(
    metabolic_model_directory = "~/yosef-lab/compassR/inst/extdata/RECON3",
    user_data_directory = "~/yosef-lab/compassR/inst/extdata/Th17_Recon3",
    cell_id_col_name = "cell_id",
    gene_id_col_name = "symbol"
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

facets <- c( "Glycolysis")

compass_scores_by_cell_type_Recon3 <-
    wilcoxon_results %>%
    left_join(
        select(compass_data$reaction_partitions, "reaction_id", "reaction_no_direction"),
        by = "reaction_id"
    ) %>%
    left_join(
        compass_data$reaction_metadata,
        by = "reaction_no_direction"
    ) %>%
    # Exclude non-mitochondrially localized reactions from TCA.
    mutate(subsystem = case_when(
        reaction_id == "SPMDOX_pos" ~ "Arginine and Proline Metabolism",
        subsystem == "Citric acid cycle" & !grepl("[m]", formula, fixed = TRUE) ~ "Other",
        TRUE ~ subsystem
    )) %>%
    # Assign reactions to the appropriate subsystem.
    mutate(
        subsystem_priority = factor(subsystem) %>%
        fct_recode(
            "Glycolysis" = "Glycolysis/gluconeogenesis",
            "TCA cycle" = "Citric acid cycle"
        ) %>%
        fct_collapse("Amino acid metabolism" = c(
            "Alanine and aspartate metabolism",
            "Arginine and Proline Metabolism",
            "beta-Alanine metabolism",
            "Cysteine Metabolism",
            "D-alanine metabolism",
            "Folate metabolism",
            "Glutamate metabolism",
            "Glycine, serine, alanine and threonine metabolism",
            "Histidine metabolism",
            "Lysine metabolism",
            "Methionine and cysteine metabolism",
            "Taurine and hypotaurine metabolism",
            "Tryptophan metabolism",
            "Tyrosine metabolism",
            "Urea cycle",
            "Valine, leucine, and isoleucine metabolism"
        )) %>%
        fct_other(keep = facets) %>%
        fct_relevel(facets)
    ) %>%
    # Keep only the subsystems for which we want to plot a facet.
    filter(subsystem_priority != "Other") %>%
    # Lower-bound the adjusted p-value.
    mutate(adjusted_p_value = if_else(
        subsystem_priority == "Amino acid metabolism" & adjusted_p_value <= 1e-12,
        1e-12,
        adjusted_p_value
    )) %>%
    # Assign descriptive labels to various reactions.
    mutate(label = case_when(
        reaction_id == "PGM_neg" ~ "phosphoglycerate mutase (PGAM)",
        reaction_id == "LDH_L_neg" ~ "lactate dehydrogenase",
        reaction_id == "PDHm_pos" ~ "pyruvate dehydrogenase (PDH)",
        reaction_id == "TPI_neg" ~ "triosephosphate isomerase (DHAP forming)",
        reaction_id == "FACOAL1821_neg" ~ "long-chain fatty-acid-CoA ligase",
        reaction_id == "r1257_pos" ~ "long-chain fatty-acid-CoA ligase",
        reaction_id == "FACOAL1831_neg" ~ "long-chain fatty-acid-CoA ligase",
        reaction_id == "CSNATr_neg" ~ "carnitine O-acetyltransferase",
        reaction_id == "C160CPT1_pos" ~ "carnitine O-palmitoyltransferase",
        reaction_id == "ACONTm_pos" ~ "aconitate hydratase",
        reaction_id == "SUCOASm_pos" ~ "succinate-CoA ligase",
        reaction_id == "AKGDm_pos" ~ "alpha-ketoglutarate dehydrogenase",
        reaction_id == "SUCD1m_pos" ~ "succinate dehydrogenase",
        reaction_id == "ICDHyrm_pos" ~ "isocitrate dehydrogenase",
        reaction_id == "CK_pos" ~ "creatine\nkinase",
        reaction_id == "PGCD_pos" ~ "phosphoglycerate dehydrogenase",
        reaction_id == "ARGSS_pos" ~ "arginosuccinate synthase",
        reaction_id == "r0281_neg" ~ "putrescine diamine oxidase",
        reaction_id == "SPMDOX_pos" ~ "spermidine dehydrogenase (spermidine -> GABA)",
        reaction_id == "ARGDCm_pos" ~ "arginine decarboxylase",
        reaction_id == "AGMTm_pos" ~ "agmatinase",
        reaction_id == "GHMT2r_pos" ~ "serine hydroxymethyltransferase",
        reaction_id == "AHC_pos" ~ "adenosylhomocysteinase",
        reaction_id == "METAT_pos" ~ "methionine adenosyltransferase",
        reaction_id == "METS_pos" ~ "methionine\nsynthase",
        reaction_id == "ARGN_pos" ~ "arginase",
        TRUE ~ ""
    ))

# Recon2

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

facets <- c( "Glycolysis")

compass_scores_by_cell_type_Recon2 <-
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
    # Exclude non-mitochondrially localized reactions from TCA.
    mutate(subsystem = case_when(
        reaction_id == "SPMDOX_pos" ~ "Arginine and Proline Metabolism",
        subsystem == "Citric acid cycle" & !grepl("[m]", formula, fixed = TRUE) ~ "Other",
        TRUE ~ subsystem
    )) %>%
    # Assign reactions to the appropriate subsystem.
    mutate(
        subsystem_priority = factor(subsystem) %>%
        fct_recode(
            "Glycolysis" = "Glycolysis/gluconeogenesis",
            "TCA cycle" = "Citric acid cycle"
        ) %>%
        fct_collapse("Amino acid metabolism" = c(
            "Alanine and aspartate metabolism",
            "Arginine and Proline Metabolism",
            "beta-Alanine metabolism",
            "Cysteine Metabolism",
            "D-alanine metabolism",
            "Folate metabolism",
            "Glutamate metabolism",
            "Glycine, serine, alanine and threonine metabolism",
            "Histidine metabolism",
            "Lysine metabolism",
            "Methionine and cysteine metabolism",
            "Taurine and hypotaurine metabolism",
            "Tryptophan metabolism",
            "Tyrosine metabolism",
            "Urea cycle",
            "Valine, leucine, and isoleucine metabolism"
        )) %>%
        fct_other(keep = facets) %>%
        fct_relevel(facets)
    ) %>%
    # Keep only the subsystems for which we want to plot a facet.
    filter(subsystem_priority != "Other") %>%
    # Lower-bound the adjusted p-value.
    mutate(adjusted_p_value = if_else(
        subsystem_priority == "Amino acid metabolism" & adjusted_p_value <= 1e-12,
        1e-12,
        adjusted_p_value
    )) %>%
    # Assign descriptive labels to various reactions.
    mutate(label = case_when(
        reaction_id == "PGM_neg" ~ "phosphoglycerate mutase (PGAM)",
        reaction_id == "LDH_L_neg" ~ "lactate dehydrogenase",
        reaction_id == "PDHm_pos" ~ "pyruvate dehydrogenase (PDH)",
        reaction_id == "TPI_neg" ~ "triosephosphate isomerase (DHAP forming)",
        reaction_id == "FACOAL1821_neg" ~ "long-chain fatty-acid-CoA ligase",
        reaction_id == "r1257_pos" ~ "long-chain fatty-acid-CoA ligase",
        reaction_id == "FACOAL1831_neg" ~ "long-chain fatty-acid-CoA ligase",
        reaction_id == "CSNATr_neg" ~ "carnitine O-acetyltransferase",
        reaction_id == "C160CPT1_pos" ~ "carnitine O-palmitoyltransferase",
        reaction_id == "ACONTm_pos" ~ "aconitate hydratase",
        reaction_id == "SUCOASm_pos" ~ "succinate-CoA ligase",
        reaction_id == "AKGDm_pos" ~ "alpha-ketoglutarate dehydrogenase",
        reaction_id == "SUCD1m_pos" ~ "succinate dehydrogenase",
        reaction_id == "ICDHyrm_pos" ~ "isocitrate dehydrogenase",
        reaction_id == "CK_pos" ~ "creatine\nkinase",
        reaction_id == "PGCD_pos" ~ "phosphoglycerate dehydrogenase",
        reaction_id == "ARGSS_pos" ~ "arginosuccinate synthase",
        reaction_id == "r0281_neg" ~ "putrescine diamine oxidase",
        reaction_id == "SPMDOX_pos" ~ "spermidine dehydrogenase (spermidine -> GABA)",
        reaction_id == "ARGDCm_pos" ~ "arginine decarboxylase",
        reaction_id == "AGMTm_pos" ~ "agmatinase",
        reaction_id == "GHMT2r_pos" ~ "serine hydroxymethyltransferase",
        reaction_id == "AHC_pos" ~ "adenosylhomocysteinase",
        reaction_id == "METAT_pos" ~ "methionine adenosyltransferase",
        reaction_id == "METS_pos" ~ "methionine\nsynthase",
        reaction_id == "ARGN_pos" ~ "arginase",
        TRUE ~ ""
    ))

compass_scores_by_cell_type <-
    merge(compass_scores_by_cell_type_Recon2, compass_scores_by_cell_type_Recon3, by = "reaction_id")

ggplot(
    compass_scores_by_cell_type,
    aes(
        x = cohens_d.x,
        y = cohens_d.y
    )
) +
ggtitle("Differential COMPASS Scores for Recon2 vs Recon3") +
xlab("Cohen's d for Recon 2") + ylab("Cohen's d for Recon 3") +
xlim(-0.25, 0.6) + ylim(-0.25, 0.6) +
geom_point(size = 3, alpha = 0.5, aes(colour =
                   (-log10(adjusted_p_value.x) > 1))
        ) +
scale_colour_manual(name = 'Recon2 p-value < 0.1', values = setNames(c('dark green','purple'), c(T, F))) +
geom_vline(xintercept = 0, show.legend=TRUE) +
geom_abline(linetype="dashed", color = "blue") +
geom_text_repel(
    aes(label = label.x),
    min.segment.length = 0.1,
    point.padding = 0.5,
    size = 3,
    seed = 7
) +
theme_bw()

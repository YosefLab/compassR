#' Title
#' 
#' Description
#' 
#' @param tbd the first param
#' 
#' @return the output
#' 
#' @export
tbd <- function() {
}



compass_rxn_df <- # join metareactions with annotated_reactions to get a tibble with columns:
#     reaction_name (aka rxn_code),
#     metareaction_id (aka meta_rxn),
#     unannotated_reaction (aka rxn_code_no_direction),
#     annotation (aka direction)
compass_rxn_df %<>%
    left_join(
        as_tibble(rxn_df), # rxn_df is loaded from RECON2/reaction_metadata.csv # TODO: right?
        by = c("unannotated_reaction" = "rxn_code_nodirection") # TODO: Is the reaction metadata always going to include a "rxn_code_nodirection" column, or you know, a column with the same purpose but possibly a different name?
    ) %>%
    left_join(
        tibble( # RECON$model is ??? # TODO: ???
            unannotated_reaction = RECON$model$rxns, # TODO: Will the model always have this column, or at least a different column with the same purpose but possibly a different name?
            rxn_confidence = RECON$model$rxnConfidenceScores # TODO: Will the model always have this column, or at least a different column with the same purpose but possibly a different name?
        ),
        by = "unannotated_reaction"
    )

rxn_consistency <- # reaction_consistencies before log2 and sweeping out column means
mat <- # reaction_consistencies after log2, sweeping out column means, and optionally scaling stddev

meta_rxn_consistency <-
    mat %>% # TODO: Should mat be centered (and optionally scaled)? Or would it be better to use the raw mat here, and then center + optionally scale meta_rxn_consistency once we're done constructing it?
    as_tibble(rownames = "reaction_name") %>%
    #redundant because I do inner join, but no reason to explicitly filter
    filter(reaction_name %in% rownames(reaction_consistencies)) %>%
    inner_join(
        select(compass_rxn_df, reaction_name, metareaction_id),
        by = "reaction_name"
    ) %>%
    group_by(metareaction_id) %>%
    #maybe mean is suboptimal for spearman-matching rows, but sum won't work too then.. # TODO: Huh?
    summarize_at(vars(-reaction_name), mean) %>%
    ungroup() %>%
    arrange(metareaction_id) %>%
    column_to_rownames("metareaction_id") %>%
    data.matrix()

mat <- meta_rxn_consistency



linear_scale_tpm <- 2 ^ tpms_mat - 1 # tpms_mat is ??? # TODO: ???
total_activity <- colSums(linear_scale_tpm)
library(MetabolicPackage)
RECON <- get("recon2") # TODO: This loads a variable named lower-case recon2. What's it bound to?
metabolic_activity <- colSums(linear_scale_tpm[intersect(rownames(linear_scale_tpm), RECON$gene_md$HGNC.symbol),])

to_add <- c("GLUNm_pos", "GLNS_pos", "PDHm_pos", "biomass_reaction_pos") # TODO: What's this? I assume they're column names for some data set, but what data set? Where's it loaded from?

library(uwot)
res_umap <- uwot::umap(t(mat), scale = "none")
anno <-
    tibble(DepMap_ID = colnames(mat), UMAP1 = res_umap[,1], UMAP2 = res_umap[,2]) %>%
    mutate(
        total_consistency = colSums(rxn_consistency[, colnames(mat)]), # TODO: But rxn_consistency is pre-log values ... ?
        total_log_consistency = colSums(mat),
        mean_consistency = colMeans(mat)
    ) %>%
    #note that there are samples with expression and no metadata and vice versa # TODO: Huh?
    inner_join(sample_md, by = "DepMap_ID") %>% # TODO: What is sample_md?
    mutate(
        major_type = factor(disease) %>% fct_other(keep = c("Leukemia", "Lymphoma", "Myeloma"), other_level = "Solid tumor"),
        is_solid_tumor = fct_collapse(major_type, "Lymphoid tumor" = c("Leukemia", "Lymphoma", "Myeloma"))
    ) %>%
    left_join(
        enframe(total_activity, "DepMap_ID", "total_activity"),
        by =  "DepMap_ID"
    ) %>%
    left_join(
        enframe(metabolic_activity, "DepMap_ID", "metabolic_activity"),
        by =  "DepMap_ID"
    ) %>%
    mutate(metabolic_activity_ratio = metabolic_activity / total_activity) %>%
    left_join(
        as_tibble(t(log2(rxn_consistency[to_add,])), rownames = "DepMap_ID"),
        by = "DepMap_ID"
    )
# TODO: How flexible should I make this? What do you envision the user having to specify exactly?
# TODO: Then there's all the ggplot calls that generate the UMAPs. What should the user need to specify to make such a call?

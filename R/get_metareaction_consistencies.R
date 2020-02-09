#' Title
#' 
#' Description
#' 
#' @param reaction_consistencies the first param
#' @param cluster_strength the second param
#' @param ... A param.
#' 
#' @return the output
#' 
#' @importFrom dplyr %>%
#' 
#' @noRd
get_metareaction_consistencies <- function(reaction_consistencies, ..., cluster_strength) {
    metareactions <- get_metareactions(reaction_consistencies, cluster_strength)
    metareaction_consistencies <-
        reaction_consistencies %>%
        tibble::as_tibble(rownames = "reaction_id") %>%
        dplyr::inner_join(metareactions, by = "reaction_id") %>%
        dplyr::select(-reaction_id) %>%
        dplyr::group_by(metareaction_id) %>%
        dplyr::summarize_all(mean) %>% # TODO: Pick a better summary statistic than the mean.
        dplyr::ungroup() %>%
        tibble::column_to_rownames("metareaction_id") %>%
        data.matrix()
    metareaction_consistencies
}

#' Title
#' 
#' Description
#' 
#' @param reaction_consistencies the first param
#' @param cluster_strength the second param
#' 
#' @return the output
#' 
#' @importFrom dplyr %>%
#' 
#' @noRd
get_metareactions <- function(reaction_consistencies, cluster_strength) {
    pairwise_reaction_correlations <- cor(t(reaction_consistencies), method = "spearman")
    pairwise_reaction_distances <- as.dist(1 - pairwise_reaction_correlations)
    reaction_hierarchy <- hclust(pairwise_reaction_distances, method = "complete")
    metareactions <-
        cutree(reaction_hierarchy, h = cluster_strength) %>%
        tibble::enframe(name = "reaction_id", value = "metareaction_id")
    metareactions
}

#' @title Title
#' 
#' @description
#' Description.
#' 
#' @param reaction_consistencies A param.
#' @param cluster_strength A param.
#' @param ... A param.
#' 
#' @return An output.
#' 
#' @importFrom magrittr %>%
#' 
#' @noRd
get_metareactions <- function(reaction_consistencies, ..., cluster_strength) {
    pairwise_reaction_correlations <- cor(t(reaction_consistencies), method = "spearman")
    pairwise_reaction_distances <- as.dist(1 - pairwise_reaction_correlations)
    reaction_hierarchy <- hclust(pairwise_reaction_distances, method = "complete")
    metareactions <-
        cutree(reaction_hierarchy, h = cluster_strength) %>%
        tibble::enframe(name = "reaction_id", value = "metareaction_id")
    metareactions
}

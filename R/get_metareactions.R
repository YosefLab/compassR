#' Title
#' 
#' Description
#' 
#' @param reaction_consistencies the first param
#' @param cluster_strength the second param
#' 
#' @return the output
#' 
#' @importFrom magrittr %>%
#' 
#' @export
get_metareactions <- function(reaction_consistencies, cluster_strength = 0.1) {
    pairwise_reaction_correlations <- stats::cor(t(reaction_consistencies), method = "spearman")
    pairwise_reaction_distances <- stats::as.dist(1 - pairwise_reaction_correlations)
    reaction_hierarchy <- stats::hclust(pairwise_reaction_distances, method = "complete")
    metareactions <-
        stats::cutree(reaction_hierarchy, h = cluster_strength) %>%
        data.frame() %>%
        dplyr::rename(metareaction_id = 1) %>%
        tibble::rownames_to_column("reaction_name")
    metareactions
}
# TODO: Returns a data.frame with columns reaction_name <chr> and metareaction_id <int>.

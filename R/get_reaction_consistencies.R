#' @title Title
#'
#' @description
#' Description.
#'
#' @param reaction_consistencies_path A param.
#' @param min_consistency A param.
#' @param min_range A param.
#' @param ... A param.
#'
#' @return An output.
#'
#' @importFrom magrittr %>% %<>%
#'
#' @noRd
get_reaction_consistencies <- function(reaction_consistencies_path, ..., min_consistency, min_range) {
    reaction_consistencies <-
        read_compass_matrix(reaction_consistencies_path) %>%
        dplyr::rename(reaction_id = 1) %>%
        tibble::column_to_rownames("reaction_id") %>%
        as.data.frame() %>%
        drop_inconsistent_reactions(min_consistency = min_consistency) %>%
        drop_constant_reactions(min_range = min_range) %>%
        (function(x) { -log2(x) })() %>%
        sweep(2, colMeans(.))
    reaction_consistencies
}

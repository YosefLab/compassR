#' @description
#' Description.
#'
#' @param compass_scores A param.
#' @param min_consistency A param.
#' @param min_range A param.
#' @param ... A param.
#'
#' @return An output.
#'
#' @importFrom magrittr %>% %<>%
#'
#' @noRd
get_reaction_consistencies <- function(compass_scores, ..., min_consistency, min_range) {
    reaction_consistencies <-
        compass_scores %>%
        drop_inconsistent_reactions(min_consistency = min_consistency) %>%
        drop_constant_reactions(min_range = min_range) %>%
        (function(x) { -log2(x) })() %>%
        sweep(2, colMeans(.))
    reaction_consistencies
}

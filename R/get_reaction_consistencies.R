#' @description
#' Description.
#'
#' @param compass_reaction_scores A param.
#' @param min_consistency A param.
#' @param min_range A param.
#' @param ... A param.
#'
#' @return An output.
#'
#' @importFrom magrittr %>% %<>%
#'
#' @noRd
get_reaction_consistencies <- function(compass_reaction_scores, ..., min_consistency, min_range) {
    reaction_consistencies <-
        compass_reaction_scores %>%
        drop_inconsistent_reactions(min_consistency = min_consistency) %>%
        drop_constant_reactions(min_range = min_range) %>%
        (function(x) { -log2(1+x) })() %>%
        #sweep(2, colMeans(.))
        sweep(1, apply(.,1,min))
    reaction_consistencies
}

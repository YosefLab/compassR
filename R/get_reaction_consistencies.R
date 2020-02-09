#' Title
#' 
#' Description
#' 
#' @param reaction_consistencies_file the first param
#' @param min_consistency the second param
#' @param min_range the third param
#' @param ... A param.
#' 
#' @return the output
#' 
#' @importFrom dplyr %>%
#' 
#' @noRd
get_reaction_consistencies <- function(reaction_consistencies_file, ..., min_consistency, min_range) {
    reaction_consistencies <-
        read_compass_matrix(reaction_consistencies_file) %>%
        dplyr::rename(reaction_id = 1) %>%
        tibble::column_to_rownames("reaction_id") %>%
        data.matrix() %>%
        drop_inconsistent_reactions(min_consistency) %>%
        drop_constant_reactions(min_range) %>%
        (function(x) { -log2(x) })() %>%
        sweep(2, colMeans(.))
    reaction_consistencies
}

#' Title
#' 
#' Description
#' 
#' @param reaction_consistencies the first param
#' @param min_consistency the second param
#' 
#' @return the output
#' 
#' @noRd
drop_inconsistent_reactions <- function(reaction_consistencies, min_consistency) {
    reactions_inconsistent_for_any_cells <- apply(reaction_consistencies <= min_consistency, 1, any)
    reactions_inconsistent_for_all_cells <- apply(reaction_consistencies <= min_consistency, 1, all)
    partially_inconsistent_reactions <- reactions_inconsistent_for_any_cells & !reactions_inconsistent_for_all_cells
    alert_of_drop(
        reactions_inconsistent_for_all_cells,
        "reactions are inconsistent for all cells."
    )
    alert_of_drop(
        partially_inconsistent_reactions,
        "reactions are inconsistent for a nonempty proper subset of cells.",
        TRUE
    )
    reaction_consistencies <- reaction_consistencies[!reactions_inconsistent_for_any_cells,]
    reaction_consistencies
}

#' Title
#' 
#' Description
#' 
#' @param reaction_consistencies the first param
#' @param min_range the second param
#' 
#' @return the output
#' 
#' @noRd
drop_constant_reactions <- function(reaction_consistencies, min_range) {
    constant_reactions <- apply(reaction_consistencies, 1, function(x) { max(x) - min(x) < min_range })
    alert_of_drop(
        constant_reactions,
        "reactions have too small a range of values."
    )
    reaction_consistencies <- reaction_consistencies[!constant_reactions,]
    reaction_consistencies
}
